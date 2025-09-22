import 'package:get_storage/get_storage.dart';

class CacheService {
  static const _storageKey = 'country_cache';

  final GetStorage _storage = GetStorage();

  Map<String, dynamic>? getCache() {
    return _storage.read(_storageKey);
  }

  void setCache(Map<String, dynamic> data) {
    _storage.write(_storageKey, data);
  }

  void clearCache() {
    _storage.remove(_storageKey);
  }

  void clearAll() {
    _storage.erase();
  }
}
