-- Auto-create a profile row (with a fresh random KDF salt) whenever a new
-- auth user is created. Runs as SECURITY DEFINER so it works regardless of
-- whether the client has an active session yet (e.g. email confirmation
-- still pending right after sign-up).
create function public.handle_new_user()
returns trigger
language plpgsql
security definer set search_path = public
as $$
begin
  insert into public.profiles (id, name, phone, kdf_salt)
  values (
    new.id,
    coalesce(new.raw_user_meta_data->>'name', ''),
    coalesce(new.raw_user_meta_data->>'phone', ''),
    encode(extensions.gen_random_bytes(16), 'base64')
  );
  return new;
end;
$$;

create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_user();
