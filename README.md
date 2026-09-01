# rails-hyperdrive-martian-sidekiq

Companion gem for [rails-hyperdrive](https://github.com/rails-hyperdrive/rails-hyperdrive) — Sidekiq guidance for AI coding agents working in Rails projects.

Ships three artifacts, all gated on `sidekiq >= 7.0, < 9.0` being in the app's bundle:

- **`martian-sidekiq` skill** — a lazily-loaded playbook for writing idempotent, well-retried, transactionally-safe Sidekiq jobs: idempotency strategies, retry/backoff design, uniqueness, queue layout, multi-tenant fairness, testing, escalation ladders.
- **`/generate-sidekiq-worker` command** — scaffolds a worker + spec following the project's own conventions (base class, queues, `sidekiq_options`), falling back to standard patterns only where the project has none.
- **`martian-sidekiq` guideline** — the non-negotiable rules (no `Sidekiq::Testing.inline!`, small primitive arguments, no enqueue inside a transaction, …), loaded eagerly.

The skill, command, and guideline are ERB templates: sections for Sidekiq Pro/Enterprise, [sidekiq-fair_tenant](https://github.com/Envek/sidekiq-fair_tenant), RSpec, rspec-sidekiq, Sorbet/tapioca, and packwerk render against the app's bundle — apps that have the gem get usage guidance, apps that don't get a suggestion where it would help.

## Install

```ruby
# Gemfile
group :development do
  gem "rails-hyperdrive"
  gem "rails-hyperdrive-martian-sidekiq"
end
```

Then run `bin/rails hyperdrive:init`. Artifacts install to `.claude/skills/martian-sidekiq/SKILL.md`, `.claude/commands/generate-sidekiq-worker.md`, and `.claude/hyperdrive/guidelines/martian-sidekiq.md`.

## License

MIT — see [LICENSE.txt](LICENSE.txt).
