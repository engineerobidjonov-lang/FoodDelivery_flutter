class Food {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final double price;
  final String category;
  final int prepTimeMinutes;

  Food({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.price,
    required this.category,
    required this.prepTimeMinutes,
  });

  factory Food.fromJson(Map<String, dynamic> json) {
    return Food(
      id: json['id'] ?? json['_id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      category: json['category'] ?? '',
      prepTimeMinutes: json['prepTimeMinutes'] ?? 0,
    );
  }
}
