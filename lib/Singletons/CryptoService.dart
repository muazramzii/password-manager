import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:encrypt/encrypt.dart' as enc;
import 'package:pointycastle/export.dart' as pc;

/// Derives a per-user AES key from the account's master password (the same
/// password used to log in) and encrypts/decrypts vault entries with it.
/// The derived key only ever lives in memory on this device — Supabase only
/// ever stores ciphertext, so the server cannot read stored passwords.
class CryptoService {
  static final CryptoService _instance = CryptoService._internal();
  factory CryptoService() => _instance;
  CryptoService._internal();

  // 100k is a well-established practical minimum for PBKDF2-HMAC-SHA256.
  // Kept here (rather than higher) because this runs on the UI thread with
  // no isolate offload available on Flutter web.
  static const int _pbkdf2Iterations = 100000;
  static const int _keyLengthBytes = 32;

  enc.Key? _key;

  bool get isReady => _key != null;

  static String generateSalt() {
    final random = Random.secure();
    final bytes = Uint8List.fromList(
      List<int>.generate(16, (_) => random.nextInt(256)),
    );
    return base64Encode(bytes);
  }

  void deriveKey(String masterPassword, String saltBase64) {
    final salt = base64Decode(saltBase64);
    final derivator = pc.PBKDF2KeyDerivator(pc.HMac(pc.SHA256Digest(), 64))
      ..init(pc.Pbkdf2Parameters(salt, _pbkdf2Iterations, _keyLengthBytes));
    final keyBytes = derivator.process(
      Uint8List.fromList(utf8.encode(masterPassword)),
    );
    _key = enc.Key(keyBytes);
  }

  void clear() {
    _key = null;
  }

  // GCM is authenticated encryption: it detects tampering with the
  // ciphertext (returns an error on decrypt) rather than silently producing
  // garbage the way CBC would. The recommended nonce length for GCM is 12
  // bytes, not the 16-byte IV a block mode like CBC would use.
  EncryptedPayload encryptText(String plainText) {
    final key = _key;
    if (key == null) {
      throw StateError('Encryption key not initialized. Log in again.');
    }
    final iv = enc.IV.fromSecureRandom(12);
    final encrypter = enc.Encrypter(enc.AES(key, mode: enc.AESMode.gcm));
    final encrypted = encrypter.encrypt(plainText, iv: iv);
    return EncryptedPayload(ciphertext: encrypted.base64, iv: iv.base64);
  }

  String decryptText(EncryptedPayload payload) {
    final key = _key;
    if (key == null) {
      throw StateError('Encryption key not initialized. Log in again.');
    }
    final encrypter = enc.Encrypter(enc.AES(key, mode: enc.AESMode.gcm));
    return encrypter.decrypt64(
      payload.ciphertext,
      iv: enc.IV.fromBase64(payload.iv),
    );
  }
}

class EncryptedPayload {
  final String ciphertext;
  final String iv;

  EncryptedPayload({required this.ciphertext, required this.iv});
}

final cryptoService = CryptoService();
