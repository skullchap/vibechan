import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vibechan/shared/providers/settings_provider.dart';
import 'package:vibechan/core/theme/theme_provider.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:vibechan/core/services/download_service.dart';
import 'package:vibechan/core/di/injection.dart';

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
    final themeState = ref.watch(appThemeProvider);
    final themeNotifier = ref.read(appThemeProvider.notifier);
    final availableSchemes = appColorSchemes;

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Theme Mode',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
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
              ),
            ),
          ),
          const SizedBox(height: 8),
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Color Scheme',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: Center(
                      child: Column(
                        children: [
                          Text(
                            availableSchemes[themeState.selectedSchemeIndex]
                                .name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            width: 200,
                            height: 40,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey.withOpacity(0.5),
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Container(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      child: Center(
                                        child: Text(
                                          'Primary',
                                          style: TextStyle(
                                            color:
                                                Theme.of(
                                                  context,
                                                ).colorScheme.onPrimary,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Container(
                                      color:
                                          Theme.of(
                                            context,
                                          ).colorScheme.secondary,
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
                          ),
                        ],
                      ),
                    ),
                  ),
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
                              isSelected:
                                  index == themeState.selectedSchemeIndex,
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
          ),
          const SizedBox(height: 8),
          _buildDownloadSettingsCard(context),
          const SizedBox(height: 8),
          Card(
            elevation: 2,
            child: ListTile(
              leading: const Icon(Icons.image),
              title: const Text('Media Settings'),
              subtitle: const Text('Image and video preferences'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                // TODO: Implement media settings
              },
            ),
          ),
          const SizedBox(height: 8),
          Card(
            elevation: 2,
            child: settingsState.when(
              data:
                  (settings) => SwitchListTile(
                    secondary: const Icon(Icons.tab_unselected),
                    title: const Text('Switch to existing tab'),
                    subtitle: const Text(
                      'Switch to an existing tab if one is already open when selecting a source.',
                      style: TextStyle(fontSize: 12),
                    ),
                    value: settingsNotifier.switchToExistingTab,
                    onChanged: (value) {
                      settingsNotifier.setSwitchToExistingTab(value);
                    },
                  ),
              loading:
                  () => const ListTile(
                    leading: CircularProgressIndicator(),
                    title: Text('Loading Tab Settings...'),
                  ),
              error:
                  (error, stack) => ListTile(
                    leading: const Icon(Icons.error, color: Colors.red),
                    title: const Text('Error loading settings'),
                    subtitle: Text('$error'),
                  ),
            ),
          ),
          const SizedBox(height: 8),
          Card(
            elevation: 2,
            child: ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('About'),
              subtitle: const Text('App information and licenses'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                // TODO: Implement about page
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDownloadSettingsCard(BuildContext context) {
    final downloadService = getIt<DownloadService>();

    return StatefulBuilder(
      builder: (context, setState) {
        return FutureBuilder<String?>(
          future: downloadService.getDownloadDirectory(),
          builder: (context, snapshot) {
            final String downloadPath = snapshot.data ?? 'Loading...';

            return Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.download),
                        const SizedBox(width: 12),
                        const Text(
                          'Download Settings',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text('Download Directory:'),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.withOpacity(0.5)),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      width: double.infinity,
                      child: Text(
                        downloadPath,
                        style: TextStyle(
                          fontSize: 13,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.folder_open),
                        label: const Text('Change Folder'),
                        onPressed: () async {
                          final String? newPath =
                              await downloadService.selectDownloadDirectory();
                          if (newPath != null) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Download folder set to: $newPath',
                                  ),
                                ),
                              );
                            }
                            setState(() {});
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
