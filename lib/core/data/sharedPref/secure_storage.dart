
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageHelper {
  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  // Secret key (32 chars for AES-256)
  static final _key = encrypt.Key.fromUtf8('my32lengthsupersecretnooneknows!');
  static final _iv = encrypt.IV.fromUtf8('16byteslongiv456'); // 16 bytes

  static final _encrypter = encrypt.Encrypter(encrypt.AES(_key));

  /// Encrypt value before saving
  static Future<void> write(String key, String value) async {
    final encrypted = _encrypter.encrypt(value, iv: _iv);
    await _storage.write(key: key, value: encrypted.base64);
  }

  /// Read and decrypt value
  static Future<String?> read(String key) async {
    final encryptedValue = await _storage.read(key: key);
    if (encryptedValue == null) return null;

    try {
      final decrypted =
      _encrypter.decrypt64(encryptedValue, iv: _iv);
      return decrypted;
    } catch (e) {
      return null; // in case of tampered/invalid value
    }
  }

  /// Delete a value
  static Future<void> delete(String key) async {
    await _storage.delete(key: key);
  }

  /// Check if a key exists
  static Future<bool> containsKey(String key) async {
    return await _storage.containsKey(key: key);
  }

  /// Delete all values
  static Future<void> deleteAll() async {
    await _storage.deleteAll();
  }
}
