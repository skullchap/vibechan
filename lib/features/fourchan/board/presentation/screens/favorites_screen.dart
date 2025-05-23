import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vibechan/shared/providers/tab_manager_provider.dart';
import 'package:vibechan/app/app_routes.dart'; // Import AppRoute

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // This is a placeholder. In a real implementation, you would fetch favorites from a provider
    final dummyFavorites = [
      {'title': '/a/ - Anime & Manga', 'boardId': 'a'},
      {'title': '/g/ - Technology', 'boardId': 'g'},
      {'title': '/v/ - Video Games', 'boardId': 'v'},
    ];

    // Return content without a Scaffold
    return dummyFavorites.isEmpty
        ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.favorite, size: 64, color: Colors.redAccent),
              SizedBox(height: 16),
              Text(
                'No favorites yet',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Your favorite boards and threads will appear here',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        )
        : ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: dummyFavorites.length,
          itemBuilder: (context, index) {
            final favorite = dummyFavorites[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: const Icon(Icons.web),
                title: Text(favorite['title']!),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.delete_outline),
                      tooltip: 'Remove from favorites',
                      onPressed: () {
                        // TODO: Remove from favorites
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Removed ${favorite['title']} from favorites',
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                onTap: () {
                  // Open favorite board catalog by replacing the active tab
                  final tabNotifier = ref.read(tabManagerProvider.notifier);
                  tabNotifier.navigateToOrReplaceActiveTab(
                    title: favorite['title']!,
                    initialRouteName:
                        AppRoute.boardCatalog.name, // Use enum name
                    pathParameters: {'boardId': favorite['boardId']!},
                    icon: Icons.folder_special, // Example icon for favorite
                  );
                },
              ),
            );
          },
        );
  }
}
