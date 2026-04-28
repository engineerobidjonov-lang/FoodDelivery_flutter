import 'package:flutter/material.dart';
import '../models/category.dart';
import '../models/food.dart';
import '../services/api_service.dart';
import 'home_screen.dart';

class CategoryScreen extends StatelessWidget {
  final Category category;

  const CategoryScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(category.name)),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: FutureBuilder<List<Food>>(
            future: ApiService.fetchFoods(),
            builder: (ctx, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              final foods = snapshot.data!
                  .where((food) => food.category.toLowerCase() == category.name.toLowerCase())
                  .toList();
          
              return LayoutBuilder(
                builder: (context, constraints) {
                  int crossAxisCount = constraints.maxWidth > 900 
                      ? 4 
                      : (constraints.maxWidth > 600 ? 3 : 2);
                      
                  return GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      childAspectRatio: 0.75,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: foods.length,
                    itemBuilder: (ctx, i) => FoodCard(food: foods[i]),
                  );
                }
              );
            },
          ),
        ),
      ),
    );
  }
}
