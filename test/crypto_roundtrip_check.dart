import 'dart:convert';
import 'package:password_manager/Singletons/CryptoService.dart';

/// Standalone script (not part of the automated test suite) used to verify
/// the CryptoService round-trips correctly, and to produce a real ciphertext
/// for manual end-to-end verification against the live Supabase backend.
/// Run with: dart run test/crypto_roundtrip_check.dart
void main(List<String> args) {
  final masterPassword = args.isNotEmpty ? args[0] : 'CorrectHorseBattery1';
  final plainPassword = args.length > 1 ? args[1] : 'hunter2';
  final salt = args.length > 2 ? args[2] : CryptoService.generateSalt();

  cryptoService.deriveKey(masterPassword, salt);
  final payload = cryptoService.encryptText(plainPassword);

  cryptoService.clear();
  cryptoService.deriveKey(masterPassword, salt);
  final decrypted = cryptoService.decryptText(payload);

  final result = {
    'salt': salt,
    'ciphertext': payload.ciphertext,
    'iv': payload.iv,
    'decrypted': decrypted,
    'roundtripOk': decrypted == plainPassword,
  };

  print(jsonEncode(result));
}
