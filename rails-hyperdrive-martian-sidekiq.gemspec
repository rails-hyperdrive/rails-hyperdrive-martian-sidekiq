require_relative "lib/rails-hyperdrive-martian-sidekiq/version"

Gem::Specification.new do |spec|
  spec.name        = "rails-hyperdrive-martian-sidekiq"
  spec.version     = RailsHyperdriveMartianSidekiq::VERSION
  spec.authors     = ["izhanov"]
  spec.email       = ["aibek.izhanov@evilmartians.com"]

  spec.summary     = "Rails Hyperdrive companion gem: Sidekiq skill for AI coding agents."
  spec.description = <<~DESC
    Companion gem for rails-hyperdrive. Ships the `martian-sidekiq` skill — a procedural,
    model-invoked guide for writing idempotent, well-retried Sidekiq jobs in Rails
    projects — plus a `/generate-sidekiq-worker` command and an always-on guideline
    with the non-negotiable Sidekiq rules. Installed by `bin/rails hyperdrive:init`.
  DESC
  spec.homepage    = "https://github.com/rails-hyperdrive/rails-hyperdrive-martian-sidekiq"
  spec.license     = "MIT"
  spec.required_ruby_version = ">= 3.2.0"

  spec.metadata["homepage_uri"]          = spec.homepage
  spec.metadata["source_code_uri"]       = spec.homepage
  spec.metadata["changelog_uri"]         = "#{spec.homepage}/blob/main/CHANGELOG.md"
  spec.metadata["allowed_push_host"]     = "https://rubygems.org"
  spec.metadata["rubygems_mfa_required"] = "true"

  # rails-hyperdrive discovery hints (pre-install; read remotely from rubygems).
  spec.metadata["hyperdrive_targets"]    = "sidekiq"
  spec.metadata["hyperdrive_artifacts"]  = "skill,command,guideline"

  spec.files = Dir[
    "lib/**/*",
    "commands/**/*",
    "hyperdrive.yml",
    "LICENSE.txt",
    "README.md",
    "CHANGELOG.md"
  ].reject { |f| File.directory?(f) }

  spec.require_paths = ["lib"]
end
