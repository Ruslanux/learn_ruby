# LearnRuby - Web Application Plan

## Overview

Web-приложение для изучения **Ruby 3.4** (последняя стабильная версия) с интерактивными упражнениями в стиле Test-First Teaching.

**Референс:** Проект `learn_ruby` от TestFirst.org - набор из 16 упражнений с RSpec тестами.

---

## Архитектура приложения

```
learn_ruby/
├── app/
│   ├── models/
│   │   ├── user.rb
│   │   ├── lesson.rb
│   │   ├── exercise.rb
│   │   ├── user_progress.rb
│   │   └── code_submission.rb
│   ├── controllers/
│   │   ├── lessons_controller.rb
│   │   ├── exercises_controller.rb
│   │   └── code_runner_controller.rb
│   ├── services/
│   │   └── ruby_sandbox_service.rb
│   └── views/
├── config/
│   └── exercises/          # YAML файлы с упражнениями
└── lib/
    └── ruby_executor/      # Безопасный исполнитель Ruby кода
```

---

## Модули/Уроки (Lessons)

### Module 1: Основы Ruby (Beginner)
1. Hello World - функции и возвращаемые значения
2. Temperature - классы и базовая математика
3. Calculator - массивы и итерация
4. Simon Says - работа со строками

### Module 2: Работа с данными (Intermediate)
5. Pig Latin - манипуляция строками
6. Book Titles - капитализация и edge cases
7. Timer - форматирование времени
8. Dictionary - Hash и поиск

### Module 3: Продвинутые концепции (Advanced)
9. Silly Blocks - блоки, yield, closures
10. Performance Monitor - бенчмарки и профилирование
11. RPN Calculator - стек и алгоритмы
12. XML Document - DSL и метапрограммирование
13. Array Extensions - расширение встроенных классов
14. In Words - числа словами, рекурсия

### Module 4: Ruby 3.4 Features (Modern Ruby)
15. It Parameter - новый синтаксис `it` в блоках
16. Pattern Matching - сопоставление с образцом
17. Ractors - параллельное программирование
18. Data Classes - иммутабельные структуры данных
19. Prism Parser - работа с AST

---

## Промты для Claude Code

### Prompt 1: Инициализация проекта

```
Создай Rails 8 приложение learn_ruby с:
- PostgreSQL базой данных
- Devise для аутентификации
- Tailwind CSS для стилей
- Turbo и Stimulus для интерактивности
- RSpec для тестирования

Команда: rails new learn_ruby -d postgresql -c tailwind -T
Затем добавь gems: devise, rspec-rails, factory_bot_rails
```

### Prompt 2: Модели данных

```
Создай модели для приложения learn_ruby:

1. User (Devise):
   - email, encrypted_password
   - username: string
   - level: integer (default: 1)
   - total_points: integer (default: 0)

2. Lesson:
   - title: string
   - description: text
   - module_number: integer
   - position: integer
   - difficulty: enum (beginner, intermediate, advanced, modern)
   - ruby_version: string (default: "3.4")

3. Exercise:
   - lesson: references
   - title: string
   - description: text (markdown)
   - instructions: text (markdown)
   - hints: text (array в JSON)
   - starter_code: text
   - solution_code: text
   - test_code: text (RSpec)
   - topics: string[] (массив тегов)
   - points: integer
   - position: integer

4. UserProgress:
   - user: references
   - exercise: references
   - status: enum (not_started, in_progress, completed)
   - attempts: integer
   - last_code: text
   - completed_at: datetime
   - points_earned: integer

5. CodeSubmission:
   - user: references
   - exercise: references
   - code: text
   - result: text
   - passed: boolean
   - execution_time: float
   - created_at: datetime

Добавь индексы и связи.
```

### Prompt 3: Ruby Sandbox Service

```
Создай безопасный сервис для выполнения Ruby кода в app/services/ruby_sandbox_service.rb:

Требования:
1. Изолированное выполнение в Docker контейнере
2. Таймаут 10 секунд
3. Ограничение памяти 128MB
4. Запрет опасных операций (File, Net, System, etc.)
5. Поддержка RSpec тестов
6. Возврат структуры: { success: bool, output: string, errors: string, test_results: [] }

Используй gem 'docker-api' для управления контейнерами.
Создай отдельный Dockerfile для sandbox с Ruby 3.4.
```

### Prompt 4: Lessons Controller и Views

```
Создай контроллер и views для уроков:

LessonsController:
- index: список всех модулей и уроков
- show: детали урока с упражнениями
- Показывать прогресс пользователя

Views:
- Карточки модулей с progress bar
- Список уроков с иконками статуса (не начато, в процессе, завершено)
- Боковое меню с навигацией
- Использовать Tailwind CSS

Добавь хлебные крошки и кнопки навигации.
```

### Prompt 5: Exercise Editor

```
Создай интерактивный редактор кода для упражнений:

Компоненты:
1. Monaco Editor (или CodeMirror) с подсветкой Ruby
2. Панель инструкций (markdown rendered)
3. Панель тестов (RSpec код для просмотра)
4. Кнопка "Run Tests"
5. Панель результатов с цветовой индикацией
6. Счетчик попыток и таймер

Stimulus контроллеры:
- code_editor_controller.js
- test_runner_controller.js
- timer_controller.js

Используй Turbo Streams для обновления результатов без перезагрузки.
```

### Prompt 6: Code Runner Controller

```
Создай CodeRunnerController для выполнения кода:

Endpoints:
POST /exercises/:id/run
- Принимает: { code: string }
- Вызывает RubySandboxService
- Сохраняет CodeSubmission
- Возвращает Turbo Stream с результатами

POST /exercises/:id/submit
- Проверяет код на прохождение всех тестов
- Обновляет UserProgress
- Начисляет очки
- Показывает поздравление при успехе

Добавь rate limiting (max 10 запросов в минуту).
```

### Prompt 7: Seed Data - Базовые упражнения

```
Создай db/seeds/exercises.rb с упражнениями:

Урок 1: Hello (по образцу 00_hello):
- Exercise: "hello" функция возвращающая "Hello!"
- Exercise: "greet(name)" функция с аргументом
- Test code в формате RSpec

Урок 2: Temperature:
- ftoc(fahrenheit) - конвертация в Celsius
- ctof(celsius) - конвертация в Fahrenheit

Урок 3: Calculator:
- add(a, b)
- subtract(a, b)
- sum(array)
- multiply(a, b)
- power(base, exp)
- factorial(n)

Формат YAML для каждого упражнения с полями:
title, description, instructions, hints, starter_code, solution_code, test_code, topics, points
```

### Prompt 8: Ruby 3.4 Specific Exercises

```
Создай упражнения для Ruby 3.4 фич:

1. It Parameter:
   - Упражнение: переписать код с _1 на it
   - Примеры: map, select, each_with_object

2. Pattern Matching:
   - Базовый синтаксис case/in
   - Destructuring arrays и hashes
   - Guard clauses

3. Data Classes:
   - Создание Data.define
   - Иммутабельность
   - with() для обновлений

4. Ractors:
   - Базовый Ractor.new
   - Отправка/получение сообщений
   - Ractor.main?

5. Range#step улучшения:
   - Итерация с custom типами
   - Time ranges

Каждое упражнение должно демонстрировать практическое применение.
```

### Prompt 9: Progress Tracking и Gamification

```
Добавь систему прогресса и геймификации:

1. Dashboard пользователя:
   - Общий прогресс (% выполненных упражнений)
   - Streak (дни подряд)
   - Уровень и очки
   - Badges/достижения

2. Achievements:
   - First Blood - первое упражнение
   - Module Master - завершить модуль
   - Speed Runner - решить за 1 попытку
   - Block Master - все упражнения по блокам
   - Ruby 3.4 Pioneer - все новые фичи

3. Leaderboard:
   - Топ 10 по очкам
   - Топ по streak
   - Weekly champions

4. Модели:
   - Achievement
   - UserAchievement
   - DailyStreak
```

### Prompt 10: Admin Panel

```
Создай административную панель:

1. Управление уроками и упражнениями:
   - CRUD для Lessons
   - CRUD для Exercises
   - Markdown preview для описаний
   - Валидация RSpec тестов

2. Статистика:
   - Количество пользователей
   - Популярные упражнения
   - Средние попытки на упражнение
   - Процент успеха

3. Модерация:
   - Просмотр submissions
   - Бан пользователей
   - Логи выполнения кода

Используй Turbo для inline редактирования.
```

### Prompt 11: API для мобильного приложения

```
Создай JSON API для будущего мобильного приложения:

Endpoints:
- GET /api/v1/lessons
- GET /api/v1/lessons/:id/exercises
- GET /api/v1/exercises/:id
- POST /api/v1/exercises/:id/run
- POST /api/v1/exercises/:id/submit
- GET /api/v1/users/me/progress
- GET /api/v1/leaderboard

Аутентификация через JWT tokens.
Используй Jbuilder или ActiveModel::Serializers.
Rate limiting через Rack::Attack.
```

### Prompt 12: Deployment Configuration

```
Подготовь приложение к деплою:

1. Docker:
   - Dockerfile для основного приложения
   - docker-compose.yml с services:
     - web (Rails)
     - db (PostgreSQL)
     - redis (для кеширования и очередей)
     - sandbox (Ruby executor)

2. CI/CD (.github/workflows/):
   - Тесты при PR
   - Деплой на staging при merge в develop
   - Деплой на production при merge в main

3. Environment:
   - .env.example с необходимыми переменными
   - Credentials для production

4. Мониторинг:
   - Sentry для ошибок
   - Lograge для логов
```

---

## Структура файлов упражнений (YAML)

```yaml
# config/exercises/00_hello.yml
lesson: "Hello World"
module: 1
difficulty: beginner
ruby_version: "3.4"

exercises:
  - id: hello_basic
    title: "Say Hello"
    description: |
      Создайте функцию `hello`, которая возвращает строку "Hello!".

      Это ваше первое упражнение! Функции в Ruby определяются
      ключевым словом `def` и возвращают последнее выражение.

    instructions: |
      1. Создайте функцию `hello`
      2. Функция должна возвращать строку "Hello!"
      3. Запустите тесты для проверки

    hints:
      - "Функции определяются через def...end"
      - "Ruby возвращает последнее выражение автоматически"
      - "Строки заключаются в кавычки"

    starter_code: |
      def hello
        # Ваш код здесь
      end

    solution_code: |
      def hello
        "Hello!"
      end

    test_code: |
      RSpec.describe "hello function" do
        it "returns Hello!" do
          expect(hello).to eq("Hello!")
        end
      end

    topics: ["functions", "strings", "return values"]
    points: 10

  - id: hello_greet
    title: "Greet Someone"
    description: |
      Создайте функцию `greet(name)`, которая принимает имя
      и возвращает приветствие.

    instructions: |
      1. Создайте функцию `greet` с параметром `name`
      2. Функция должна возвращать "Hello, {name}!"
      3. Используйте интерполяцию строк

    hints:
      - 'Интерполяция: "Hello, #{name}!"'
      - "Параметры указываются в скобках после имени функции"

    starter_code: |
      def greet(name)
        # Ваш код здесь
      end

    solution_code: |
      def greet(name)
        "Hello, #{name}!"
      end

    test_code: |
      RSpec.describe "greet function" do
        it "greets Alice" do
          expect(greet("Alice")).to eq("Hello, Alice!")
        end

        it "greets Bob" do
          expect(greet("Bob")).to eq("Hello, Bob!")
        end
      end

    topics: ["functions", "arguments", "string interpolation"]
    points: 15
```

---

## Пример упражнения для Ruby 3.4 `it` parameter

```yaml
# config/exercises/15_it_parameter.yml
lesson: "It Parameter (Ruby 3.4)"
module: 4
difficulty: modern
ruby_version: "3.4"

exercises:
  - id: it_basic
    title: "Introducing 'it'"
    description: |
      Ruby 3.4 представил новый синтаксис `it` для блоков с одним параметром.

      Вместо:
      ```ruby
      [1, 2, 3].map { |n| n * 2 }
      # или
      [1, 2, 3].map { _1 * 2 }
      ```

      Теперь можно писать:
      ```ruby
      [1, 2, 3].map { it * 2 }
      ```

      `it` - это мягкое ключевое слово, которое ссылается на первый
      параметр блока.

    instructions: |
      Перепишите следующий код используя `it`:

      ```ruby
      numbers.select { |n| n.even? }
      ```

    starter_code: |
      def select_even(numbers)
        # Используйте 'it' вместо |n|
        numbers.select { |n| n.even? }
      end

    solution_code: |
      def select_even(numbers)
        numbers.select { it.even? }
      end

    test_code: |
      RSpec.describe "select_even with 'it'" do
        it "selects even numbers" do
          expect(select_even([1, 2, 3, 4, 5, 6])).to eq([2, 4, 6])
        end

        it "returns empty for all odd" do
          expect(select_even([1, 3, 5])).to eq([])
        end

        it "uses 'it' keyword" do
          source = method(:select_even).source
          expect(source).to include("it.")
          expect(source).not_to include("|")
        end
      end

    topics: ["ruby 3.4", "it parameter", "blocks"]
    points: 20
```

---

## Порядок разработки

1. **Фаза 1: Основа**
   - Создать Rails проект (Prompt 1)
   - Модели данных (Prompt 2)
   - Базовая аутентификация

2. **Фаза 2: Core Features**
   - Ruby Sandbox (Prompt 3)
   - Lessons CRUD (Prompt 4)
   - Code Editor (Prompt 5)
   - Code Runner (Prompt 6)

3. **Фаза 3: Контент**
   - Seed базовых упражнений (Prompt 7)
   - Ruby 3.4 упражнения (Prompt 8)

4. **Фаза 4: Engagement**
   - Progress & Gamification (Prompt 9)
   - Admin Panel (Prompt 10)

5. **Фаза 5: Production**
   - API (Prompt 11)
   - Deployment (Prompt 12)

---

## Технологический стек

- **Backend:** Ruby 3.4, Rails 8
- **Database:** PostgreSQL 16
- **Frontend:** Tailwind CSS, Turbo, Stimulus
- **Code Editor:** Monaco Editor / CodeMirror 6
- **Sandbox:** Docker с изолированными контейнерами
- **Cache/Queue:** Redis + Sidekiq
- **Testing:** RSpec, FactoryBot, Capybara
- **Deploy:** Docker Compose, GitHub Actions

---

## Источники

- [Ruby 3.4.0 Release Notes](https://www.ruby-lang.org/en/news/2024/12/25/ruby-3-4-0-released/)
- [Ruby 3.4 Changes Reference](https://rubyreferences.github.io/rubychanges/3.4.html)
- [What's new in Ruby 3.4 - Honeybadger](https://www.honeybadger.io/blog/ruby-3-4/)
- TestFirst.org learn_ruby project (локальный референс)
