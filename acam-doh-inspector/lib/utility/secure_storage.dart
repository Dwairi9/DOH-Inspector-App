import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static Future<void> write(String key, String value) async {
    const storage = FlutterSecureStorage();
    await storage.write(key: key, value: value);
  }

  static Future<String?> read(String key) async {
    const storage = FlutterSecureStorage();
    return await storage.read(key: key);
  }

  static Future<void> delete(String key) async {
    const storage = FlutterSecureStorage();
    await storage.delete(key: key);
  }

  static Future<void> writeBool(String key, bool value) async {
    const storage = FlutterSecureStorage();
    await storage.write(key: key, value: value.toString());
  }

  static Future<bool> readBool(String key) async {
    const storage = FlutterSecureStorage();
    var value = await storage.read(key: key);
    if (value == null) {
      return false;
    }
    return value.toLowerCase() == "true";
  }
}
