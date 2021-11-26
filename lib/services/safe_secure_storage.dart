import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SafeSecureStorage implements FlutterSecureStorage {
  SafeSecureStorage(this.storage);

  final FlutterSecureStorage storage;
  @override
  Future<void> write({
    required String key,
    required String value,
    IOSOptions? iOptions,
    AndroidOptions? aOptions,
  }) async {
    await storage.write(
        key: key, value: value, iOptions: iOptions, aOptions: aOptions);
  }

  @override
  Future<void> delete({
    required String key,
    IOSOptions? iOptions,
    AndroidOptions? aOptions,
  }) {
    return storage.delete(key: key, iOptions: iOptions, aOptions: aOptions);
  }

  @override
  Future<void> deleteAll({IOSOptions? iOptions, AndroidOptions? aOptions}) {
    return storage.deleteAll(iOptions: iOptions, aOptions: aOptions);
  }

  @override
  Future<String> read({
    required String key,
    IOSOptions? iOptions,
    AndroidOptions? aOptions,
  }) {
    return storage.read(key: key, iOptions: iOptions, aOptions: aOptions);
  }

  @override
  Future<Map<String, String>> readAll({
    IOSOptions? iOptions,
    AndroidOptions? aOptions,
  }) {
    return storage.readAll(iOptions: iOptions, aOptions: aOptions);
  }

  @override
  Future<bool> containsKey({
    required String key,
    IOSOptions? iOptions,
    AndroidOptions? aOptions,
  }) {
    return storage.containsKey(
        key: key, iOptions: iOptions, aOptions: aOptions);
  }
}
