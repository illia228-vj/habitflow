import 'package:flutter/material.dart';
import 'package:habitflow/providers/habit_provider.dart';
import 'package:provider/provider.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HabitProvider>(context);
    final total = provider.habits.length;
    final favorites = provider.favoriteHabits.length;

    final today = DateTime.now();
    int completedToday = 0;
    for (var habit in provider.habits) {
      if (habit.completedDates.any((d) =>
          d.year == today.year &&
          d.month == today.month &&
          d.day == today.day)) {
        completedToday++;
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Statistics')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            _buildStatCard('Total Habits', total, Icons.list),
            _buildStatCard('Favorites', favorites, Icons.favorite),
            _buildStatCard(
                'Completed Today', completedToday, Icons.check_circle),
            const SizedBox(height: 24),
            const Text('Keep building your habits!',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300)),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, int value, IconData icon) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(icon, size: 40),
        title: Text(value.toString(),
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
        subtitle: Text(label),
      ),
    );
  }
}
