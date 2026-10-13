import '../../domain/entities/product.dart';

class ProductModel extends Product {
  const ProductModel({
    required super.id,
    required super.name,
    required super.description,
    required super.price,
    required super.imageUrl,
    required super.colors,
    required super.sizes,
    super.category = '',
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    final rawImages = json['images'];
    final images = rawImages is List
        ? rawImages.map((image) => image.toString()).toList()
        : <String>[];
    final imageUrl = images.firstWhere(
      (image) => image.startsWith('http://') || image.startsWith('https://'),
      orElse: () => 'https://placehold.co/600x600?text=No+Image',
    );

    final rawCategory = json['category'];
    final category = rawCategory is Map
        ? rawCategory['name']?.toString() ?? ''
        : '';
    final rawPrice = json['price'];
    final price = rawPrice is num
        ? rawPrice.toDouble()
        : double.tryParse(rawPrice?.toString() ?? '') ?? 0;

    return ProductModel(
      id: json['id']?.toString() ?? '',
      name: json['title']?.toString() ?? 'Unnamed product',
      description: json['description']?.toString() ?? '',
      price: price,
      imageUrl: imageUrl,
      colors: const [0xFF000000],
      sizes: const ['One Size'],
      category: category,
    );
  }
}
