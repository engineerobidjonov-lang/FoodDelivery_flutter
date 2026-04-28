class Category {
  final String id;
  final String name;
  final String subtitle;
  final String banner;
  final String deliveryEta;

  Category({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.banner,
    required this.deliveryEta,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] ?? json['_id'] ?? '',
      name: json['name'] ?? '',
      subtitle: json['subtitle'] ?? '',
      banner: json['banner'] ?? '',
      deliveryEta: json['deliveryEta'] ?? '',
    );
  }
}
