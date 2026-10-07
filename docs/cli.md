# Tour operator CLI

Use npm run itinerary -- help. Every read accepts --json. References accept an exact code, UUID prefix or case-insensitive name. Ambiguous matches list candidates and exit 1. Unknown options and unexpected arguments fail.

## Writes

- supplier-check <supplier> --reference="Evidence" --until=YYYY-MM-DD --date=YYYY-MM-DD records a supplier registration check already performed by a person.

- add <suppliers|products|rates|bookings|allotments|services|passengers|tasks|supplier_bills> --data=imports/record.json accepts only fields in the FIELDS allowlist in scripts/itinerary.mjs. Foreign references accept codes or names. Required database fields and checks are in supabase/migrations/0001_tours.sql. Create suppliers, products, rates, bookings, allotments and then services in that order.
- log <booking> --author="Actual recorder" --text="Observed event" [--date=YYYY-MM-DD] appends a note. Corrections are new notes. Notes cannot be edited or deleted.
- confirm <service> --reference="Supplier confirmation" records an existing confirmation. It does not request a reservation.
- service-status <service> --status=requested|cancelled records a known event.
- booking-status <booking> --status=quote|confirmed|completed|cancelled changes the booking. Cancelling also cancels its services atomically. It sends no supplier cancellation and computes no cancellation fees. Reopening leaves services cancelled until separately reviewed.
- terms <booking> --reference="Accepted terms record" records evidence already obtained.
- record-receipt <booking> --cents=50000 sets the externally reconciled cumulative received total and records a note. It does not increment, take money or allocate ledger entries. Repeat reconciliation cannot double count. Use the booking currency.
- release <allotment> releases only unsold capacity locally. Allocated units stay held. It does not notify the hotel.
- import tourwriter --file=export.csv [--mapping=columns.json] [--date-format=DMY] [--dry-run] imports the configured Itineraries detail report subset. See replace-tourwriter.md.
- export [--out=exports/new-backup.json] includes all eleven domain record types and the original mapped import payloads. Files are exclusive-create.
- draft-weekly creates a local Markdown review from attention, quote-desk, departure-readiness and compliance. Nothing sends.

Amounts ending in _cents are whole minor units. A service buy_cents is per unit in the rate currency; sell_cents is per unit in booking currency. fx means booking currency units per one supplier currency unit. Same-currency fx must be 1. Service costs are fixed snapshots, not live market rates. Rates and service dates must match. Tax is not calculated. quote-desk deducts the locally agreed commission from service revenue. Imported summary commission remains separate. Allotment units and service units must represent the same unit, such as rooms.

Use only controlled local files for imports. Imported customer data never belongs in Git. Local mode is single-process. Schema tours has RLS enabled without public policies, and views respect the caller's permissions. Provision staff roles and policies for a shared production deployment.

## Itinerary desk

- tasks-due: Review trip preparation tasks by due date. Use `npm run itinerary -- tasks-due`.
- supplier-bills: Review outstanding supplier bills in their own currencies. These are recorded commitments, not an accounting ledger. Use `npm run itinerary -- supplier-bills`.
- quote-desk: Review service totals and margin after the recorded agency commission. Zero services is incomplete costing. Use `npm run itinerary -- quote-desk`.
- season-watch: Find expired or soon-expiring supplier rates. Obtain an actual contract before adding a new season. Use `npm run itinerary -- season-watch`.
- departure-readiness: Review open tasks, passenger gaps, unpaid deposits and supplier confirmations together. Use `npm run itinerary -- departure-readiness`.
- consultant-workload: Review preparation work and unpaid deposits by consultant and currency. Use `npm run itinerary -- consultant-workload`.
- complete-task: Read the task and verify the work is done before recording completion. Use `npm run itinerary -- complete-task <task>`.
- record-bill-paid: Reconcile against the external account first. Set the cumulative paid amount in the supplier bill currency. Nothing pays or sends. Use `npm run itinerary -- record-bill-paid <bill> --cents=<cumulative_minor_units>`.
- commission: Read the itinerary and the actual agency agreement. Basis points are hundredths of one percent. The recorded commission is on service selling totals. Nothing pays. Use `npm run itinerary -- commission <booking> --bps=<basis_points>`.

New bookings default to zero agency commission. Record the actual agreement before relying on net margin. Supplier bills are an operational register, not a ledger, tax invoice system or payment service.
