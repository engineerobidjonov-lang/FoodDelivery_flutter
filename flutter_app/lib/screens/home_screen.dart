import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// ignore: unused_import
import 'package:url_launcher/url_launcher.dart';
import '../services/api_service.dart';
import '../models/food.dart';
import '../models/category.dart';
import '../providers/cart_store.dart';
import '../providers/auth_store.dart';
import 'category_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Category>> _categoriesFuture;
  late Future<List<Food>> _foodsFuture;

  @override
  void initState() {
    super.initState();
    _categoriesFuture = ApiService.fetchCategories();
    _foodsFuture = ApiService.fetchFoods();
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthStore>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('FoodDash'),
        actions: [
          IconButton(
            icon: const Icon(Icons.phone_in_talk_outlined),
            onPressed: () => Navigator.pushNamed(context, '/call-center'),
          ),
          IconButton(
            icon: const Icon(Icons.location_on_outlined),
            onPressed: () => Navigator.pushNamed(context, '/location'),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => auth.logout(),
          ),
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () => Navigator.pushNamed(context, '/cart'),
              ),
              Positioned(
                right: 8,
                top: 8,
                child: Consumer<CartStore>(
                  builder: (ctx, cart, _) => CircleAvatar(
                    radius: 8,
                    backgroundColor: Colors.red,
                    child: Text(
                      '${cart.itemCount}',
                      style: const TextStyle(fontSize: 10, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Welcome, ${auth.userName}!',
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                // Hero Section
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFF97316), Color(0xFFFBBF24)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(32),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Discover bold flavors and order in minutes.',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                // Categories
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Categories',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 16),
                FutureBuilder<List<Category>>(
                  future: _categoriesFuture,
                  builder: (ctx, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }
                    final categories = snapshot.data!;
                    return SizedBox(
                      height: 140,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: categories.length,
                        itemBuilder: (ctx, i) => GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (ctx) => CategoryScreen(category: categories[i]),
                            ),
                          ),
                          child: Container(
                            width: 120,
                            margin: const EdgeInsets.only(right: 16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(color: Colors.orange.shade100),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.03),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                )
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.restaurant_menu, color: Color(0xFFF97316)),
                                const SizedBox(height: 8),
                                Text(
                                  categories[i].name,
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 32),
                // Featured Foods
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Featured Foods',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 16),
                FutureBuilder<List<Food>>(
                  future: _foodsFuture,
                  builder: (ctx, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final foods = snapshot.data!;
                    return LayoutBuilder(
                      builder: (context, constraints) {
                        int crossAxisCount = constraints.maxWidth > 900 
                            ? 4 
                            : (constraints.maxWidth > 600 ? 3 : 2);
                        
                        return GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
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
                const SizedBox(height: 48),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class FoodCard extends StatelessWidget {
  final Food food;
  const FoodCard({super.key, required this.food});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartStore>(context, listen: false);
    
    // Optimize Unsplash image resolution for emulator performance
    String optimizedImageUrl = food.imageUrl;
    if (optimizedImageUrl.contains('unsplash.com')) {
      optimizedImageUrl = optimizedImageUrl.replaceAll(RegExp(r'w=\d+'), 'w=400');
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              child: Image.network(
                optimizedImageUrl,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  // This will show in your flutter run terminal
                  debugPrint('IMAGE LOAD ERROR for ${food.name}: $error');
                  return Container(
                    width: double.infinity,
                    color: const Color(0xFFFDE68A),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.restaurant, color: Color(0xFFD97706), size: 32),
                        const SizedBox(height: 8),
                        Text(
                          food.name,
                          style: const TextStyle(color: Color(0xFFD97706), fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  food.name,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '\$${food.price}',
                  style: const TextStyle(
                    color: Color(0xFFF97316),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () => cart.addToCart(food),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1F2937),
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 44),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Add to Cart'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
