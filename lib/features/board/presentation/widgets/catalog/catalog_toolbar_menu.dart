import 'package:flutter/material.dart';
import 'catalog_view_mode.dart';

class CatalogToolbarMenu extends StatelessWidget {
  final CatalogViewMode selected;
  final ValueChanged<CatalogViewMode> onSelected;

  const CatalogToolbarMenu({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<CatalogViewMode>(
      icon: const Icon(Icons.more_vert),
      onSelected: onSelected,
      itemBuilder:
          (context) => [
            const PopupMenuItem(
              value: CatalogViewMode.grid,
              child: Text('Grid View'),
            ),
            const PopupMenuItem(
              value: CatalogViewMode.mediaFeed,
              child: Text('Media Feed'),
            ),
          ],
    );
  }
}
