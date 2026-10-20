-- Supabase Dashboard > SQL Editor. Replace EVERY OWNER_AUTH_USER_UUID below with the owner's Auth > Users > UID.
create extension if not exists pgcrypto;
create table if not exists public.products (
  id uuid primary key default gen_random_uuid(), name text not null,
  price numeric(10,2) not null check(price > 0), size text default '',
  image_url text, description text default '', active boolean not null default true,
  created_at timestamptz not null default now()
);
create table if not exists public.orders (
  id uuid primary key default gen_random_uuid(), customer_name text not null,
  phone text not null, address text not null, items jsonb not null,
  total numeric(10,2) not null check(total > 0),
  status text not null default 'pending' check(status in ('pending','paid','processing','shipped','cancelled')),
  created_at timestamptz not null default now()
);
alter table public.products enable row level security;
alter table public.orders enable row level security;
-- Remove prior versions of these policies before re-running this script.
drop policy if exists "Public can view active products" on public.products;
drop policy if exists "Owner inserts products" on public.products;
drop policy if exists "Owner updates products" on public.products;
drop policy if exists "Owner deletes products" on public.products;
drop policy if exists "Public creates pending orders" on public.orders;
drop policy if exists "Owner views orders" on public.orders;
drop policy if exists "Owner updates orders" on public.orders;
create policy "Public can view active products" on public.products for select to anon, authenticated using (active = true or auth.uid() = 'OWNER_AUTH_USER_UUID'::uuid);
create policy "Owner inserts products" on public.products for insert to authenticated with check (auth.uid() = 'OWNER_AUTH_USER_UUID'::uuid);
create policy "Owner updates products" on public.products for update to authenticated using (auth.uid() = 'OWNER_AUTH_USER_UUID'::uuid) with check (auth.uid() = 'OWNER_AUTH_USER_UUID'::uuid);
create policy "Owner deletes products" on public.products for delete to authenticated using (auth.uid() = 'OWNER_AUTH_USER_UUID'::uuid);
create policy "Public creates pending orders" on public.orders for insert to anon, authenticated with check (status = 'pending');
create policy "Owner views orders" on public.orders for select to authenticated using (auth.uid() = 'OWNER_AUTH_USER_UUID'::uuid);
create policy "Owner updates orders" on public.orders for update to authenticated using (auth.uid() = 'OWNER_AUTH_USER_UUID'::uuid) with check (auth.uid() = 'OWNER_AUTH_USER_UUID'::uuid);
-- Initial catalogue. Existing product names are not duplicated on re-run.
insert into public.products(name,price,size,description,active)
select v.name,v.price,v.size,v.description,true from (values
 ('Floor Cleaner',99,'1 Litre','Quality cleaning product at a good value.'),
 ('Dish Wash',85,'500 ml','For everyday dish cleaning.'),
 ('Toilet Cleaner',89,'500 ml','For toilet and washroom cleaning.'),
 ('Bathroom Cleaner',99,'500 ml','For bathroom surfaces.'),
 ('Glass Cleaner',79,'500 ml','For glass and shiny surfaces.'),
 ('Detergent Liquid',149,'1 Litre','Laundry cleaning liquid.'),
 ('Car Wash',129,'500 ml','For car exterior cleaning.')
) as v(name,price,size,description)
where not exists (select 1 from public.products p where p.name=v.name);
