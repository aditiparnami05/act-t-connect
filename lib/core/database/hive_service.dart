import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// Hive local storage service for offline mode.
class HiveService {
  static const String settingsBox = 'settings';
  static const String cacheBox = 'cache';

  Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox(settingsBox);
    await Hive.openBox(cacheBox);
  }

  Box get settings => Hive.box(settingsBox);
  Box get cache => Hive.box(cacheBox);

  Future<void> putSetting(String key, dynamic value) async {
    await settings.put(key, value);
  }

  T? getSetting<T>(String key, {T? defaultValue}) {
    return settings.get(key, defaultValue: defaultValue) as T?;
  }

  Future<void> clearAll() async {
    await settings.clear();
    await cache.clear();
  }
}

final hiveServiceProvider = Provider<HiveService>((ref) => HiveService());

final offlineModeProvider = StateProvider<bool>((ref) => true);
