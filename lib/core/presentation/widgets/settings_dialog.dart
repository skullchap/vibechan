import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vibechan/core/theme/theme_provider.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';

/// Widget that displays a small preview of a color scheme's primary and secondary colors
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
    // Get the scheme's colors for the current brightness
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Use FlexThemeData to get the correct scheme colors
    final themeData =
        isDark
            ? FlexThemeData.dark(scheme: scheme.scheme)
            : FlexThemeData.light(scheme: scheme.scheme);

    // Extract the primary and secondary colors
    final primaryColor = themeData.colorScheme.primary;
    final secondaryColor = themeData.colorScheme.secondary;

    return Row(
      children: [
        // Color preview
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
              // Primary color
              Expanded(child: Container(color: primaryColor)),
              // Secondary color
              Expanded(child: Container(color: secondaryColor)),
            ],
          ),
        ),
        // Scheme name
        Expanded(child: Text(scheme.name)),
      ],
    );
  }
}

class SettingsDialog extends ConsumerWidget {
  const SettingsDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeState = ref.watch(appThemeProvider);
    final themeNotifier = ref.read(appThemeProvider.notifier);
    final availableSchemes =
        appColorSchemes; // Get the list from the provider file

    return AlertDialog(
      title: const Text('Settings'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Theme Mode Selector
            const Text(
              'Theme Mode',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            RadioListTile<ThemeMode>(
              title: const Text('System'),
              value: ThemeMode.system,
              groupValue: themeState.themeMode,
              onChanged: (value) => themeNotifier.setThemeMode(value!),
            ),
            RadioListTile<ThemeMode>(
              title: const Text('Light'),
              value: ThemeMode.light,
              groupValue: themeState.themeMode,
              onChanged: (value) => themeNotifier.setThemeMode(value!),
            ),
            RadioListTile<ThemeMode>(
              title: const Text('Dark'),
              value: ThemeMode.dark,
              groupValue: themeState.themeMode,
              onChanged: (value) => themeNotifier.setThemeMode(value!),
            ),
            const Divider(),

            // Color Scheme Selector with enhanced UI
            const Text(
              'Color Scheme',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            // Current scheme preview (larger)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Center(
                child: Column(
                  children: [
                    Text(
                      availableSchemes[themeState.selectedSchemeIndex].name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      width: 200,
                      height: 40,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.withOpacity(0.3)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          // Primary color
                          Expanded(
                            flex: 2,
                            child: Container(
                              color: Theme.of(context).colorScheme.primary,
                              child: Center(
                                child: Text(
                                  'Primary',
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          // Secondary color
                          Expanded(
                            flex: 2,
                            child: Container(
                              color: Theme.of(context).colorScheme.secondary,
                              child: Center(
                                child: Text(
                                  'Secondary',
                                  style: TextStyle(
                                    color:
                                        Theme.of(
                                          context,
                                        ).colorScheme.onSecondary,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),

            // Dropdown with color previews
            DropdownButtonFormField<int>(
              value: themeState.selectedSchemeIndex,
              isExpanded: true,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                border: OutlineInputBorder(),
              ),
              items:
                  availableSchemes.asMap().entries.map((entry) {
                    final index = entry.key;
                    final scheme = entry.value;
                    return DropdownMenuItem<int>(
                      value: index,
                      child: ColorSchemePreview(
                        scheme: scheme,
                        isSelected: index == themeState.selectedSchemeIndex,
                      ),
                    );
                  }).toList(),
              onChanged: (value) {
                if (value != null) {
                  themeNotifier.setSchemeIndex(value);
                }
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
    );
  }
}
