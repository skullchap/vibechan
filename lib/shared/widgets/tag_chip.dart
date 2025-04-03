import 'package:flutter/material.dart';

/// A simple chip widget to display a tag.
class TagChip extends StatelessWidget {
  final String tag;

  const TagChip({super.key, required this.tag});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Chip(
      label: Text(tag),
      labelStyle: theme.textTheme.labelSmall,
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 0),
      backgroundColor: colorScheme.secondaryContainer.withOpacity(0.5),
      side: BorderSide.none,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      visualDensity: VisualDensity.compact,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
}
