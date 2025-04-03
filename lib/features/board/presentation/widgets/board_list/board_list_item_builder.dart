import 'package:flutter/material.dart';
import '../board_grid_item.dart';

/// Builds a single board item for the grid, including animations and interactions.
Widget buildBoardListItem(
  BuildContext context,
  dynamic board,
  Function(dynamic) onBoardTap,
  String? highlightQuery,
) {
  return AnimatedScale(
    scale: 1.0,
    duration: const Duration(milliseconds: 300),
    curve: Curves.easeInOut,
    child: AnimatedOpacity(
      opacity: 1.0,
      duration: const Duration(milliseconds: 300),
      child: BoardGridItem(
        board: board,
        onTap: () => onBoardTap(board),
        onLongPress: () {
          // Show context menu with options
          showModalBottomSheet(
            context: context,
            builder:
                (context) => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      leading: const Icon(Icons.favorite_border),
                      title: const Text('Add to favorites'),
                      onTap: () {
                        Navigator.pop(context);
                        // TODO: Add to favorites (use a separate FavoritesProvider)
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Added /${board.id}/ to favorites'),
                          ),
                        );
                      },
                    ),
                  ],
                ),
          );
        },
        highlightQuery: highlightQuery,
      ),
    ),
  );
}
