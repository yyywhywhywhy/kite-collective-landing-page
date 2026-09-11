-- Kite Collective contact form storage.
-- Run once in Supabase: Dashboard → SQL Editor → New query → paste → Run.
-- Visitors (anon key) can only INSERT; nobody can read rows with the public key.

create table if not exists public.contact_submissions (
  id          bigint generated always as identity primary key,
  created_at  timestamptz not null default now(),
  name        text not null check (char_length(name) between 1 and 120),
  email       text not null check (email ~* '^[^@\s]+@[^@\s]+\.[^@\s]+$' and char_length(email) <= 254),
  interest    text not null check (interest in ('workshop','team','ecommerce','sprint','speaking','other')),
  company     text check (char_length(company) <= 160),
  message     text check (char_length(message) <= 4000),
  lang        text check (lang in ('en','zh')),
  source      text check (char_length(source) <= 200)
);

alter table public.contact_submissions enable row level security;

drop policy if exists "anon can submit" on public.contact_submissions;
create policy "anon can submit"
  on public.contact_submissions
  for insert
  to anon
  with check (true);

-- Allow the insert only; no select/update/delete grants for the public role.
revoke all on public.contact_submissions from anon;
grant insert on public.contact_submissions to anon;
