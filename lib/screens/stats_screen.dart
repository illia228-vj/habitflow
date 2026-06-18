import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:habitflow/providers/habit_provider.dart';
import 'package:provider/provider.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HabitProvider>(context);
    final total = provider.totalHabits;
    final completedToday = provider.totalCompletedToday;
    final favorites = provider.favoriteHabits.length;
    final rate = provider.completionRate;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistics'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Кругова діаграма
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sections: [
                    PieChartSectionData(
                      value: completedToday.toDouble(),
                      color: Colors.deepPurple,
                      title: '${(rate * 100).toInt()}%',
                      radius: 60,
                      titleStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    PieChartSectionData(
                      value: (total - completedToday).toDouble(),
                      color: Colors.grey.shade300,
                      radius: 60,
                    ),
                  ],
                  sectionsSpace: 2,
                  centerSpaceRadius: 40,
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Картки статистики
            Row(
              children: [
                _statCard('Total', total, Icons.list, Colors.deepPurple),
                _statCard(
                    'Today', completedToday, Icons.check_circle, Colors.green),
                _statCard('Favorites', favorites, Icons.favorite, Colors.amber),
              ],
            ),
            const SizedBox(height: 24),
            // Додаткова інформація
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildProgressTile(
                        'Completion Rate', rate, Colors.deepPurple),
                    const Divider(),
                    _buildProgressTile(
                        'Favorites', favorites / total, Colors.amber),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statCard(String label, int value, IconData icon, Color color) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Icon(icon, color: color, size: 28),
              const SizedBox(height: 4),
              Text(
                value.toString(),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressTile(String title, double progress, Color color) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(title),
        ),
        Expanded(
          flex: 3,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress.clamp(0.0, 1.0),
              minHeight: 10,
              backgroundColor: Colors.grey.shade300,
              color: color,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '${(progress * 100).toInt()}%',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
