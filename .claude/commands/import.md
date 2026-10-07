# Import itinerary history

Read docs/replace-tourwriter.md. Export a Tourwriter Itineraries detail report. Match the required headings or supply a checked mapping. Run `npm run itinerary -- import tourwriter --file=imports/itineraries.csv --dry-run`. Reconcile counts and currencies, then repeat without --dry-run. Missing source amounts stay unknown. This imports headers and financial snapshots only. Never claim that services, supplier rates or traveller names have been migrated.
