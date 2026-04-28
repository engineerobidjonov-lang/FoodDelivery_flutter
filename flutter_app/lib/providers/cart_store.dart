import 'package:flutter/material.dart';
import '../models/food.dart';

class CartItem {
  final Food food;
  int quantity;

  CartItem({required this.food, this.quantity = 1});
}

class CartStore with ChangeNotifier {
  final Map<String, CartItem> _items = {};

  Map<String, CartItem> get items => {..._items};

  int get itemCount => _items.values.fold(0, (sum, item) => sum + item.quantity);

  double get totalAmount => _items.values.fold(
      0.0, (sum, item) => sum + (item.food.price * item.quantity));

  void addToCart(Food food) {
    if (_items.containsKey(food.id)) {
      _items[food.id]!.quantity += 1;
    } else {
      _items[food.id] = CartItem(food: food);
    }
    notifyListeners();
  }

  void updateQuantity(String foodId, int quantity) {
    if (!_items.containsKey(foodId)) return;

    if (quantity <= 0) {
      _items.remove(foodId);
    } else {
      _items[foodId]!.quantity = quantity;
    }
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}
