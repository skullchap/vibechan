import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vibechan/core/theme/theme_provider.dart';

/// Widget for selecting the app's color scheme.
class ColorSchemeSelector extends ConsumerWidget {
  const ColorSchemeSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeState = ref.watch(appThemeProvider);
    final themeNotifier = ref.read(appThemeProvider.notifier);
    final availableSchemes = appColorSchemes;

    return Column(
      children: [
        // Current Scheme Preview
        Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: Center(
            child: Column(
              children: [
                Text(
                  availableSchemes[themeState.selectedSchemeIndex].name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                Container(
                  width: 200,
                  height: 40,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.withOpacity(0.5)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Row(
                      children: [
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
                        Expanded(
                          flex: 2,
                          child: Container(
                            color: Theme.of(context).colorScheme.secondary,
                            child: Center(
                              child: Text(
                                'Secondary',
                                style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.onSecondary,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Dropdown for selecting scheme
        DropdownButtonFormField<int>(
          value: themeState.selectedSchemeIndex,
          isExpanded: true,
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            border: OutlineInputBorder(),
          ),
          items:
              availableSchemes.asMap().entries.map((entry) {
                final index = entry.key;
                final scheme = entry.value;
                return DropdownMenuItem<int>(
                  value: index,
                  child: _ColorSchemePreview(
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
    );
  }
}

/// Preview widget used in the ColorSchemeSelector dropdown.
class _ColorSchemePreview extends StatelessWidget {
  final AppSchemeInfo scheme;
  final bool isSelected;

  const _ColorSchemePreview({required this.scheme, this.isSelected = false});

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
