import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vibechan/core/theme/theme_provider.dart';

/// Widget for selecting the app's theme mode.
class ThemeModeSelector extends ConsumerWidget {
  const ThemeModeSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeState = ref.watch(appThemeProvider);
    final themeNotifier = ref.read(appThemeProvider.notifier);

    return Column(
      children: [
        RadioListTile<ThemeMode>(
          title: const Text('System'),
          value: ThemeMode.system,
          groupValue: themeState.themeMode,
          onChanged: (value) => themeNotifier.setThemeMode(value!),
          contentPadding: EdgeInsets.zero,
        ),
        RadioListTile<ThemeMode>(
          title: const Text('Light'),
          value: ThemeMode.light,
          groupValue: themeState.themeMode,
          onChanged: (value) => themeNotifier.setThemeMode(value!),
          contentPadding: EdgeInsets.zero,
        ),
        RadioListTile<ThemeMode>(
          title: const Text('Dark'),
          value: ThemeMode.dark,
          groupValue: themeState.themeMode,
          onChanged: (value) => themeNotifier.setThemeMode(value!),
          contentPadding: EdgeInsets.zero,
        ),
      ],
    );
  }
}
