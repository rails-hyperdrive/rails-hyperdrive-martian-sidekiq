# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- `martian-sidekiq` skill (ERB-templated): idempotency, retries, uniqueness,
  transactional enqueues, queue layout, rate limiting, bulk enqueueing,
  multi-tenant fair scheduling, testing, escalation ladders. Conditional
  sections for Sidekiq Pro/Enterprise, sidekiq-fair_tenant, and rspec-sidekiq.
- `/generate-sidekiq-worker` command: scaffolds a worker + spec following the
  project's own conventions; conditional Sorbet/tapioca and packwerk support.
- `martian-sidekiq` guideline with the non-negotiable Sidekiq rules.
- `hyperdrive.yml` manifest gating all artifacts on `sidekiq >= 7.0, < 9.0`.

[Unreleased]: https://github.com/rails-hyperdrive/rails-hyperdrive-martian-sidekiq/compare/HEAD...HEAD
