import 'package:flutter/material.dart';
import 'package:habitflow/models/habit.dart';
import 'package:habitflow/providers/habit_provider.dart';
import 'package:provider/provider.dart';

class AddEditScreen extends StatefulWidget {
  final Habit? habit;
  const AddEditScreen({super.key, this.habit});

  @override
  State<AddEditScreen> createState() => _AddEditScreenState();
}

class _AddEditScreenState extends State<AddEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _categoryController;
  late TextEditingController _descriptionController;
  late String _frequency;
  late bool _isFavorite;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.habit?.name ?? '');
    _categoryController =
        TextEditingController(text: widget.habit?.category ?? '');
    _descriptionController =
        TextEditingController(text: widget.habit?.description ?? '');
    _frequency = widget.habit?.frequency ?? 'daily';
    _isFavorite = widget.habit?.isFavorite ?? false;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _categoryController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      final habit = Habit(
        id: widget.habit?.id,
        name: _nameController.text.trim(),
        category: _categoryController.text.trim(),
        description: _descriptionController.text.trim(),
        frequency: _frequency,
        isFavorite: _isFavorite,
        createdAt: widget.habit?.createdAt ?? DateTime.now(),
        completedDates: widget.habit?.completedDates ?? [],
      );
      final provider = context.read<HabitProvider>();
      if (widget.habit == null) {
        provider.addHabit(habit);
      } else {
        provider.updateHabit(habit);
      }
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.habit == null ? 'Add Habit' : 'Edit Habit'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name *'),
                validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _categoryController,
                decoration: const InputDecoration(labelText: 'Category *'),
                validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _frequency,
                items: const [
                  DropdownMenuItem(value: 'daily', child: Text('Daily')),
                  DropdownMenuItem(value: 'weekly', child: Text('Weekly')),
                ],
                onChanged: (v) => setState(() => _frequency = v!),
                decoration: const InputDecoration(labelText: 'Frequency'),
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text('Favorite'),
                value: _isFavorite,
                onChanged: (v) => setState(() => _isFavorite = v),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _save,
                  child: Text(widget.habit == null ? 'Create' : 'Update'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
