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

## Android release builds

The app is signed for release and ready to build a Play Store bundle:

```
flutter build appbundle --release   # .aab for Play Store upload
flutter build apk --release         # .apk for direct install/testing
```

This requires `android/key.properties` (gitignored, not in this repo) pointing
at a release keystore:

```
storePassword=...
keyPassword=...
keyAlias=...
storeFile=/absolute/path/to/keystore.jks
```

**The release keystore is not part of this repo and must never be committed.**
Losing it means you can never publish an update to the same Play Store
listing again — back it up somewhere durable (not just this machine).

## Known limitations

- Profile screen is read-only (no editing yet).
- No password-reset flow yet — relies on Supabase Auth defaults.
- Release build has been verified to build, sign (real keystore, not debug),
  and minify correctly, but has not been installed and exercised on a
  physical/emulated Android device — do that before submitting to Play Store.
