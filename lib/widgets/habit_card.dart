import 'package:flutter/material.dart';
import 'package:habitflow/models/habit.dart';

class HabitCard extends StatelessWidget {
  final Habit habit;
  final VoidCallback onToggle;
  final VoidCallback onFavorite;
  final VoidCallback onTap;

  const HabitCard({
    super.key,
    required this.habit,
    required this.onToggle,
    required this.onFavorite,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final isCompleted = habit.completedDates.any((d) =>
        d.year == today.year && d.month == today.month && d.day == today.day);
    final streak = habit.streak;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      transform: Matrix4.identity()..scale(isCompleted ? 1.02 : 1.0),
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 6),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                // Анімований чекбокс
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  child: Checkbox(
                    value: isCompleted,
                    onChanged: (_) => onToggle(),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    activeColor: Colors.deepPurple,
                    checkColor: Colors.white,
                  ),
                ),
                const SizedBox(width: 8),
                // Основний вміст
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        habit.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          // Вогонь + серія
                          if (streak > 0) ...[
                            const Icon(Icons.local_fire_department,
                                size: 16, color: Colors.orange),
                            const SizedBox(width: 2),
                            Text(
                              '$streak days',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Colors.orange,
                              ),
                            ),
                            const SizedBox(width: 8),
                          ],
                          // Категорія
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.deepPurple.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              habit.category,
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.deepPurple.shade700,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            habit.frequency,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Зірочка (обране)
                IconButton(
                  icon: Icon(
                    habit.isFavorite ? Icons.star : Icons.star_border,
                    color: habit.isFavorite ? Colors.amber : Colors.grey,
                  ),
                  onPressed: onFavorite,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
