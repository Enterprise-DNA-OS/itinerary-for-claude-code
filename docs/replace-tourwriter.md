# Bring Tourwriter itinerary history across

Source checked 7 October 2026: [Tourwriter Reporting](https://learn.tourwriter.com/portal/en/kb/articles/reporting-in-tourwriter). Tourwriter documents CSV export from reports, and three sources: Itineraries, Itinerary Item Details and Traveller Payments. Report columns are configurable. The vendor does not publish one fixed CSV header contract on that help page.

1. In Tourwriter Reporting, choose Itineraries and a detail report. Use an administrator account with access. Remove filters that exclude history you want to retain. Export the CSV.
2. Include a stable itinerary identifier, itinerary name, agency, owner, start date, traveller count, currency and status. Match the headings below or supply a mapping file. Do not import aggregate charts as individual itineraries. Blank agency/owner values must be resolved from the source, not guessed.
3. Copy the export to the ignored imports/ directory. Run a test import, reconcile counts, currencies and totals, then import it in one command.

```bash
npm run itinerary -- import tourwriter --file=imports/itineraries.csv --dry-run
npm run itinerary -- import tourwriter --file=imports/itineraries.csv
npm run itinerary -- imported-summaries
```

The first command executes the same validation in a rolled-back transaction. Any invalid row rolls back the entire file. Identical repeated imports are skipped. A changed source record or existing booking code stops the batch for reconciliation rather than overwriting local work.

| Local field | Accepted heading in the supplied profile | Required |
|---|---|---|
| code | Itinerary ID | Yes, stable and unique |
| name | Itinerary Name | Yes |
| agent | Agency | Yes |
| consultant | Owner | Yes |
| travel_date | Start Date | Yes |
| pax | Travellers | Yes, positive integer |
| currency | Currency | Yes, uppercase three-letter code |
| source_status | Status | Yes, known status |
| summary_cost_cents | Total Cost | No |
| summary_sell_cents | Total Sold | No |
| summary_commission_cents | Commission | No |
| summary_invoiced_cents | Invoiced | No |
| summary_receipted_cents | Received | No |

These are this importer's profile headings, not a verified universal Tourwriter export layout. examples/tourwriter-summary.csv is a synthetic fixture. If your export labels differ, create a private JSON mapping such as {"code":"Reference","travel_date":"Departure"} and pass --mapping=imports/columns.json. Unknown mapping keys fail. Check each field's meaning against Tourwriter before mapping. ISO dates work by default. For day/month/year dates, explicitly pass --date-format=DMY. Ambiguous dates fail without that setting. Money is imported as decimal major units with up to two decimals and stored as integer cents. Do not map supplier-currency amounts to itinerary-currency totals.

Draft, proposal, quotation and quote map to quote. Confirmed, deposit invoice and invoiced map to confirmed. Completed and finalised map to completed. Cancelled and cancelled with cost map to cancelled. These are explicit importer mappings, not a claim about every Tourwriter status. Unknown statuses fail for human review.

The one-command import covers itinerary headers and optional financial snapshots. Missing money stays null. Imported receipts do not become operational deposits or payments. Imported totals are kept separately from locally costed services. Itinerary items, supplier contracts, seasonal rates, photos, traveller identities, task histories and accounting transactions need their own source exports and mapping. An itinerary header alone does not produce a complete quotation or travel document. Enterprise DNA includes that migration work in a scoped setup.

Validate a sample first. Match row counts and each currency's amounts against the original report. Check cancelled records. Add actual service lines and dates before quoting or issuing documents. Keep the original export and a database backup private. The free import is a one-command starting point after mapping, not a promise to migrate every module in a day.
