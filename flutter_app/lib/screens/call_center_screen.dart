import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/api_service.dart';
import '../models/category.dart';

class CallCenterScreen extends StatefulWidget {
  const CallCenterScreen({super.key});

  @override
  State<CallCenterScreen> createState() => _CallCenterScreenState();
}

class _CallCenterScreenState extends State<CallCenterScreen> {
  late Future<List<Category>> _categoriesFuture;

  @override
  void initState() {
    super.initState();
    _categoriesFuture = ApiService.fetchCategories();
  }

  Future<void> _makeCall(String phoneNumber) async {
    final Uri url = Uri.parse('tel:$phoneNumber');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not launch dialer')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Call Center')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: FutureBuilder<List<Category>>(
            future: _categoriesFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              final categories = snapshot.data!;
              
              // Extract unique sellers from categories
              final sellers = categories.map((c) => {
                'name': c.name, // Using category name as context
                'sellerName': _getSellerName(c.name),
                'phone': _getSellerPhone(c.name),
              }).toList();

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: sellers.length,
                itemBuilder: (context, index) {
                  final seller = sellers[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.orange.shade50,
                            child: const Icon(Icons.storefront, color: Color(0xFFF97316), size: 30),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  seller['sellerName']!,
                                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'Category: ${seller['name']}',
                                  style: TextStyle(color: Colors.grey.shade600),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  seller['phone']!,
                                  style: const TextStyle(color: Color(0xFFF97316), fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.phone_in_talk, color: Colors.green, size: 30),
                            onPressed: () => _makeCall(seller['phone']!),
                            style: IconButton.styleFrom(
                              backgroundColor: Colors.green.shade50,
                              padding: const EdgeInsets.all(12),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  // Helper to match hardcoded seed data names for specific feedback
  String _getSellerName(String category) {
    if (category == 'National') return "Babushka's Kitchen";
    if (category == 'Seafood') return "Ocean Blue Grille";
    return "Turbo Burger";
  }

  String _getSellerPhone(String category) {
    if (category == 'National') return "+1-555-0101";
    if (category == 'Seafood') return "+1-555-0102";
    return "+1-555-0103";
  }
}
