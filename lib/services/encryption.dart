import 'package:encrypt/encrypt.dart' as encryptLib;

class EncryptionService {
  static final key = encryptLib.Key.fromLength(32);
  static final iv = encryptLib.IV.fromLength(16);

  static final encrypter = encryptLib.Encrypter(
    encryptLib.AES(key, mode: encryptLib.AESMode.cbc),
  );

  static String encrypt(String text) {
    final encrypted = encrypter.encrypt(text, iv: iv);
    return encrypted.base64;
  }

  static String decrypt(String encryptedText) {
    final encrypted = encryptLib.Encrypted.fromBase64(encryptedText);
    final decrypted = encrypter.decrypt(encrypted, iv: iv);
    return decrypted;
  }
}
