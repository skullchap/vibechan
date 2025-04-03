import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vibechan/shared/providers/settings_provider.dart';

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
          Card(
            elevation: 2,
            child: ListTile(
              leading: const Icon(Icons.color_lens),
              title: const Text('Theme'),
              subtitle: const Text('Light/Dark/System'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                // TODO: Implement theme settings
              },
            ),
          ),
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
}
