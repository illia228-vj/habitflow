import 'package:flutter/material.dart';

class FilterChips extends StatelessWidget {
  final List<String> categories;
  final String selectedCategory;
  final Function(String) onCategorySelected;

  const FilterChips({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.0,
      children: categories.map((category) {
        return ChoiceChip(
          label: Text(category),
          selected: selectedCategory == category,
          onSelected: (selected) {
            if (selected) onCategorySelected(category);
          },
          selectedColor: Theme.of(context).primaryColor,
          labelStyle: TextStyle(
            color: selectedCategory == category ? Colors.white : null,
          ),
        );
      }).toList(),
    );
  }
}
