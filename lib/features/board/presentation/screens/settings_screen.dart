import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
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