import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/database/hive_service.dart';
import 'app.dart';

/// Application bootstrap — initializes services before runApp.
Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();

  final hiveService = HiveService();
  await hiveService.init();

  runApp(
    ProviderScope(
      overrides: [
        hiveServiceProvider.overrideWithValue(hiveService),
      ],
      child: const ActTConnectApp(),
    ),
  );
}
