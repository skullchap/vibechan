import 'dart:ui'; // Import dart:ui for PointerDeviceKind
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:media_kit/media_kit.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'config/app_config.dart';
import 'config/router.dart';
import 'core/di/injection.dart';
import 'core/theme/theme_provider.dart';
import 'core/services/theme_persistence_service.dart';
import 'features/fourchan/presentation/providers/board_providers.dart';
import 'features/fourchan/presentation/providers/thread_providers.dart';
import 'features/fourchan/domain/repositories/board_repository.dart';
import 'features/fourchan/domain/repositories/thread_repository.dart';
// Import layout service for responsive layout
import 'core/services/layout_service.dart';

// Main function with enhanced error handling
void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    MediaKit.ensureInitialized();

    // Print debug information about GetIt
    debugPrint("➡️ GetIt instance hash: ${getIt.hashCode}");

    // Initialize shared preferences directly
    final prefs = await SharedPreferences.getInstance();

    // Configure dependencies correctly
    await configureDependencies();

    // Debug: Check if ThemePersistenceService is registered
    debugPrint(
      "➡️ Is ThemePersistenceService registered? ${getIt.isRegistered<ThemePersistenceService>()}",
    );

    // If not registered, register it manually
    if (!getIt.isRegistered<ThemePersistenceService>()) {
      debugPrint("⚠️ Manually registering ThemePersistenceService");
      getIt.registerSingleton<ThemePersistenceService>(
        ThemePersistenceService(prefs),
      );
    }

    // Get repositories that need to be overridden
    final boardRepository = getIt<BoardRepository>(instanceName: '4chan');
    final threadRepository = getIt<ThreadRepository>(instanceName: '4chan');

    // Run the app with Riverpod and provide necessary overrides
    runApp(
      ProviderScope(
        overrides: [
          // Provide the implementations for the repository providers
          boardRepositoryProvider.overrideWithValue(boardRepository),
          threadRepositoryProvider.overrideWithValue(threadRepository),
        ],
        child: const VibeChanApp(),
      ),
    );
  } catch (e, st) {
    debugPrint("🛑 Error in main: $e");
    debugPrint("🛑 Stack trace: $st");
    rethrow; // Rethrow to let Flutter show the error
  }
}

class VibeChanApp extends ConsumerWidget {
  const VibeChanApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the theme provider state
    final themeState = ref.watch(appThemeProvider);
    final themeNotifier = ref.read(appThemeProvider.notifier);

    // Add a listener to initialize layout state after the app is built
    Future.microtask(() {
      if (context.mounted) {
        ref.read(layoutStateNotifierProvider.notifier).updateLayout(context);
      }
    });

    return MaterialApp.router(
      title: AppConfig.appName,
      // Use themes from the notifier
      theme: themeNotifier.lightTheme,
      darkTheme: themeNotifier.darkTheme,
      themeMode: themeState.themeMode, // Use themeMode from the state
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      // Add a builder to update layout when app is resized
      builder: (context, child) {
        // Trigger layout update on app start
        Future.delayed(Duration.zero, () {
          if (context.mounted) {
            ref
                .read(layoutStateNotifierProvider.notifier)
                .updateLayout(context);
          }
        });

        // Provide the app with Material 3 support
        return MediaQuery(
          // Override text scaling to prevent layout issues
          data: MediaQuery.of(context).copyWith(
            textScaleFactor: MediaQuery.of(
              context,
            ).textScaleFactor.clamp(0.8, 1.2),
          ),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}
