import 'package:flutter/material.dart';
import 'package:habitflow/main.dart';
import 'package:habitflow/providers/habit_provider.dart';
import 'package:habitflow/screens/detail_screen.dart';
import 'package:habitflow/widgets/empty_state.dart';
import 'package:habitflow/widgets/filter_chips.dart';
import 'package:habitflow/widgets/habit_card.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HabitProvider>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('HabitFlow'),
        actions: [
          IconButton(
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.setBool('darkMode', !isDark);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => MyApp(isDark: !isDark)),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Прогрес-бар
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Today\'s Progress',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    Text(
                      '${provider.totalCompletedToday}/${provider.totalHabits}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: LinearProgressIndicator(
                    value: provider.completionRate,
                    minHeight: 12,
                    backgroundColor: Colors.grey.shade300,
                    color: Colors.deepPurple,
                  ),
                ),
                if (provider.totalHabits > 0)
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      '${(provider.completionRate * 100).toInt()}% completed',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          // Пошук
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search habits...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Theme.of(context).inputDecorationTheme.fillColor,
              ),
              onChanged: provider.setSearchQuery,
            ),
          ),
          // Фільтри
          if (provider.categories.length > 1)
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: FilterChips(
                categories: provider.categories,
                selectedCategory: provider.selectedCategory,
                onCategorySelected: provider.setCategoryFilter,
              ),
            ),
          // Список
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
