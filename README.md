# LearnRuby

Interactive platform for learning **Ruby 3.4** with hands-on exercises in Test-First Teaching style.

**Live:** [learn-ruby.org](https://learn-ruby.org)

## Features

- **Interactive Code Editor** — CodeMirror with syntax highlighting (Dracula theme)
- **Sandboxed Execution** — Secure code execution with timeout and memory limits
- **Test-First Teaching** — Write code to pass RSpec tests, see results instantly
- **61 Exercises** — Across 16 lessons covering Ruby basics to advanced features
- **Gamification** — Points, levels, achievements, streaks, and leaderboard
- **Progress Tracking** — Resume where you left off, view attempt history
- **Solution Hints** — Optional hints and solutions (with point penalty)
- **JSON API** — JWT-authenticated API for mobile clients
- **Admin Panel** — Manage lessons, exercises, users, and submissions
- **Multi-language** — Russian and English interface (i18n)

## Tech Stack

| Layer | Technology |
|-------|------------|
| **Backend** | Ruby 3.4.4, Rails 8.0.3 |
| **Database** | PostgreSQL 16 |
| **Frontend** | Hotwire (Turbo + Stimulus), Tailwind CSS |
| **Code Editor** | CodeMirror 5.65 |
| **Authentication** | Devise (web), JWT (API) |
| **Authorization** | Pundit |
| **Background Jobs** | Solid Queue |
| **Testing** | RSpec, FactoryBot |
| **Code Quality** | RuboCop, Brakeman |
| **Deployment** | Kamal 2.x, Docker, GitHub Actions |

## Project Structure

```
app/
├── controllers/
│   ├── exercises_controller.rb    # Code editor, run/submit
│   ├── lessons_controller.rb      # Lesson navigation
│   ├── leaderboard_controller.rb  # Rankings
│   ├── profile_controller.rb      # User stats
│   ├── admin/                     # Admin panel (CRUD)
│   └── api/v1/                    # JSON API endpoints
├── models/
│   ├── user.rb                    # Devise, levels, streaks
│   ├── lesson.rb                  # Module grouping
│   ├── exercise.rb                # Code challenges
│   ├── user_progress.rb           # Completion tracking
│   ├── code_submission.rb         # Submission history
│   └── achievement.rb             # Gamification badges
├── services/
│   ├── ruby_sandbox_service.rb    # Secure code execution
│   ├── code_execution_service.rb  # Execution orchestration
│   ├── code_submission_service.rb # Submission workflow
│   └── achievement_service.rb     # Award achievements
├── serializers/                   # API JSON serialization
└── views/                         # ERB templates
```

## Curriculum

| Module | Lessons | Exercises | Topics |
|--------|---------|-----------|--------|
| **1. Ruby Basics** | 4 | 12 | Hello World, Variables, Conditionals, Loops |
| **2. Working with Data** | 4 | 21 | Arrays, Hashes, Strings, Enumerables |
| **3. Object-Oriented Ruby** | 4 | 13 | Classes, Modules, Procs, Exceptions |
| **4. Ruby 3.4 Features** | 4 | 15 | `it` parameter, Pattern Matching, Data classes |

**Total:** 16 lessons, 61 exercises, 1105 points

## Setup

### Requirements

- Ruby 3.4.4
- PostgreSQL 16+
- Node.js 18+

### Installation

```bash
# Clone repository
git clone https://github.com/Ruslanux/learn_ruby.git
cd learn_ruby

# Install dependencies
bundle install

# Setup database
bin/rails db:create db:migrate db:seed

# Start server
bin/dev
```

### Environment Variables

```bash
# .env (development)
DATABASE_URL=postgres://localhost/learn_ruby_development

# Production (via secrets)
RAILS_MASTER_KEY=xxx
DATABASE_PASSWORD=xxx
```

## Testing

```bash
# Run all tests (266 specs)
bundle exec rspec

# Run specific tests
bundle exec rspec spec/models
bundle exec rspec spec/requests/api

# Code quality
bin/rubocop
bin/brakeman
```

## API

JWT-authenticated REST API at `/api/v1/`:

| Endpoint | Description |
|----------|-------------|
| `POST /auth/login` | Get JWT token |
| `POST /auth/register` | Create account |
| `GET /lessons` | List lessons with progress |
| `GET /exercises/:id` | Exercise details |
| `POST /exercises/:id/run` | Execute code |
| `POST /exercises/:id/submit` | Submit solution |
| `GET /users/me` | Current user profile |
| `GET /leaderboard` | Top users by points |

## Deployment

Deployed with **Kamal 2.x** to Hetzner Cloud:

```bash
# Deploy (via GitHub Actions on push to main)
git push origin main

# Manual deploy
kamal deploy

# Useful commands
kamal logs -f
kamal console
kamal app restart
```

### Infrastructure

- **Server:** Hetzner Cloud CX22 (2 vCPU, 4GB RAM)
- **Domain:** learn-ruby.org (Cloudflare DNS)
- **SSL:** Let's Encrypt (auto via kamal-proxy)
- **CI/CD:** GitHub Actions (test → lint → deploy)

## Contributing

1. Fork the repository
2. Create feature branch (`git checkout -b feature/amazing`)
3. Commit changes (`git commit -m 'Add amazing feature'`)
4. Push to branch (`git push origin feature/amazing`)
5. Open Pull Request

## License

MIT License. See [LICENSE](LICENSE) for details.

---

Built with Ruby on Rails by [Ruslan Zhubanov](https://github.com/Ruslanux)
