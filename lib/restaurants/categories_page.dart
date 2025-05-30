// import 'package:flutter/material.dart';

// class CategoriesPage extends StatelessWidget {
//   const CategoriesPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Food Categories"),
//         backgroundColor: Colors.blue, // 🔵 Set AppBar color to blue
//       ),
//       body: ListView(
//         padding: const EdgeInsets.all(12),
//         children: const [
//           CategoryTile(icon: Icons.local_cafe, label: "Coffee"),
//           CategoryTile(icon: Icons.local_drink, label: "Drink"),
//           CategoryTile(icon: Icons.fastfood, label: "Fast Food"),
//           CategoryTile(icon: Icons.cake, label: "Cake"),
//         ],
//       ),
//     );
//   }
// }

// // 📌 Category Tile Widget
// class CategoryTile extends StatelessWidget {
//   final IconData icon;
//   final String label;

//   const CategoryTile({super.key, required this.icon, required this.label});

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       child: ListTile(
//         leading: Icon(icon, color: Colors.orangeAccent),
//         title: Text(label),
//         trailing: const Icon(Icons.arrow_forward_ios, size: 16),
//         onTap: () {
//           // Navigate to specific category page
//         },
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  String? selectedCategory;

  // Updated categories to match restaurant_listings.dart
  final List<Map<String, dynamic>> categories = [
    {"name": "Popular", "icon": Icons.star},
    {"name": "Fast Food", "icon": Icons.fastfood},
    {"name": "Italian", "icon": Icons.local_pizza},
    {"name": "Chinese", "icon": Icons.rice_bowl},
    {"name": "Indian", "icon": Icons.restaurant},
    {"name": "Continental", "icon": Icons.dinner_dining},
  ];

  void selectCategory(String category) {
    setState(() {
      selectedCategory = category;
    });
    // Here you would navigate to filtered restaurants
    // or filter the restaurants displayed on this page
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Food Categories"),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "Browse Categories",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          // Horizontal scrolling categories using the same style as restaurant_listings
          Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: _buildCategoriesChips(),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return CategoryTile(
                  icon: category["icon"],
                  label: category["name"],
                  isSelected: selectedCategory == category["name"],
                  onTap: () => selectCategory(category["name"]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Implementing similar functionality to _buildCategoriesList from restaurant_listings.dart
  Widget _buildCategoriesChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children:
            categories
                .map(
                  (category) => Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: InkWell(
                      onTap: () => selectCategory(category["name"]),
                      child: Chip(
                        label: Text(category["name"]),
                        backgroundColor:
                            selectedCategory == category["name"]
                                ? Colors.blue
                                : Colors.blue.shade100,
                        labelStyle: TextStyle(
                          color:
                              selectedCategory == category["name"]
                                  ? Colors.white
                                  : Colors.blue.shade900,
                          fontWeight:
                              selectedCategory == category["name"]
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
      ),
    );
  }
}

// Updated CategoryTile to include selection state
class CategoryTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryTile({
    super.key,
    required this.icon,
    required this.label,
    this.isSelected = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: isSelected ? 3 : 1,
      color: isSelected ? Colors.blue.shade50 : Colors.white,
      margin: const EdgeInsets.only(bottom: 8.0),
      child: ListTile(
        leading: Icon(
          icon,
          color: isSelected ? Colors.blue : Colors.orangeAccent,
        ),
        title: Text(
          label,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}
