---
name: martian-sidekiq-transactions
description: Enqueuing jobs around DB transactions with after_commit_everywhere.
---

### Enqueuing jobs around transactions

**Never enqueue inside an open transaction.** Sidekiq lives in Redis and does
not participate in the DB transaction: the worker can pick the job up before
the COMMIT (and find nothing) or after a ROLLBACK (and act on a record that
never existed).

This project has
[after_commit_everywhere](https://github.com/Envek/after_commit_everywhere),
so the enqueue belongs in an `after_commit` block in the service that owns the
use case — not in a model callback:

```ruby
class ChargeInvoice
  include AfterCommitEverywhere

  def call(user:, amount:)
    invoice = Invoice.create!(user:, amount:)
    after_commit { ChargeInvoiceJob.perform_async(invoice.id) }
    invoice
  end
end
```

Rules for using it:

- **Outside a transaction the block runs immediately.** That is the point:
  the service stays correct whether or not a caller wrapped it in a
  transaction. Don't guard it with your own `current_transaction` check.
- **Never call `after_commit` / `after_rollback` on an ActiveRecord model
  instance or class.** That registers the callback on every instance,
  including future ones. Include the module in the service object, or call
  `AfterCommitEverywhere.after_commit { ... }` directly.
- **`after_rollback` raises when called outside a transaction** (unlike
  `after_commit`). If the code path can run either way, guard it with
  `in_transaction?`.
- **Prefer this over a model `after_commit` callback** when the enqueue
  belongs to a use case rather than to the record's lifecycle. A model
  callback fires for every flow that touches the model, including fixtures,
  imports, and admin edits.

Enqueuing after the commit does not make the job safe on its own — it still
runs at-least-once, so `perform` needs its early-exit guards. See the
`martian-sidekiq` skill for the full transactional-enqueue options and
idempotency strategies.
