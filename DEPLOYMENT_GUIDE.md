# Руководство по развертыванию LearnRuby

Это руководство описывает полный процесс развертывания приложения LearnRuby на продакшн-сервер.

## Содержание

1. Обзор архитектуры - схема CI/CD pipeline
2. Предварительные требования - необходимые инструменты и аккаунты
3. Настройка Docker Hub - создание аккаунта, токена и репозитория
4. Регистрация домена - настройка Cloudflare и SSL/TLS
5. Создание сервера - Hetzner Cloud, SSH-ключи, установка Docker
6. Настройка PostgreSQL - конфигурация как Docker accessory
7. Настройка DNS - A-записи в Cloudflare
8. GitHub Secrets - полный список всех необходимых секретов
9. CI/CD Pipeline - подробное объяснение структуры workflow
10. Первый деплой - пошаговая инструкция
11. Мониторинг и отладка - команды Kamal, SSH, решение типичных проблем

---

## Обзор архитектуры

### Используемые технологии

- **Kamal** - инструмент для деплоя Docker-контейнеров
- **Docker Hub** - реестр Docker-образов
- **Hetzner Cloud** - хостинг-провайдер
- **Cloudflare** - DNS и SSL
- **GitHub Actions** - CI/CD
- **PostgreSQL** - база данных
- **Redis** - кэширование и очереди

### Структура CI/CD

Мы используем **единый файл** `.github/workflows/ci.yml` для CI и CD.

```
CI/CD Pipeline:
┌─────────────┐   ┌─────────────┐   ┌─────────────┐   ┌─────────────┐
│  scan_ruby  │   │   scan_js   │   │    lint     │   │    test     │
│  (Brakeman) │   │ (importmap) │   │  (RuboCop)  │   │   (RSpec)   │
└─────────────┘   └─────────────┘   └─────────────┘   └─────────────┘
       │                 │                 │                 │
       └─────────────────┴─────────────────┴─────────────────┘
                                   │
                                   ▼
                        Параллельное выполнение
                                   │
                                   └──────────────────────────────────┐
                                                                      │
                                                                      ▼
                                                           ┌─────────────┐
                                                           │   deploy    │
                                                           │   (Kamal)   │
                                                           └─────────────┘
                                                           (только main branch)
```

---

## Предварительные требования

### Локальная машина

```bash
# Ruby и Rails
ruby --version  # >= 3.4
rails --version # >= 8.0

# Docker
docker --version

# GitHub CLI
gh --version

# Kamal
gem install kamal
kamal version
```

### Аккаунты

- [Docker Hub](https://hub.docker.com/) - для хранения Docker-образов
- [Hetzner Cloud](https://www.hetzner.com/cloud) - для сервера (или другой провайдер)
- [Cloudflare](https://www.cloudflare.com/) - для DNS и SSL
- [GitHub](https://github.com/) - для репозитория и CI/CD

---

## Настройка Docker Hub

### 1. Создание аккаунта

1. Зарегистрируйтесь на [hub.docker.com](https://hub.docker.com/)
2. Подтвердите email

### 2. Создание Access Token

1. Перейдите в **Account Settings** → **Security** → **Access Tokens**
2. Нажмите **New Access Token**
3. Настройки:
   - **Description**: `LearnRuby GitHub Actions`
   - **Access permissions**: `Read & Write`
4. **Сохраните токен** - он показывается только один раз!

### 3. Создание репозитория

1. **Create Repository**
2. Настройки:
   - **Name**: `learn-ruby`
   - **Visibility**: Public или Private

---

## Регистрация домена

### Cloudflare

1. Зарегистрируйте или перенесите домен в Cloudflare
2. Например: `learnruby.ru` или `rubylearning.com`

### Настройки SSL/TLS

1. Перейдите в **SSL/TLS** → **Overview**
2. Установите режим: **Full** (не Full Strict!)
   - Это позволяет использовать самоподписанный сертификат Let's Encrypt на сервере

---

## Создание сервера

### Hetzner Cloud

#### 1. Создание проекта

1. Войдите в [Hetzner Cloud Console](https://console.hetzner.cloud/)
2. **New Project** → `LearnRuby Production`

#### 2. Создание сервера

1. **Add Server**
2. Настройки:
   - **Location**: `Helsinki` или `Nuremberg` (ближе к пользователям)
   - **Image**: `Ubuntu 24.04`
   - **Type**: `CX22` (2 vCPU, 4 GB RAM) - минимум для Rails + PostgreSQL + Redis
   - **Networking**: IPv4 включен
   - **SSH Keys**: Добавьте ваш публичный ключ

#### 3. Генерация SSH-ключа (если нет)

```bash
# Генерация нового ключа
ssh-keygen -t ed25519 -C "deploy@learnruby" -f ~/.ssh/learnruby_deploy

# Копирование публичного ключа
cat ~/.ssh/learnruby_deploy.pub
```

#### 4. Начальная настройка сервера

```bash
# Подключение к серверу
ssh root@YOUR_SERVER_IP

# Обновление системы
apt update && apt upgrade -y

# Установка Docker
curl -fsSL https://get.docker.com | sh

# Проверка Docker
docker --version
docker run hello-world

# Создание Docker network для Kamal
docker network create kamal
```

---

## Настройка PostgreSQL

PostgreSQL разворачивается как Docker-контейнер через Kamal accessories.

### Конфигурация в deploy.yml

```yaml
accessories:
  db:
    image: postgres:16-alpine
    host: YOUR_SERVER_IP
    port: "127.0.0.1:5432:5432"  # Только localhost
    env:
      clear:
        POSTGRES_DB: learn_ruby_production
        POSTGRES_USER: learn_ruby
      secret:
        - DATABASE_PASSWORD
    directories:
      - data:/var/lib/postgresql/data
    options:
      network: kamal
```

### Важные моменты

1. **Порт привязан к localhost** - база недоступна извне
2. **Network: kamal** - контейнеры общаются через Docker network
3. **Persistent volume** - данные сохраняются при перезапуске

---

## Настройка DNS

### Cloudflare DNS Records

Добавьте следующие записи:

| Type | Name | Content | Proxy |
|------|------|---------|-------|
| A | @ | YOUR_SERVER_IP | Proxied |
| A | www | YOUR_SERVER_IP | Proxied |

### Проверка DNS

```bash
# Проверка A-записи
dig yourdomain.com +short

# Проверка распространения
nslookup yourdomain.com
```

---

## Настройка GitHub Secrets

### Переход к настройкам

1. GitHub Repository → **Settings** → **Secrets and variables** → **Actions**

### Необходимые секреты

| Secret | Описание | Пример |
|--------|----------|--------|
| `DOCKERHUB_USERNAME` | Имя пользователя Docker Hub | `yourusername` |
| `DOCKERHUB_TOKEN` | Access Token Docker Hub | `dckr_pat_xxx...` |
| `SSH_PRIVATE_KEY` | Приватный SSH-ключ | Содержимое `~/.ssh/learnruby_deploy` |
| `SERVER_IP` | IP-адрес сервера | `65.108.xx.xx` |
| `RAILS_MASTER_KEY` | Master key Rails | Содержимое `config/master.key` |
| `DATABASE_PASSWORD` | Пароль PostgreSQL | Сгенерированный пароль |

### Генерация пароля базы данных

```bash
# Генерация безопасного пароля
openssl rand -base64 32
```

### Получение SSH-ключа

```bash
# Копирование приватного ключа
cat ~/.ssh/learnruby_deploy
```

### Получение Rails master key

```bash
# Копирование master key
cat config/master.key
```

---

## Конфигурация deploy.yml

Перед деплоем обновите `config/deploy.yml`:

```yaml
# Замените на свои значения:
service: learn-ruby
image: YOUR_DOCKERHUB_USERNAME/learn-ruby

servers:
  web:
    hosts:
      - YOUR_SERVER_IP  # например: 65.108.56.69

proxy:
  ssl: true
  host: YOUR_DOMAIN  # например: learnruby.ru

registry:
  username: YOUR_DOCKERHUB_USERNAME

accessories:
  db:
    host: YOUR_SERVER_IP
  redis:
    host: YOUR_SERVER_IP
```

---

## Первый деплой

### Шаг 1: Обновите конфигурацию

```bash
# Отредактируйте config/deploy.yml
# Замените все placeholder'ы на реальные значения
```

### Шаг 2: Локальная проверка

```bash
# Проверка конфигурации Kamal
kamal config

# Проверка подключения к серверу
ssh root@YOUR_SERVER_IP "docker --version"
```

### Шаг 3: Запуск деплоя

```bash
# Коммит и пуш в main
git add .
git commit -m "Configure deployment"
git push origin main
```

### Шаг 4: Мониторинг CI/CD

```bash
# Просмотр запущенных workflows
gh run list

# Просмотр логов конкретного run
gh run view RUN_ID --log

# Просмотр только ошибок
gh run view RUN_ID --log-failed
```

### Шаг 5: Проверка деплоя

```bash
# Health check
curl -I https://yourdomain.com/up

# Проверка контейнеров на сервере
ssh root@YOUR_SERVER_IP "docker ps"

# Логи приложения
ssh root@YOUR_SERVER_IP "docker logs learn-ruby-web"
```

---

## Мониторинг и отладка

### Полезные команды Kamal

```bash
# Просмотр логов в реальном времени
kamal logs -f

# Подключение к Rails console
kamal console

# Подключение к bash в контейнере
kamal shell

# Подключение к базе данных
kamal dbc

# Запуск миграций
kamal migrate

# Перезапуск приложения
kamal app restart

# Откат к предыдущей версии
kamal rollback
```

### SSH-команды для сервера

```bash
# Статус контейнеров
docker ps -a

# Логи конкретного контейнера
docker logs learn-ruby-web --tail 100 -f

# Использование ресурсов
docker stats

# Состояние базы данных
docker exec learn-ruby-db psql -U learn_ruby -d learn_ruby_production -c "\dt"

# Очистка неиспользуемых образов
docker system prune -a
```

### Решение типичных проблем

#### Ошибка "solid_cache_entries does not exist"

Таблицы Solid Cache/Queue/Cable не созданы. Решение:

```bash
# На сервере
docker exec -it learn-ruby-web bin/rails db:migrate
```

#### Ошибка подключения к базе данных

1. Проверьте, что контейнер базы запущен:
   ```bash
   docker ps | grep learn-ruby-db
   ```

2. Проверьте сеть:
   ```bash
   docker network inspect kamal
   ```

3. Проверьте переменные окружения:
   ```bash
   docker exec learn-ruby-web env | grep DATABASE
   ```

#### Health check не проходит

1. Проверьте логи:
   ```bash
   docker logs learn-ruby-web --tail 50
   ```

2. Проверьте /up endpoint внутри контейнера:
   ```bash
   docker exec learn-ruby-web curl -v http://localhost:3000/up
   ```

---

## Структура файлов деплоя

```
.
├── .github/
│   └── workflows/
│       └── ci.yml              # CI/CD pipeline (единый файл)
├── .kamal/
│   └── secrets                 # Локальные секреты (не в git)
├── config/
│   ├── deploy.yml              # Конфигурация Kamal
│   └── database.yml            # Настройки базы данных
├── Dockerfile                   # Сборка образа
└── DEPLOYMENT_GUIDE.md         # Это руководство
```

---

## Чек-лист перед деплоем

- [ ] Docker Hub аккаунт создан
- [ ] Docker Hub access token сгенерирован
- [ ] Docker Hub репозиторий создан (`learn-ruby`)
- [ ] Домен зарегистрирован и настроен в Cloudflare
- [ ] SSL/TLS режим установлен в "Full"
- [ ] Сервер создан и настроен
- [ ] SSH-ключ добавлен на сервер
- [ ] Docker установлен на сервере
- [ ] Docker network 'kamal' создана
- [ ] DNS A-записи созданы
- [ ] `config/deploy.yml` обновлён с реальными значениями
- [ ] GitHub Secrets настроены:
  - [ ] DOCKERHUB_USERNAME
  - [ ] DOCKERHUB_TOKEN
  - [ ] SSH_PRIVATE_KEY
  - [ ] SERVER_IP
  - [ ] RAILS_MASTER_KEY
  - [ ] DATABASE_PASSWORD
- [ ] Тесты проходят локально

---

## После успешного деплоя

### Seed данных (опционально)

```bash
# На сервере через docker
docker exec -it learn-ruby-web bin/rails db:seed
```

### Создание администратора

```bash
# Через Rails console
kamal console

# В консоли:
User.create!(
  email: "admin@yourdomain.com",
  username: "admin",
  password: "secure_password",
  admin: true
)
```

---

## Контакты и ресурсы

- [Kamal Documentation](https://kamal-deploy.org/)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Docker Documentation](https://docs.docker.com/)
- [Hetzner Cloud Documentation](https://docs.hetzner.com/cloud/)
- [Cloudflare Documentation](https://developers.cloudflare.com/)
