class Product {
  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.colors,
    required this.sizes,
    this.category = '',
  });

  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final List<int> colors;
  final List<String> sizes;
  final String category;
}
