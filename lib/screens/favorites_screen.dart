import 'package:flutter/material.dart';
import 'package:habitflow/providers/habit_provider.dart';
import 'package:habitflow/screens/detail_screen.dart';
import 'package:habitflow/widgets/empty_state.dart';
import 'package:habitflow/widgets/habit_card.dart';
import 'package:provider/provider.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HabitProvider>(context);
    final favorites = provider.favoriteHabits;

    return Scaffold(
      appBar: AppBar(title: const Text('Favorites')),
      body: favorites.isEmpty
          ? const EmptyState(
              icon: Icons.favorite_border,
              message: 'No favorites yet.\nMark a habit with a star!',
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: favorites.length,
              itemBuilder: (ctx, index) {
                final habit = favorites[index];
                return HabitCard(
                  habit: habit,
                  onToggle: () =>
                      provider.toggleCompletion(habit.id!, DateTime.now()),
                  onFavorite: () => provider.toggleFavorite(habit.id!),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => DetailScreen(habit: habit)),
                    ).then((_) => provider.loadHabits());
                  },
                );
              },
            ),
    );
  }
}
