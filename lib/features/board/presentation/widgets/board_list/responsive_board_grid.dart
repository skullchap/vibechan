import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vibechan/core/presentation/widgets/common/empty_state.dart';
import 'package:vibechan/core/presentation/widgets/common/loading_indicator.dart';
import 'package:vibechan/core/presentation/widgets/responsive_widgets.dart';
import 'package:vibechan/core/utils/responsive_layout.dart';

import '../../utils/board_filtering.dart';
import 'board_list_item_builder.dart';

/// A responsive grid view for displaying boards.
class ResponsiveBoardGrid extends StatelessWidget {
  final AsyncValue<List<dynamic>> boards;
  final Function(dynamic) onBoardTap;
  final int columnCount;
  final bool searchActive;
  final String searchQuery;

  const ResponsiveBoardGrid({
    super.key,
    required this.boards,
    required this.onBoardTap,
    required this.columnCount,
    this.searchActive = false,
    this.searchQuery = '',
  });

  @override
  Widget build(BuildContext context) {
    return boards.when(
      data: (boardList) {
        // Filter boards based on search query if search is active
        final filteredBoards = filterBoards(
          boardList,
          searchActive ? searchQuery : '',
        );

        if (filteredBoards.isEmpty) {
          return EmptyState(
            icon: searchActive ? Icons.search_off : Icons.grid_off_rounded,
            title:
                searchActive
                    ? 'No boards match "${searchQuery}"'
                    : 'No boards found',
          );
        }

        return AnimatedLayoutBuilder(
          child: GridView.builder(
            padding: ResponsiveLayout.getPadding(context),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columnCount,
              childAspectRatio: 3 / 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: filteredBoards.length,
            itemBuilder:
                (context, index) => buildBoardListItem(
                  context,
                  filteredBoards[index],
                  onBoardTap,
                  searchActive ? searchQuery : null,
                ),
          ),
        );
      },
      loading: () => const LoadingIndicator(),
      error: (error, stack) => Center(child: Text('Error: $error')),
    );
  }
}
