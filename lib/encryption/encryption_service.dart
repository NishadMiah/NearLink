import 'dart:typed_data';
import 'package:encrypt/encrypt.dart';
import 'package:get/get.dart';

class EncryptionService extends GetxService {
  late Key _key;
  late IV _iv;
  late Encrypter _encrypter;

  EncryptionService() {
    // In production, this key comes from ECDH KeyExchangeService
    _key = Key.fromSecureRandom(32); // 256-bit
    _iv = IV.fromSecureRandom(16);
    _encrypter = Encrypter(AES(_key, mode: AESMode.gcm));
  }

  String encryptText(String plainText) {
    final encrypted = _encrypter.encrypt(plainText, iv: _iv);
    return encrypted.base64;
  }

  String decryptText(String base64Encrypted) {
    final encrypted = Encrypted.fromBase64(base64Encrypted);
    return _encrypter.decrypt(encrypted, iv: _iv);
  }

  List<int> encryptBytes(List<int> bytes) {
    final encrypted = _encrypter.encryptBytes(bytes, iv: _iv);
    return encrypted.bytes;
  }

  List<int> decryptBytes(List<int> encryptedBytes) {
    final encrypted = Encrypted(Uint8List.fromList(encryptedBytes));
    return _encrypter.decryptBytes(encrypted, iv: _iv);
  }
}
