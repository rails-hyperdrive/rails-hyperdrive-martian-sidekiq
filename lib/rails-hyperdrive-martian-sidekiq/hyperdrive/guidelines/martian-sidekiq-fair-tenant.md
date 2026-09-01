---
name: martian-sidekiq-fair-tenant
description: Keeping one tenant from starving the queue with sidekiq-fair_tenant.
---

### Fair scheduling between tenants

This project has
[sidekiq-fair_tenant](https://github.com/Envek/sidekiq-fair_tenant): once a
tenant enqueues more than a threshold within a sliding window, their overflow
is re-routed to lower-weight throttled queues, so one noisy tenant cannot
starve the rest.

Declare the rules on jobs a single tenant can trigger in bulk:

```ruby
class SomeJob
  include Sidekiq::Job
  sidekiq_options queue: "default",
    fair_tenant_queues: [
      { queue: "throttled_2x", threshold: 100, per: 1.hour },
      { queue: "throttled_4x", threshold: 10,  per: 1.minute }
    ]

  # Or enqueue with SomeJob.set(fair_tenant: "...").perform_async(...)
  def self.fair_tenant(*perform_args)
    perform_args.first # e.g. the account id
  end
end
```

Rules for using it:

- **Every throttled queue MUST be in the Sidekiq config with a lower weight
  than the queue it throttles** (`[default, 4]`, `[throttled_2x, 2]`,
  `[throttled_4x, 1]`). Re-routing into a queue no worker consumes is a
  silent black hole — the jobs are enqueued, never drained, and nothing
  errors. Adding a rule and its queue config is one change, never two.
- **When several rules match, the LAST one wins.** Order them from the
  loosest window to the tightest, so the most aggressive throttling is last
  and takes effect during a real burst.
- **Derive the tenant from the job's arguments**, via `self.fair_tenant` or an
  explicit `.set(fair_tenant:)`. Deriving it from ambient state (`Current.*`,
  a thread local) is unreliable: the value that matters is the one available
  wherever the job is enqueued from, including re-enqueues outside a request.
- **Don't hand-roll fairness.** A queue per tenant, a `sleep` in `perform`, or
  an "is this tenant over quota?" check inside the job all enforce fairness
  after the queue order is already wrong — and the in-job variants burn a
  worker slot doing it.

Fair scheduling reorders work; it does not reduce it. Throttled tenants still
get their jobs run, just later — so this is not a substitute for idempotency,
retry limits, or an actual rate limit against an external API. See the
`martian-sidekiq` skill for those.
