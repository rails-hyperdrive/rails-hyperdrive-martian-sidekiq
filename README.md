# rails-hyperdrive-martian-sidekiq

Companion gem for [rails-hyperdrive](https://github.com/rails-hyperdrive/rails-hyperdrive) — Sidekiq guidance for AI coding agents working in Rails projects.

Ships three artifacts, all gated on `sidekiq >= 7.0, < 9.0` being in the app's bundle:

- **`martian-sidekiq` skill** — a lazily-loaded playbook for writing idempotent, well-retried, transactionally-safe Sidekiq jobs: idempotency strategies, retry/backoff design, uniqueness, queue layout, multi-tenant fairness, testing, escalation ladders.
- **`martian-sidekiq` guideline** — the non-negotiable rules (no `Sidekiq::Testing.inline!`, small primitive arguments, no enqueue inside a transaction, …), loaded eagerly.
- **`martian-sidekiq-transactions` guideline** — how to enqueue from a service with [after_commit_everywhere](https://github.com/Envek/after_commit_everywhere); additionally gated on that gem being in the bundle, so apps without it never see it.

Both are ERB templates: sections for Sidekiq Pro/Enterprise, [sidekiq-fair_tenant](https://github.com/Envek/sidekiq-fair_tenant), and rspec-sidekiq render against the app's bundle — apps that have the gem get usage guidance, apps that don't get a suggestion where it would help.

## Install

```ruby
# Gemfile
group :development do
  gem "rails-hyperdrive"
  gem "rails-hyperdrive-martian-sidekiq"
end
```

Then run `bin/rails hyperdrive:init`. Artifacts install to `.claude/skills/martian-sidekiq/SKILL.md` and `.claude/hyperdrive/guidelines/`.

## License

MIT — see [LICENSE.txt](LICENSE.txt).
