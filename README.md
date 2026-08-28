# Password Manager

A Flutter password manager originally built as a diploma Final Year Project
(Politeknik Ungku Omar, 2021) — "Password Manager Apps With Encryption".

Users register and log in, then store website/app credentials in an
encrypted vault. Passwords are encrypted **client-side** with AES-256
before they ever leave the device, so the backend only ever stores
ciphertext.

## Architecture

- **Flutter** app (Dart, null-safe, Flutter 3.29+)
- **Supabase** for Auth (email/password) and Postgres storage, with Row
  Level Security so each user can only read/write their own data
- **Client-side AES-256-CBC encryption**, keyed by a PBKDF2 (HMAC-SHA256)
  derivation of the user's login password + a random per-user salt. The
  derived key only ever lives in memory on-device; Supabase never sees a
  plaintext vault password.

### Data model

- `profiles` — name/phone + per-user `kdf_salt`, auto-created via a
  Postgres trigger (`handle_new_user`) when a new `auth.users` row is
  created (see `supabase/migrations`).
- `vault_items` — one row per saved account: `site_name`,
  `account_username`, `encrypted_password`, `iv`. Both tables have RLS
  policies restricting all access to `auth.uid()`.

## Getting started

1. Install [Flutter](https://flutter.dev/docs/get-started/install) (3.29+)
   and run:
   ```
   flutter pub get
   ```
2. The app is already pointed at a live Supabase project
   (`lib/Singletons/SupabaseConfig.dart`). To point it at your own project
   instead, create a Supabase project and apply the SQL files in
   `supabase/migrations/` in order, then update `SupabaseConfig.url` and
   `SupabaseConfig.publishableKey`.
3. Run the app:
   ```
   flutter run
   ```
   (or `flutter build web` / `flutter create --platforms=web .` if you
   want a browser target)

## Tests

```
flutter test
```

`test/crypto_roundtrip_check.dart` is a standalone script (not part of the
suite) for manually sanity-checking the encryption round-trip:

```
dart run test/crypto_roundtrip_check.dart
```

## Known limitations

- Profile editing and "About" screens are placeholders (not wired up).
- No password-reset flow yet — relies on Supabase Auth defaults.
