import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_store.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartStore>(context);
    final items = cart.items.values.toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Your Cart')),
      body: items.isEmpty
          ? const Center(child: Text('Your cart is empty'))
          : Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    if (constraints.maxWidth > 800) {
                      // Desktop/Web side-by-side layout
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(flex: 2, child: _buildCartList(items, cart)),
                          Expanded(flex: 1, child: _buildSummary(context, cart)),
                        ],
                      );
                    } else {
                      // Mobile stacked layout
                      return Column(
                        children: [
                          Expanded(child: _buildCartList(items, cart)),
                          _buildSummary(context, cart),
                        ],
                      );
                    }
                  }
                ),
              ),
            ),
    );
  }

  Widget _buildCartList(List<CartItem> items, CartStore cart) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      itemBuilder: (ctx, i) => Card(
        margin: const EdgeInsets.only(bottom: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(items[i].food.imageUrl, width: 60, height: 60, fit: BoxFit.cover),
            ),
            title: Text(items[i].food.name, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('\$${items[i].food.price} x ${items[i].quantity}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove_circle_outline),
                  onPressed: () => cart.updateQuantity(items[i].food.id, items[i].quantity - 1),
                ),
                Text('${items[i].quantity}', style: const TextStyle(fontWeight: FontWeight.bold)),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  onPressed: () => cart.updateQuantity(items[i].food.id, items[i].quantity + 1),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSummary(BuildContext context, CartStore cart) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: const BoxDecoration(
        color: Color(0xFF1F2937),
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total', style: TextStyle(color: Colors.white, fontSize: 18)),
              Text('\$${cart.totalAmount.toStringAsFixed(2)}',
                  style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              cart.clear();
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Order placed!')));
              Navigator.pushReplacementNamed(context, '/location');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF97316),
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 56),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            child: const Text('Checkout', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
