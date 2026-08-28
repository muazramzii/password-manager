-- Encrypted vault entries. The server only ever stores ciphertext:
-- encrypted_password/iv are AES-256-CBC output produced client-side,
-- so Supabase (and anyone with DB access) never sees a plaintext password.
create table public.vault_items (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  site_name text not null,
  account_username text not null,
  encrypted_password text not null,
  iv text not null,
  created_at timestamptz not null default now()
);

alter table public.vault_items enable row level security;

create policy "Users can view own vault items"
  on public.vault_items for select
  using (auth.uid() = user_id);

create policy "Users can insert own vault items"
  on public.vault_items for insert
  with check (auth.uid() = user_id);

create policy "Users can update own vault items"
  on public.vault_items for update
  using (auth.uid() = user_id);

create policy "Users can delete own vault items"
  on public.vault_items for delete
  using (auth.uid() = user_id);
