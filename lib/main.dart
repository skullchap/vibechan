import 'dart:ui'; // Import dart:ui for PointerDeviceKind
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:media_kit/media_kit.dart';

import 'config/app_config.dart';
import 'config/router.dart';
import 'core/di/injection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MediaKit.ensureInitialized();
  await configureDependencies();

  // Get the container from GetIt (it has the overrides inside).
  final container = await getIt.getAsync<ProviderContainer>();

  // Provide it to the app:
  runApp(
    UncontrolledProviderScope(container: container, child: const VibeChanApp()),
  );
}

class VibeChanApp extends StatelessWidget {
  const VibeChanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: AppConfig.appName,
      theme: AppConfig.lightTheme,
      darkTheme: AppConfig.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
