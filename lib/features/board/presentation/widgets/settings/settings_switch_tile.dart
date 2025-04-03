import 'package:flutter/material.dart';

/// A reusable SwitchListTile for toggle settings.
class SettingsSwitchTile extends StatelessWidget {
  final IconData? leadingIcon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const SettingsSwitchTile({
    super.key,
    this.leadingIcon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: SwitchListTile(
        secondary: leadingIcon != null ? Icon(leadingIcon) : null,
        title: Text(title),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
        value: value,
        onChanged: onChanged,
      ),
    );
  }
}
