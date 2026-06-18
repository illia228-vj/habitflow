class Habit {
  final int? id;
  final String name;
  final String category;
  final String description;
  final String frequency; // 'daily' або 'weekly'
  final bool isFavorite;
  final DateTime createdAt;
  final List<DateTime> completedDates;

  Habit({
    this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.frequency,
    this.isFavorite = false,
    required this.createdAt,
    this.completedDates = const [],
  });

  // Обчислює кількість днів поспіль (стрік)
  int get streak {
    if (completedDates.isEmpty) return 0;
    final sorted = List<DateTime>.from(completedDates)
      ..sort((a, b) => b.compareTo(a));
    int count = 1;
    DateTime current = sorted.first;
    for (int i = 1; i < sorted.length; i++) {
      final diff = current.difference(sorted[i]).inDays;
      if (diff == 1) {
        count++;
        current = sorted[i];
      } else if (diff > 1) {
        break;
      }
    }
    return count;
  }

  Habit copyWith({
    int? id,
    String? name,
    String? category,
    String? description,
    String? frequency,
    bool? isFavorite,
    DateTime? createdAt,
    List<DateTime>? completedDates,
  }) {
    return Habit(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      description: description ?? this.description,
      frequency: frequency ?? this.frequency,
      isFavorite: isFavorite ?? this.isFavorite,
      createdAt: createdAt ?? this.createdAt,
      completedDates: completedDates ?? this.completedDates,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'description': description,
      'frequency': frequency,
      'isFavorite': isFavorite ? 1 : 0,
      'createdAt': createdAt.toIso8601String(),
      'completedDates': completedDates.map((e) => e.toIso8601String()).toList(),
    };
  }

  factory Habit.fromMap(Map<String, dynamic> map) {
    return Habit(
      id: map['id'],
      name: map['name'],
      category: map['category'],
      description: map['description'] ?? '',
      frequency: map['frequency'],
      isFavorite: map['isFavorite'] == 1,
      createdAt: DateTime.parse(map['createdAt']),
      completedDates: (map['completedDates'] as List<dynamic>?)
              ?.map((e) => DateTime.parse(e as String))
              .toList() ??
          [],
    );
  }
}
