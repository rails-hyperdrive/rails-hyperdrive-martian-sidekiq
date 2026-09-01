# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.1.0] - 2026-09-01

First release.

### Added

- **`martian-sidekiq` skill** — a model-invoked playbook for Sidekiq in Rails,
  loaded lazily when the work touches jobs. Covers idempotency strategies and
  a pre-merge checklist, argument rules, retry counts and custom backoff,
  transactional enqueues, uniqueness, queue layout, concurrency vs throughput,
  multi-tenant fairness, bulk enqueueing, rate limiting, testing, observability,
  a red-flag catalogue, and escalation ladders for duplicate, stuck, and
  backing-up jobs.
- **`martian-sidekiq` guideline** — the non-negotiable rules, loaded eagerly:
  no `Sidekiq::Testing.inline!`, small primitive arguments, no enqueue inside
  an open transaction, idempotent `perform`, concurrency as the risk factor,
  smearing for rate-limited work.
- **`martian-sidekiq-transactions` guideline** — service-level enqueues with
  [after_commit_everywhere](https://github.com/Envek/after_commit_everywhere),
  including the two footguns its README calls out (never register the callbacks
  on an AR model; `after_rollback` raises outside a transaction).
- **`martian-sidekiq-fair-tenant` guideline** — multi-tenant fairness with
  [sidekiq-fair_tenant](https://github.com/Envek/sidekiq-fair_tenant): rule
  ordering (the last matching rule wins), tenant resolution from job arguments,
  and the silent failure when a throttled queue is missing from the Sidekiq
  config.
- **`hyperdrive.yml` manifest** gating every artifact on `sidekiq >= 7.0, < 9.0`.
  The two gem-specific guidelines carry an additional `all:` gate on their gem,
  so an app without it never carries them in context.

### Conditional content

The skill and the base guideline are ERB templates rendered against the app's
resolved bundle, so the installed text matches the stack:

- **Sidekiq Pro** — `batch.jobs` pipelining for bulk enqueues.
- **Sidekiq Enterprise** — `Sidekiq::Limiter` for rate-limited work, and its
  built-in `unique_for:` in place of a third-party locking gem.
- **rspec-sidekiq** — `have_enqueued_sidekiq_job` in the testing guidance.
- **after_commit_everywhere**, **sidekiq-fair_tenant**, **sidekiq-unique-jobs** —
  where the gem is bundled the skill gives orientation and defers to the
  guideline; where it is not, the skill proposes the gem with a `bundle add`
  line and a worked example, and never adds a dependency silently.

[Unreleased]: https://github.com/rails-hyperdrive/rails-hyperdrive-martian-sidekiq/compare/v0.1.0...HEAD
[0.1.0]: https://github.com/rails-hyperdrive/rails-hyperdrive-martian-sidekiq/releases/tag/v0.1.0
