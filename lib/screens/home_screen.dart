import 'package:flutter/material.dart';
import 'package:habitflow/providers/habit_provider.dart';
import 'package:habitflow/screens/add_edit_screen.dart';
import 'package:habitflow/screens/detail_screen.dart';
import 'package:habitflow/widgets/empty_state.dart';
import 'package:habitflow/widgets/filter_chips.dart';
import 'package:habitflow/widgets/habit_card.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HabitProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Habit Tracker'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search habits...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey.withValues(alpha: 0.1),
              ),
              onChanged: provider.setSearchQuery,
            ),
          ),
          if (provider.categories.length > 1)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: FilterChips(
                categories: provider.categories,
                selectedCategory: provider.selectedCategory,
                onCategorySelected: provider.setCategoryFilter,
              ),
            ),
          Expanded(
            child: provider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : provider.habits.isEmpty
                    ? const EmptyState(
                        icon: Icons.emoji_objects_outlined,
                        message: 'No habits yet.\nTap + to create one!',
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: provider.habits.length,
                        itemBuilder: (ctx, index) {
                          final habit = provider.habits[index];
                          return HabitCard(
                            habit: habit,
                            onToggle: () => provider.toggleCompletion(
                                habit.id!, DateTime.now()),
                            onFavorite: () =>
                                provider.toggleFavorite(habit.id!),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => DetailScreen(habit: habit),
                                ),
                              ).then((_) => provider.loadHabits());
                            },
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
