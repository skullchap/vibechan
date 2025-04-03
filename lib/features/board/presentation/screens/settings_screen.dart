import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vibechan/shared/providers/settings_provider.dart';
import 'package:vibechan/core/theme/theme_provider.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';

import '../widgets/settings/color_scheme_selector.dart';
import '../widgets/settings/settings_navigation_tile.dart';
import '../widgets/settings/settings_section_card.dart';
import '../widgets/settings/settings_switch_tile.dart';
import '../widgets/settings/theme_mode_selector.dart';

class ColorSchemePreview extends StatelessWidget {
  final AppSchemeInfo scheme;
  final bool isSelected;

  const ColorSchemePreview({
    super.key,
    required this.scheme,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final themeData =
        isDark
            ? FlexThemeData.dark(scheme: scheme.scheme)
            : FlexThemeData.light(scheme: scheme.scheme);

    final primaryColor = themeData.colorScheme.primary;
    final secondaryColor = themeData.colorScheme.secondary;

    return Row(
      children: [
        Container(
          margin: const EdgeInsets.only(right: 10),
          width: 48,
          height: 24,
          decoration: BoxDecoration(
            border: Border.all(
              color:
                  isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Colors.grey.withOpacity(0.3),
              width: isSelected ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            children: [
              Expanded(child: Container(color: primaryColor)),
              Expanded(child: Container(color: secondaryColor)),
            ],
          ),
        ),
        Expanded(child: Text(scheme.name)),
      ],
    );
  }
}

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsState = ref.watch(appSettingsProvider);
    final settingsNotifier = ref.read(appSettingsProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Theme Mode Section
          const SettingsSectionCard(
            title: 'Theme Mode',
            children: [ThemeModeSelector()],
          ),
          const SizedBox(height: 8),

          // Color Scheme Section
          const SettingsSectionCard(
            title: 'Color Scheme',
            children: [ColorSchemeSelector()],
          ),
          const SizedBox(height: 8),

          // Media Settings Navigation
          SettingsNavigationTile(
            leadingIcon: Icons.image,
            title: 'Media Settings',
            subtitle: 'Image and video preferences',
            onTap: () {
              // TODO: Implement media settings navigation
            },
          ),
          const SizedBox(height: 8),

          // Tab Settings Switch
          settingsState.when(
            data:
                (settings) => SettingsSwitchTile(
                  leadingIcon: Icons.tab_unselected,
                  title: 'Switch to existing tab',
                  subtitle:
                      'Switch to an existing tab if one is already open when selecting a source.',
                  value: settingsNotifier.switchToExistingTab,
                  onChanged: (value) {
                    settingsNotifier.setSwitchToExistingTab(value);
                  },
                ),
            loading:
                () => const Card(
                  elevation: 2,
                  child: ListTile(
                    leading: CircularProgressIndicator(),
                    title: Text('Loading Tab Settings...'),
                  ),
                ),
            error:
                (error, stack) => Card(
                  elevation: 2,
                  child: ListTile(
                    leading: const Icon(Icons.error, color: Colors.red),
                    title: const Text('Error loading settings'),
                    subtitle: Text('$error'),
                  ),
                ),
          ),
          const SizedBox(height: 8),

          // About Navigation
          SettingsNavigationTile(
            leadingIcon: Icons.info_outline,
            title: 'About',
            subtitle: 'App information and licenses',
            onTap: () {
              // TODO: Implement about page navigation
            },
          ),
        ],
      ),
    );
  }
}
