alter table tours.bookings add column commission_bps integer not null default 0 check(commission_bps between 0 and 10000);
create table tours.tasks (
 id uuid primary key default gen_random_uuid(), code text not null unique, booking_id uuid not null references tours.bookings(id),
 name text not null check(length(trim(name))>0), owner text not null, due_on date not null, status text not null default 'open' check(status in ('open','done')),
 created_at timestamptz not null default now(), updated_at timestamptz not null default now()
);
create table tours.supplier_bills (
 id uuid primary key default gen_random_uuid(), code text not null unique, supplier_id uuid not null references tours.suppliers(id), booking_id uuid not null references tours.bookings(id),
 name text not null, currency text not null check(currency ~ '^[A-Z]{3}$'), amount_cents bigint not null check(amount_cents>=0),
 paid_cents bigint not null default 0 check(paid_cents>=0 and paid_cents<=amount_cents), due_on date not null, reference text not null check(length(trim(reference))>0),
 created_at timestamptz not null default now(), updated_at timestamptz not null default now()
);
create trigger touch before update on tours.tasks for each row execute function tours.touch();
create trigger touch before update on tours.supplier_bills for each row execute function tours.touch();
alter table tours.tasks enable row level security;
alter table tours.supplier_bills enable row level security;
revoke all on tours.tasks,tours.supplier_bills from public;
create index on tours.tasks(booking_id);
create index on tours.tasks(due_on) where status='open';
create index on tours.supplier_bills(booking_id);
create index on tours.supplier_bills(supplier_id);
create index on tours.products(supplier_id);
create index on tours.rates(product_id);
create index on tours.services(rate_id);
create index on tours.notes(booking_id);
create index on tours.import_rows(booking_id);
create unique index on tours.bookings(lower(code));
create view tours.quote_desk with (security_invoker=true) as
 select m.code,m.name,m.currency,b.quote_expires,m.service_count,m.revenue_cents,m.cost_cents,b.commission_bps,
 round(m.revenue_cents::numeric*b.commission_bps/10000)::bigint commission_cents,
 m.margin_cents-round(m.revenue_cents::numeric*b.commission_bps/10000)::bigint margin_after_commission_cents,
 round(100.0*(m.margin_cents-round(m.revenue_cents::numeric*b.commission_bps/10000))/nullif(m.revenue_cents,0),1) margin_after_commission_pct
 from tours.booking_margins m join tours.bookings b on b.id=m.id where m.status in ('quote','confirmed');
create view tours.departure_readiness with (security_invoker=true) as
 select b.code,b.name,b.travel_date,b.consultant,b.currency,b.status,m.awaiting_confirmation,
 (select count(*)::integer from tours.tasks t where t.booking_id=b.id and t.status='open') open_tasks,
 b.pax-(select count(*)::integer from tours.passengers p where p.booking_id=b.id) unnamed_travellers,
 case when b.deposit_due<current_date then greatest(b.deposit_cents-b.received_cents,0) else 0 end overdue_deposit_cents,
 nullif(trim(b.terms_ref),'') is not null terms_recorded
 from tours.bookings b join tours.booking_margins m on m.id=b.id;
