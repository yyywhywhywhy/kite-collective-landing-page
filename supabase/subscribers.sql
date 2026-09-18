-- Newsletter signups from the guide pages.
-- Row-level security: anyone may insert their own email; nobody can read,
-- change or delete rows with the public key. Read the list in the dashboard.
create table if not exists public.subscribers (
  id bigint generated always as identity primary key,
  email text not null unique,
  source text,
  created_at timestamptz not null default now()
);
alter table public.subscribers enable row level security;
create policy anyone_can_subscribe on public.subscribers
  for insert to anon
  with check (char_length(email) between 5 and 254 and position('@' in email) > 1);
