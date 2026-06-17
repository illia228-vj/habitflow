import '../models/habit.dart';
import 'database_helper.dart';

class HabitRepository {
  final DatabaseHelper _db = DatabaseHelper();

  Future<List<Habit>> getAllHabits() => _db.getAllHabits();
  Future<Habit?> getHabitById(int id) => _db.getHabitById(id);
  Future<int> insertHabit(Habit habit) => _db.insertHabit(habit);
  Future<int> updateHabit(Habit habit) => _db.updateHabit(habit);
  Future<int> deleteHabit(int id) => _db.deleteHabit(id);
}
