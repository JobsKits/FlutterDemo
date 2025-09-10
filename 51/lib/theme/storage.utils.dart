import 'dart:convert';

import 'package:get_storage/get_storage.dart';

final class StorageKeys {
  static String theme = "theme";
}

class StorageUtils {
  static StorageUtils? _instance;

  factory StorageUtils() {
    _instance ??= StorageUtils._internal();
    return _instance!;
  }

  StorageUtils._internal();

  GetStorage storage = GetStorage();

  init() async {
    await GetStorage.init();
  }

  setStorage({
    required String key,
    required Object value,
  }) {
    final data = jsonEncode(value);
    storage.write(key, data);
  }

  String? read(String key) {
    return storage.read<String>(key);
  }

  Future save(String key, dynamic value) {
    return storage.write(key, value);
  }

  getStorage({
    required String key,
  }) {
    final data = storage.read(key);
    if (data != null) {
      return jsonDecode(data);
    } else {
      return null;
    }
  }

  remove({
    required String key,
  }) {
    storage.remove(key);
  }

  removeAll() {
    storage.erase();
  }
}
