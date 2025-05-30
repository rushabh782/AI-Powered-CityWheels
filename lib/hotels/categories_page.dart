import 'package:flutter/material.dart';

class CategoriesPage extends StatelessWidget {
  final List<String> categories = [
    "Luxury",
    "Budget",
    "Resorts",
    "Vacation",
    "Business",
    "Boutique",
    "Friendly",
  ];

  CategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Categories")),
      body: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(categories[index]),
            onTap: () {}, // Add navigation if needed
          );
        },
      ),
    );
  }
}
