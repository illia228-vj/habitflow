import 'package:flutter/material.dart';
import 'package:habitflow/models/habit.dart';
import 'package:habitflow/providers/habit_provider.dart';
import 'package:habitflow/screens/add_edit_screen.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DetailScreen extends StatelessWidget {
  final Habit habit;
  const DetailScreen({super.key, required this.habit});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(habit.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => AddEditScreen(habit: habit)),
              ).then((_) => context.read<HabitProvider>().loadHabits());
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('Delete Habit'),
                  content: const Text('Are you sure?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Delete'),
                    ),
                  ],
                ),
              );
              if (confirm == true) {
                context.read<HabitProvider>().deleteHabit(habit.id!);
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Chip(label: Text(habit.category)),
            const SizedBox(height: 16),
            Text('Frequency: ${habit.frequency}'),
            const SizedBox(height: 8),
            Text('Created: ${DateFormat.yMMMd().format(habit.createdAt)}'),
            const SizedBox(height: 24),
            const Text('Completion History:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Expanded(
              child: habit.completedDates.isEmpty
                  ? const Center(child: Text('No completions yet.'))
                  : ListView.builder(
                      itemCount: habit.completedDates.length,
                      itemBuilder: (ctx, index) {
                        final date = habit.completedDates[index];
                        return ListTile(
                          leading: const Icon(Icons.check_circle,
                              color: Colors.green),
                          title: Text(DateFormat.yMMMd().format(date)),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
