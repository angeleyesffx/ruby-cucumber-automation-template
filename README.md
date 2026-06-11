# Ruby Cucumber Automation Template

[![Browser Tests](https://github.com/angeleyesffx/ruby-cucumber-automation-template/actions/workflows/ci.yml/badge.svg)](https://github.com/angeleyesffx/ruby-cucumber-automation-template/actions/workflows/ci.yml)

BDD test automation framework covering **browser tests** (Books to Scrape catalogue via Capybara + Selenium) and **GraphQL API tests** (Marvel App via HTTParty), built with Ruby, Cucumber, and the Page Object Model pattern.

## Stack

| Tool | Version | Purpose |
|------|---------|---------|
| Ruby | 3.0+ | Runtime |
| Cucumber | ~> 11.1 | BDD framework |
| Capybara | ~> 3.40 | Browser DSL |
| Selenium WebDriver | ~> 4.44 | Browser driver |
| RSpec | ~> 3.13 | Assertions |
| HTTParty | ~> 0.22 | HTTP client for API tests |
| Dotenv | ~> 3.1 | Environment variable loader |

## Prerequisites

- Ruby 3.0 or higher ([rbenv](https://github.com/rbenv/rbenv) recommended)
- Bundler (`gem install bundler`)
- Google Chrome (latest stable)

> Selenium WebDriver 4.6+ ships with [Selenium Manager](https://www.selenium.dev/documentation/selenium_manager/), which automatically downloads the correct ChromeDriver — no manual setup needed.

## Setup

```bash
# Clone the repository
git clone <repo-url>
cd ruby-cucumber-automation-template

# Install Ruby 3.3 via rbenv (if needed)
rbenv install 3.3.0
rbenv local 3.3.0

# Install dependencies
bundle install

# Configure API keys (for Marvel App API tests)
cp .env.example .env
# Edit .env — set MARVEL_APP_TOKEN to your personal access token
# Generate one at: https://marvelapp.com/oauth/devtoken
```

## Running Tests

```bash
# All tests (headed browser + API, default env)
bundle exec rake test

# Headless mode (CI or background)
bundle exec rake test_headless

# CI mode: headless + HTML report + rerun file
bundle exec rake test_ci

# Re-run only the scenarios that failed in the last CI run
bundle exec rake test_rerun

# Run a specific suite by tag
bundle exec cucumber --tags @books   # Browser tests — Books to Scrape
bundle exec cucumber --tags @browser # Any browser test
bundle exec cucumber --tags @marvel  # Marvel App GraphQL API tests
bundle exec cucumber --tags @api     # Any API test
```

## Project Structure

```
.
├── features/
│   ├── books_catalogue_test.feature  # Browser tests — Books to Scrape catalogue
│   ├── marvel_api_test.feature       # API tests — Marvel App GraphQL
│   │
│   ├── pages/                        # Page Object Model
│   │   ├── base_page.rb              # Base class — Capybara DSL + SupportObject utilities
│   │   ├── books_home_page.rb        # Books to Scrape homepage (book list, categories)
│   │   └── books_catalogue_page.rb   # Catalogue/category listing page
│   │
│   ├── step_definitions/
│   │   ├── books_catalogue_steps.rb  # Steps for catalogue browsing scenarios
│   │   └── marvel_api_steps.rb       # Steps for Marvel App GraphQL scenarios
│   │
│   └── support/
│       ├── env.rb                    # Driver setup, ENV loading, page requires
│       ├── hooks.rb                  # Before/After lifecycle + failure screenshots
│       ├── config.yml                # Environment URLs
│       ├── api/
│       │   └── marvel_app_client.rb  # Marvel App GraphQL client (HTTParty)
│       └── modules/
│           └── support_object.rb     # Shared utilities (generators, element helpers, waits)
│
├── reports/                          # Generated at runtime (gitignored)
│   └── screenshots/failures/         # Auto-captured on scenario failure
├── .env.example                      # Required environment variables
├── .ruby-version                     # 3.3.0
├── cucumber.yml                      # Execution profiles
├── Rakefile
└── Gemfile
```

## Marvel App API Configuration

The [Marvel App](https://marvelapp.com) API is a **GraphQL API** authenticated via a personal Bearer token.

1. Log in at [marvelapp.com](https://marvelapp.com)
2. Go to [marvelapp.com/oauth/devtoken](https://marvelapp.com/oauth/devtoken) and generate a token
3. Copy `.env.example` to `.env` and set `MARVEL_APP_TOKEN`

```bash
cp .env.example .env
# edit .env — set MARVEL_APP_TOKEN=<your_token>
```

### Explore the schema

Once you have a valid token, dump the full GraphQL schema to discover all available queries:

```bash
bundle exec rake marvel:schema
```

This prints all types and their fields so you can refine the queries in [features/support/api/marvel_app_client.rb](features/support/api/marvel_app_client.rb).

## CI/CD Pipeline

The pipeline runs on **GitHub Actions** with two parallel jobs triggered on every push, PR, and weekday at 09:00 UTC.

```
push / PR / schedule
        │
        ├── Browser Tests (ubuntu-latest)
        │   ├── Setup Ruby 3.3 + cache gems
        │   ├── Install Chrome (stable)
        │   ├── Run @browser tests — headless
        │   ├── Rerun failed scenarios (rerun.txt)
        │   └── Upload artifact: browser-report-{run}
        │
        └── API Tests (ubuntu-latest)
            ├── Setup Ruby 3.3 + cache gems
            ├── Run @api tests (no browser needed)
            └── Upload artifact: api-report-{run}
```

### Required GitHub Secret

Add `MARVEL_APP_TOKEN` in **Settings → Secrets → Actions**:

| Secret | Value |
|--------|-------|
| `MARVEL_APP_TOKEN` | Personal access token from [marvelapp.com/oauth/devtoken](https://marvelapp.com/oauth/devtoken) |

Reports are uploaded as artifacts with 30-day retention and downloadable from the Actions run summary.

## Environments

Configured in [`features/support/config.yml`](features/support/config.yml):

| `TEST_ENV` | URL | Default? |
|------------|-----|----------|
| `homolog` | `https://books.toscrape.com` | Yes |
| `staging` | `https://books.toscrape.com` | — |
| `development` | `http://localhost:3000` | — |

Override with: `TEST_ENV=staging bundle exec cucumber`

## Profiles

Defined in [`cucumber.yml`](cucumber.yml):

| Profile | Rake task | Notes |
|---------|-----------|-------|
| `default` | `rake test` | Headed Chrome, all tests |
| `headless` | `rake test_headless` | Headless Chrome, all tests |
| `ci` | `rake test_ci` | Headless + HTML report + rerun file |
| `browser` | `rake test_browser` | Headless, `@browser` tag only |
| `api` | `rake test_api` | `@api` tag only (no browser) |
| `rerun` | `rake test_rerun` | Reruns failed scenarios from `reports/rerun.txt` |

## Tags

| Tag | Meaning |
|-----|---------|
| `@books` | Browser tests against Books to Scrape |
| `@browser` | Any browser test |
| `@marvel` | Marvel App GraphQL API tests |
| `@api` | Any API test |

## Test Artifacts

Generated to `reports/` (gitignored):

- `cucumber_report.html` — full HTML report (default and CI profiles)
- `browser_report.html` — browser-only HTML report
- `api_report.html` — API-only HTML report
- `rerun.txt` — failed scenario locations for rerun
- `screenshots/failures/` — automatic screenshots on failure

## Best Practices Applied

- **Page Object Model** — every page extends `BasePage`; selectors live in constants, not in steps
- **GraphQL client pattern** — `MarvelAppClient` encapsulates auth, endpoint, and all query methods
- **No hardcoded secrets** — API keys via `.env` / ENV variables only
- **Headless CI mode** — `HEADLESS=true` flag enables headless Chrome via the `browser` and `ci` profiles
- **Failure screenshots** — auto-captured in `After` hook, only when a scenario fails
- **`expect` syntax** — RSpec `expect` throughout; deprecated `should` removed
- **Rerun on failure** — `--format rerun` writes failed locations; `rake test_rerun` replays them
- **Parallel CI jobs** — browser and API tests run in separate jobs for faster feedback
