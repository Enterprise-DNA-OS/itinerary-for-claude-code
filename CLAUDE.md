# Itinerary for Claude Code

For an NZ inbound tour operator or destination management company reviewing supplier commitments, group departures and booking margins. Configure the business, operators and policies before live use.

Every answer starts with a current CLI read. Run npm run itinerary -- help. Read docs/cli.md before writing. Names are case insensitive. Ambiguity lists candidates and exits 1. AGENTS.md routes Codex, OpenCode and Cursor here.

| Recipe | Job |
|---|---|
| /tasks-due | Review trip preparation tasks by due date. |
| /supplier-bills | Review outstanding supplier bills in their own currencies. These are recorded commitments, not an accounting ledger. |
| /quote-desk | Review service totals and margin after the recorded agency commission. Zero services is incomplete costing. |
| /season-watch | Find expired or soon-expiring supplier rates. Obtain an actual contract before adding a new season. |
| /departure-readiness | Review open tasks, passenger gaps, unpaid deposits and supplier confirmations together. |
| /consultant-workload | Review preparation work and unpaid deposits by consultant and currency. |
| /complete-task | Read the task and verify the work is done before recording completion. |
| /record-bill-paid | Reconcile against the external account first. Set the cumulative paid amount in the supplier bill currency. Nothing pays or sends. |
| /commission | Read the itinerary and the actual agency agreement. Basis points are hundredths of one percent. The recorded commission is on service selling totals. Nothing pays. |
| /supplier-check | Record a verified supplier registration reference, expiry and check date. |
| /suppliers | Review supplier contacts and recorded registration dates. |
| /products | Read the supplier product list by location. |
| /rates | Review contracted dates, units, costs and cancellation terms. |
| /bookings | Read the booking register. |
| /departures | Review confirmed departures in the next thirty days. |
| /services | Read the itinerary services and confirmations. |
| /supplier-chase | Find requested services and the supplier who must confirm them. |
| /release-dates | Review held allotments approaching release and the unsold units. |
| /margin-watch | Compare service costs and selling amounts by booking currency. Zero services means missing cost detail. |
| /quote-followup | Review quote expiry and days since last contact. |
| /deposits-due | Review deposits due after externally reconciled receipts. |
| /cancellation-watch | Review contractual cancellation deadlines in the next seven days. |
| /rooming-list | Read recorded passenger names and room assignments. |
| /manifest-gaps | Compare named passengers with expected group sizes. |
| /supplier-exposure | Group confirmed commitments by supplier and supplier currency. |
| /agent-margin | Compare current service margins by agent and currency. |
| /unconfirmed-low-margin | Find confirmed departures with thin margins and unconfirmed services. |
| /imported-summaries | Read financial snapshots from the Tourwriter export separately from current service costing. |
| /compliance | Read docs/compliance.md, then identify missing evidence. Do not call a clear list legal approval. |
| /attention | Collect overdue confirmations, releases, deposits and quotes. |
| /booking | Run `npm run itinerary -- booking "<code, name or UUID prefix>"`. Read the booking, services, passengers and notes before drafting. If ambiguous, show the candidates and resolve the reference. |
| /add | Read docs/cli.md and the migration. Put supplied fields in a private JSON file, then run `npm run itinerary -- add <type> --data=imports/record.json`. Read the result back. Never infer supplier terms or exchange rates. |
| /log | Read the booking first. Run `npm run itinerary -- log <booking> --author="<recorder>" --text="<observed event>"`. Notes are append-only. Corrections are new notes naming the earlier entry. |
| /confirm | Read the service and actual supplier evidence. Run `npm run itinerary -- confirm <service> --reference="<confirmation reference>"`. Recording evidence sends no booking request. |
| /service-status | Read the service. Record a supplied event with `npm run itinerary -- service-status <service> --status=requested or cancelled`. No cancellation notice is sent. |
| /booking-status | Read the booking and all services. Run `npm run itinerary -- booking-status <booking> --status=quote or confirmed or completed or cancelled`. Cancellation changes local services too. Supplier cancellation and fees need separate review. |
| /terms | Read the booking and accepted terms evidence. Run `npm run itinerary -- terms <booking> --reference="<evidence>"`. Never treat a draft as acceptance. |
| /record-receipt | Reconcile against the external account first. Run `npm run itinerary -- record-receipt <booking> --cents=<cumulative_received_total>`. This sets a cumulative total and writes a note. It does not take payment. |
| /release | Read release-dates and the allotment. Run `npm run itinerary -- release <allotment>`. Only unsold units are removed from local capacity. Tell the operator the hotel has not been notified. |
| /import | Read docs/replace-tourwriter.md. Export an Itineraries detail report and check the column mapping. Run `npm run itinerary -- import tourwriter --file=imports/tour-summary.csv --dry-run`, reconcile the fields, then repeat without --dry-run. Do not promise services or passenger names from a summary. |
| /export | Create a private exports directory. Run `npm run itinerary -- export --out=exports/new-backup.json`. Verify all eleven record types. Keep a database backup too. Never publish customer records. |
| /weekly-review | Run `npm run itinerary -- attention`, `npm run itinerary -- margin-watch` and `npm run itinerary -- compliance`. Name the departures, deadlines, currencies and missing evidence. Read booking details for exceptions. Save with draft-weekly. |
| /draft-weekly | Run `npm run itinerary -- draft-weekly`. Inspect the Markdown in drafts/. It uses current attention, quote-desk, departure-readiness and compliance results. Nothing sends. |
| /documents | Set brand.json to the business identity. Run `npm run docs` and inspect the itinerary, rooming list, costing and voucher drafts. A requested service cannot become a confirmed voucher. Nothing sends. |
| /new-view | Read views.json and the existing database views. Add a fixed read-only query for the requested report, then run `npm run view` and `npm test`. Inspect the HTML. Keep customer data local. |
| /customise | Read the schema and export a backup first. Write a new numbered migration for the requested field, stage or rule. Apply with `npm run migrate`. Update the CLI allowlist, query, document and recipe as needed. Run `npm test` and demonstrate the changed workflow. Never edit an applied migration or invent records. |

## Rules

- Never invent a supplier confirmation, contract rate, passenger, registration, receipt or exchange rate.
- Everything is local. Never send, charge, reserve with a supplier or cancel externally. Communications and documents are drafts.
- Monetary amounts stay grouped by currency. Supplier buys and booking sells can use different currencies. fx is an explicitly recorded conversion rate.
- Imported summary amounts remain separate from service costing and the operational deposit tally. A missing itinerary is not a zero-cost trip.
- Compliance means evidence checks, not a safety audit or legal approval. Read docs/compliance.md.
- Keep passenger data and exports private. Do not store passport scans or medical details.
- Staff authentication, permissions, encrypted backups and deployment validation are required for shared operation.
- New fields and policies go through numbered migrations and npm test. Never edit an applied migration.

Schema: supabase/migrations. CLI: scripts/itinerary.mjs. Rendering: brand.json, views.json and documents.json. Omni by Enterprise DNA customises and operates the system.
