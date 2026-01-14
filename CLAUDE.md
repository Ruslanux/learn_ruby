# LearnRuby - Claude Code Instructions

## Project Overview

Web-приложение для изучения **Ruby 3.4** с интерактивными упражнениями в стиле Test-First Teaching.

## Tech Stack

- **Ruby:** 3.4+
- **Rails:** 8.0
- **Database:** PostgreSQL
- **Frontend:** Tailwind CSS, Turbo, Stimulus
- **Authentication:** Devise
- **Testing:** RSpec, FactoryBot
- **Code Editor:** Monaco Editor / CodeMirror
- **Sandbox:** Docker containers for safe code execution

## Key Commands

```bash
# Development
bin/rails server           # Start development server
bin/dev                    # Start with Procfile.dev (includes tailwind)

# Database
bin/rails db:create        # Create databases
bin/rails db:migrate       # Run migrations
bin/rails db:seed          # Seed data

# Testing
bundle exec rspec          # Run all tests
bundle exec rspec spec/models  # Run model tests only

# Code quality
bin/rubocop                # Run linter
bin/brakeman               # Security analysis
```

## Project Structure

```
app/
├── models/
│   ├── user.rb              # Devise user model with levels, streaks
│   ├── lesson.rb            # Lesson/module grouping
│   ├── exercise.rb          # Individual coding exercises
│   ├── user_progress.rb     # Track user completion
│   ├── code_submission.rb   # Code submission history
│   ├── achievement.rb       # Gamification achievements
│   └── user_achievement.rb  # User-Achievement join model
├── controllers/
│   ├── lessons_controller.rb
│   ├── exercises_controller.rb
│   ├── code_runner_controller.rb
│   ├── leaderboard_controller.rb
│   ├── profile_controller.rb
│   ├── admin/                    # Admin Panel
│   │   ├── base_controller.rb
│   │   ├── dashboard_controller.rb
│   │   ├── lessons_controller.rb
│   │   ├── exercises_controller.rb
│   │   ├── submissions_controller.rb
│   │   └── users_controller.rb
│   └── api/v1/                   # JSON API
│       ├── base_controller.rb
│       ├── auth_controller.rb
│       ├── lessons_controller.rb
│       ├── exercises_controller.rb
│       ├── users_controller.rb
│       └── leaderboard_controller.rb
├── services/
│   ├── ruby_sandbox_service.rb  # Safe Ruby execution
│   ├── achievement_service.rb   # Award achievements
│   └── json_web_token.rb        # JWT encoding/decoding
└── views/

config/exercises/            # YAML files with exercise data
lib/ruby_executor/           # Docker-based code execution
```

## Development Guidelines

1. **Security First:** All user code runs in isolated Docker containers
2. **Test-First:** Write RSpec tests before implementation
3. **Ruby 3.4 Features:** Leverage modern Ruby syntax (pattern matching, `it` parameter, Data classes)
4. **i18n Ready:** Support both Russian and English

## Exercise Format (YAML)

```yaml
lesson: "Lesson Name"
module: 1
difficulty: beginner  # beginner, intermediate, advanced, modern

exercises:
  - id: unique_id
    title: "Exercise Title"
    description: "Markdown description"
    instructions: "Step by step"
    hints: ["hint 1", "hint 2"]
    starter_code: "def method\n  # code here\nend"
    solution_code: "def method\n  'solution'\nend"
    test_code: "RSpec.describe..."
    topics: ["topic1", "topic2"]
    points: 10
```

## Data Models

### User (Devise)
- `email`, `encrypted_password`, `username`
- `level` (default: 1), `total_points` (default: 0)
- Associations: has_many :user_progresses, :code_submissions, :exercises (through)

### Lesson
- `title`, `description`, `module_number`, `position`
- `difficulty` (enum: beginner, intermediate, advanced, modern)
- `ruby_version` (default: "3.4")
- Associations: has_many :exercises

### Exercise
- `title`, `description`, `instructions` (markdown)
- `hints` (jsonb array), `topics` (jsonb array)
- `starter_code`, `solution_code`, `test_code`
- `points` (default: 10), `position`
- Associations: belongs_to :lesson, has_many :user_progresses, :code_submissions

### UserProgress
- `status` (enum: not_started, in_progress, completed)
- `attempts`, `last_code`, `completed_at`, `points_earned`
- Associations: belongs_to :user, :exercise

### CodeSubmission
- `code`, `result`, `passed` (boolean), `execution_time` (float)
- Associations: belongs_to :user, :exercise

## Current Phase

**Phase 1: Foundation** - ✅ Complete
- Rails 8 + PostgreSQL + Tailwind CSS
- Devise authentication with User model
- RSpec + FactoryBot testing

**Phase 2: Data Models** - ✅ Complete
- Lesson, Exercise, UserProgress, CodeSubmission models
- All associations and validations

**Phase 2: Ruby Sandbox Service** - ✅ Complete
- `RubySandboxService` - Process-based execution with security checks
- `DockerSandboxService` - Docker-based isolated execution (production)
- Dockerfile for sandbox container (`docker/sandbox/Dockerfile`)
- Security: blocks File, IO, system, eval, ENV, Socket, etc.
- Timeout: 10 seconds, Memory limit: 128MB

**Phase 2: Lessons Controller & Views** - ✅ Complete
- `LessonsController` with index and show actions
- Lessons index with module cards and progress bars
- Lesson show with exercises list and sidebar
- Navigation breadcrumbs and "Lessons" link in header
- `LessonsHelper` with progress calculations and status icons
- Seed data: 4 lessons, 8 exercises

**Phase 2: Exercise Editor** - ✅ Complete
- `ExercisesController` with show action
- Interactive code editor with CodeMirror (Dracula theme)
- Instructions panel with markdown rendering (Redcarpet gem)
- Tests preview panel showing RSpec code
- Run Tests and Submit Solution buttons
- Results panel with color-coded output
- Attempts counter and timer
- Navigation between exercises
- Stimulus controllers:
  - `code_editor_controller.js` - CodeMirror integration, hints toggle
  - `test_runner_controller.js` - AJAX test execution, results display
  - `timer_controller.js` - Elapsed time tracking
- `ExercisesHelper` with `render_markdown` method

**Phase 3: Code Runner Controller** - ✅ Complete
- `POST /lessons/:lesson_id/exercises/:id/run` - Execute code without saving (available to all)
- `POST /lessons/:lesson_id/exercises/:id/submit` - Execute and save (requires auth)
- Integration with `RubySandboxService` for secure code execution
- `UserProgress` tracking:
  - Increments attempts on each submit
  - Saves last submitted code
  - Marks completed on passing solution
- `CodeSubmission` records created for each submission
- Points awarded on first successful completion (only once)
- JSON API responses with:
  - success, output, errors, test_results, execution_time
  - attempts count, completed status, points earned
- Security: blocks forbidden patterns (system, File, eval, etc.)

**Phase 4: Seed Exercises** - ✅ Complete
- 16 lessons across 4 modules
- 61 exercises with comprehensive test coverage
- 1105 total points available
- Full Russian translations for all lessons and exercises

Module 1: Ruby Basics (4 lessons, 12 exercises)
  - Hello World: Say Hello, Greet Someone, Default Greeting
  - Temperature Converter: Fahrenheit to Celsius, Celsius to Fahrenheit
  - Calculator: Add Two Numbers, Sum an Array, Factorial, Average
  - Conditionals: Is Even?, FizzBuzz, Grade Calculator

Module 2: Working with Data (4 lessons, 21 exercises)
  - Arrays: First and Last, Double Each, Select Evens, Find Maximum, Compact, Unique Elements
  - Hashes: Create Person Hash, Get Hash Value, Count Words, Merge Hashes
  - Strings: Reverse String, Palindrome Check, Title Case, Anagram Check, Word Count, Truncate
  - Intermediate Enumerables: Group By, Partition, Reduce with Initial, Flat Map, Tally

Module 3: Object-Oriented Ruby (4 lessons, 13 exercises)
  - Classes and Objects: Dog Class, Counter Class, Rectangle Class
  - Modules and Mixins: Greeting Module, Comparable Module
  - Procs and Lambdas: Create a Simple Proc, Lambda vs Proc, Block to Proc, Compose Functions
  - Exception Handling: Basic Rescue, Multiple Rescue, Ensure Block, Custom Exceptions

Module 4: Ruby 3.4 Features (4 lessons, 15 exercises)
  - The 'it' Parameter: Using 'it' in map, Chaining with 'it', Filter with 'it'
  - Pattern Matching: Array Destructuring, Hash Pattern Matching, Guard Clauses, Pattern Match with Types
  - Data Classes: Create Point, Data Class with Methods, Derived Values
  - Advanced Ruby: Frozen String Literals, Safe Navigation, Endless Methods, Numbered Parameters, Deconstruct Keys

- 261 passing tests

**Phase 5: Gamification System** - ✅ Complete
- `Achievement` model with 4 categories:
  - points: awarded for reaching point thresholds (10, 50, 100, 500 pts)
  - exercises: awarded for completing exercise counts (1, 5, 10, 25 exercises)
  - streak: awarded for maintaining daily streaks (3, 7, 14, 30 days)
  - special: custom achievements (First Blood, Ruby Master, etc.)
- `UserAchievement` join model with earned_at timestamp
- Streak tracking on User:
  - `current_streak`, `longest_streak`, `last_activity_date` fields
  - `update_streak!` method called on each points award
- Level progression system:
  - 10 levels with point thresholds (0, 50, 150, 300, 500, 750, 1050, 1400, 1800, 2250)
  - `level_progress_percentage` and `points_to_next_level` helpers
- `AchievementService` for checking and awarding achievements
- `LeaderboardController` with top 50 users by points
- `ProfileController` showing user stats, achievements, and progress
- 16 seeded achievements across 4 categories
- 163 passing tests

**Phase 6: Admin Panel** - ✅ Complete
- Admin namespace with role-based authorization (admin field on User)
- Admin layout with sidebar navigation
- `Admin::DashboardController` with statistics:
  - Total users, active today, submissions count
  - Pass rate, content metrics (lessons/exercises)
  - Recent submissions table, popular exercises, top users
- `Admin::LessonsController` full CRUD:
  - List lessons with module numbers, difficulty badges
  - Create/edit forms with all fields
  - Delete with confirmation
- `Admin::ExercisesController` full CRUD:
  - List exercises with pass rate metrics
  - Detailed view with code sections and submission stats
  - Forms with code editors for starter/solution/test code
- `Admin::SubmissionsController` for moderation:
  - List all submissions with filtering (passed/failed)
  - View submitted code and results
  - Pagination support
- `Admin::UsersController` for user management:
  - List users with search functionality
  - View user details, achievements, recent activity
  - Edit user profile (username, level, points)
  - Toggle admin access (with self-protection)
- 198 passing tests

**Phase 7: JSON API for Mobile** - ✅ Complete
- JWT authentication with `JsonWebToken` service
- API namespace versioned as `/api/v1/`
- Authentication endpoints:
  - `POST /api/v1/auth/login` - Login with email/password, returns JWT
  - `POST /api/v1/auth/register` - Create account, returns JWT
  - `POST /api/v1/auth/refresh` - Refresh JWT token
- Lessons endpoints:
  - `GET /api/v1/lessons` - List all lessons with progress
  - `GET /api/v1/lessons/:id` - Lesson details with exercises
- Exercises endpoints:
  - `GET /api/v1/exercises/:id` - Exercise details with progress
  - `POST /api/v1/exercises/:id/run` - Execute code (no save)
  - `POST /api/v1/exercises/:id/submit` - Execute and save submission
- User endpoints:
  - `GET /api/v1/users/me` - Current user profile
  - `GET /api/v1/users/me/progress` - Detailed progress info
  - `GET /api/v1/users/me/achievements` - User achievements
- Leaderboard endpoints:
  - `GET /api/v1/leaderboard` - Top users by points
  - `GET /api/v1/leaderboard/streaks` - Top users by streak
- Rate limiting with Rack::Attack:
  - 100 requests/minute per IP for API
  - 10 requests/minute for code execution
  - 5 login attempts/minute per IP
  - 3 registrations/hour per IP
- 239 passing tests

**Phase 8: Deployment Configuration** - ✅ Complete & Deployed
- Docker setup:
  - `Dockerfile` - Rails 8 production image with multi-stage build
  - `docker-compose.yml` - Production services (web, db, redis, sandbox)
  - `docker-compose.dev.yml` - Development services (db, redis only)
  - `docker/sandbox/Dockerfile` - Isolated Ruby sandbox container
- Kamal 2.x Deployment:
  - `config/deploy.yml` - Kamal configuration with PostgreSQL and Redis accessories
  - `.kamal/secrets` - Secret management for GitHub Actions
  - Single unified CI/CD pipeline in `.github/workflows/ci.yml`
- GitHub Actions CI/CD:
  - Parallel jobs: test (RSpec), scan_ruby (Brakeman), scan_js (importmap audit), lint (RuboCop)
  - Deploy job runs after all checks pass on main branch
  - Auto-deploy to Hetzner Cloud server
- Environment configuration:
  - `.env.example` - All environment variables documented
  - Rails credentials for production secrets
- Monitoring and logging:
  - Sentry for error tracking (`config/initializers/sentry.rb`)
  - Lograge for structured JSON logging (`config/initializers/lograge.rb`)
- Rate limiting with Rack::Attack (configured in Phase 7)
- 261 passing tests

**Phase 9: Final Polish** - ✅ Complete
- Background Jobs (Solid Queue):
  - `CodeExecutionJob` - Async code execution with progress updates
  - `AchievementCheckJob` - Async achievement checking
  - `StreakUpdateJob` - Async streak updates
  - Separate queue for code execution (`code_execution`)
- i18n (Internationalization):
  - Full Russian and English translations for UI
  - Full Russian translations for all lessons and exercises (title_ru, description_ru, instructions_ru, hints_ru)
  - `config/locales/en.yml` - English locale
  - `config/locales/ru.yml` - Russian locale
  - `config/locales/devise.ru.yml` - Devise Russian translations
  - Language switcher in navigation header
  - Session-based locale persistence
  - Auto-detection from Accept-Language header
  - Translatable concern for models with `_ru` suffix columns
- Custom Error Pages:
  - `ErrorsController` with not_found, internal_error, unprocessable actions
  - Styled error pages matching app design (404, 500, 422)
  - JSON responses for API clients
  - `config.exceptions_app = routes` for production
- 261 passing tests

**Project Complete** - All phases implemented and deployed to production

---

## Production Deployment

### Live URL

**http://77.42.38.197** (IP-based access, SSL pending domain setup)

### Infrastructure

| Component | Technology | Details |
|-----------|------------|---------|
| Hosting | Hetzner Cloud | CX22 (2 vCPU, 4GB RAM), Ubuntu 24.04 |
| Deployment | Kamal 2.x | Docker-based deployment with kamal-proxy |
| Database | PostgreSQL 16 | Docker container (learn-ruby-db) |
| Cache/Queue | Redis 7 | Docker container (learn-ruby-redis) |
| CI/CD | GitHub Actions | Auto-deploy on push to main |
| Registry | Docker Hub | ruslanux/learn-ruby |

### GitHub Repository

**https://github.com/Ruslanux/learn_ruby**

### GitHub Secrets Required

| Secret | Description |
|--------|-------------|
| `DOCKERHUB_USERNAME` | Docker Hub username |
| `DOCKERHUB_TOKEN` | Docker Hub access token |
| `SSH_PRIVATE_KEY` | SSH key for server access |
| `SERVER_IP` | Production server IP |
| `RAILS_MASTER_KEY` | Rails credentials key |
| `DATABASE_PASSWORD` | PostgreSQL password |

### Useful Commands

```bash
# SSH to server
ssh root@77.42.38.197

# View running containers
docker ps

# View app logs
docker logs learn-ruby-web-<version> -f

# Rails console in production
docker exec -it learn-ruby-web-<version> bin/rails console

# Run migrations
docker exec -it learn-ruby-web-<version> bin/rails db:migrate

# Seed database
docker exec -it learn-ruby-web-<version> bin/rails db:seed
```

### Future: Domain & SSL Setup

See `DEPLOYMENT_GUIDE.md` section "Настройка домена и SSL" for instructions on:
- Registering a domain
- Configuring Cloudflare DNS
- Enabling SSL with Let's Encrypt via Kamal

---

## Development Users

After running `bin/rails db:seed`:

| Email | Password | Role | Level | Points |
|-------|----------|------|-------|--------|
| admin@example.com | password123 | Admin | 5 | 500 |
| user1@example.com | password123 | User | 2 | 100 |
