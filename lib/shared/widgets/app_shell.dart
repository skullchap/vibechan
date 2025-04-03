import 'package:flutter/material.dart';

import 'app_shell/app_shell.dart';

/// This is a wrapper to maintain backward compatibility
/// The implementation has been moved to app_shell/app_shell.dart
/// to better organize the codebase with smaller, more focused files.
class AppShell extends StatelessWidget {
  const AppShell({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppShellImpl();
  }
}
