import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {

  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  // Write data to secure storage
  Future<void> write(String key, String value) async {
    await _secureStorage.write(key: key, value: value);
  }

  // Read data from secure storage
  Future<String?> read(String key) async {
    return await _secureStorage.read(key: key);
  }

  // Delete data from secure storage
  Future<void> delete(String key) async {
    await _secureStorage.delete(key: key);
  }

  // Read all data
  Future<Map<String, String>> readAll() async {
    return await _secureStorage.readAll();
  }
}