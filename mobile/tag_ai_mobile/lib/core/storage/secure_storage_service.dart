// mobile/tag_ai_mobile/lib/core/storage/secure_storage_service.dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  final FlutterSecureStorage _storage;

  SecureStorageService() : _storage = const FlutterSecureStorage();

  static const String _keyToken = "tag_ai_access_token";
  static const String _keyDeviceId = "tag_ai_device_id";
  static const String _keyHostUrl = "tag_ai_host_url";

  /// Securely save issued Bearer Token
  Future<void> saveToken(String token) async {
    await _storage.write(key: _keyToken, value: token);
  }

  /// Load Bearer Token from encrypted storage
  Future<String?> loadToken() async {
    return await _storage.read(key: _keyToken);
  }

  /// Securely save device identifier
  Future<void> saveDeviceId(String deviceId) async {
    await _storage.write(key: _keyDeviceId, value: deviceId);
  }

  /// Load device identifier
  Future<String?> loadDeviceId() async {
    return await _storage.read(key: _keyDeviceId);
  }

  /// Save current paired laptop URL
  Future<void> saveHostUrl(String url) async {
    await _storage.write(key: _keyHostUrl, value: url);
  }

  /// Load paired laptop URL
  Future<String?> loadHostUrl() async {
    return await _storage.read(key: _keyHostUrl);
  }

  /// Clear all stored credentials and unpair
  Future<void> clearAll() async {
    await _storage.delete(key: _keyToken);
    await _storage.delete(key: _keyDeviceId);
    await _storage.delete(key: _keyHostUrl);
  }
}
