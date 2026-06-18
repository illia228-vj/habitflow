import 'package:flutter/material.dart';

import '../database/habit_repository.dart';
import '../models/habit.dart';

class HabitProvider extends ChangeNotifier {
  final HabitRepository _repository = HabitRepository();

  List<Habit> _allHabits = [];
  List<Habit> _filteredHabits = [];
  String _searchQuery = '';
  String _selectedCategory = 'All';
  bool _isLoading = false;

  List<Habit> get habits => _filteredHabits;
  bool get isLoading => _isLoading;
  String get selectedCategory => _selectedCategory;

  // Статистика
  int get totalHabits => _allHabits.length;
  int get totalCompletedToday {
    final now = DateTime.now();
    return _allHabits
        .where((h) => h.completedDates.any((d) =>
            d.year == now.year && d.month == now.month && d.day == now.day))
        .length;
  }

  double get completionRate {
    if (totalHabits == 0) return 0;
    return totalCompletedToday / totalHabits;
  }

  List<Habit> get favoriteHabits =>
      _allHabits.where((h) => h.isFavorite).toList();

  List<String> get categories {
    final Set<String> set = {};
    for (var h in _allHabits) set.add(h.category);
    return ['All', ...set.toList()];
  }

  Future<void> loadHabits() async {
    _isLoading = true;
    notifyListeners();
    try {
      _allHabits = await _repository.getAllHabits();
      _applyFilters();
    } catch (e) {
      debugPrint('Error loading habits: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    _applyFilters();
    notifyListeners();
  }

  void setCategoryFilter(String category) {
    _selectedCategory = category;
    _applyFilters();
    notifyListeners();
  }

  void _applyFilters() {
    _filteredHabits = _allHabits.where((habit) {
      bool matchesSearch =
          habit.name.toLowerCase().contains(_searchQuery.toLowerCase());
      bool matchesCategory =
          _selectedCategory == 'All' || habit.category == _selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();
    _filteredHabits.sort((a, b) {
      if (a.isFavorite && !b.isFavorite) return -1;
      if (!a.isFavorite && b.isFavorite) return 1;
      return b.createdAt.compareTo(a.createdAt);
    });
  }

  Future<void> addHabit(Habit habit) async {
    final id = await _repository.insertHabit(habit);
    final newHabit = habit.copyWith(id: id);
    _allHabits.add(newHabit);
    _applyFilters();
    notifyListeners();
  }

  Future<void> updateHabit(Habit habit) async {
    await _repository.updateHabit(habit);
    final index = _allHabits.indexWhere((h) => h.id == habit.id);
    if (index != -1) _allHabits[index] = habit;
    _applyFilters();
    notifyListeners();
  }

  Future<void> deleteHabit(int id) async {
    await _repository.deleteHabit(id);
    _allHabits.removeWhere((h) => h.id == id);
    _applyFilters();
    notifyListeners();
  }

  Future<void> toggleFavorite(int id) async {
    final habit = _allHabits.firstWhere((h) => h.id == id);
    final updated = habit.copyWith(isFavorite: !habit.isFavorite);
    await updateHabit(updated);
  }

  Future<void> toggleCompletion(int id, DateTime date) async {
    final habit = _allHabits.firstWhere((h) => h.id == id);
    final dateOnly = DateTime(date.year, date.month, date.day);
    List<DateTime> completed = List.from(habit.completedDates);

    bool exists = completed.any((d) =>
        d.year == dateOnly.year &&
        d.month == dateOnly.month &&
        d.day == dateOnly.day);

    if (exists) {
      completed.removeWhere((d) =>
          d.year == dateOnly.year &&
          d.month == dateOnly.month &&
          d.day == dateOnly.day);
    } else {
      completed.add(dateOnly);
    }
    final updated = habit.copyWith(completedDates: completed);
    await updateHabit(updated);
  }
}
