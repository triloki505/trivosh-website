-- Supabase SQL Editor. Replace OWNER_AUTH_USER_UUID with your owner user's Auth UUID.
create extension if not exists pgcrypto;
create table if not exists public.products(id uuid primary key default gen_random_uuid(),name text not null,price numeric(10,2) not null check(price>0),size text default '',image_url text,description text default '',active boolean not null default true,created_at timestamptz not null default now());
create table if not exists public.orders(id uuid primary key default gen_random_uuid(),customer_name text not null,phone text not null,address text not null,items jsonb not null,total numeric(10,2) not null check(total>0),status text not null default 'pending' check(status in ('pending','paid','processing','shipped','cancelled')),created_at timestamptz not null default now());
alter table public.products enable row level security; alter table public.orders enable row level security;
create policy "Public can view active products" on public.products for select to anon,authenticated using(active=true or auth.uid()='OWNER_AUTH_USER_UUID'::uuid);
create policy "Owner inserts products" on public.products for insert to authenticated with check(auth.uid()='OWNER_AUTH_USER_UUID'::uuid);
create policy "Owner updates products" on public.products for update to authenticated using(auth.uid()='OWNER_AUTH_USER_UUID'::uuid) with check(auth.uid()='OWNER_AUTH_USER_UUID'::uuid);
create policy "Public creates pending orders" on public.orders for insert to anon,authenticated with check(status='pending');
create policy "Owner views orders" on public.orders for select to authenticated using(auth.uid()='OWNER_AUTH_USER_UUID'::uuid);
create policy "Owner updates orders" on public.orders for update to authenticated using(auth.uid()='OWNER_AUTH_USER_UUID'::uuid) with check(auth.uid()='OWNER_AUTH_USER_UUID'::uuid);
