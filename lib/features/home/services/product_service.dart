import 'package:dio/dio.dart';
import '../../../../core/dummy_data.dart';

class ProductService {
  ProductService({Dio? dio})
      : _dio = dio ??
            Dio(
              BaseOptions(
                baseUrl: 'https://api.escuelajs.co/api/v1',
                connectTimeout: const Duration(seconds: 15),
                receiveTimeout: const Duration(seconds: 15),
                headers: const {
                  'Accept': 'application/json',
                  'Content-Type': 'application/json',
                },
              ),
            );

  final Dio _dio;

  Future<List<Product>> fetchProducts() async {
    final response = await _dio.get<List<dynamic>>(
      '/products',
      queryParameters: {'limit': 20, 'offset': 0},
    );
    final data = response.data;
    if (data == null) {
      throw Exception('No products were returned by the server.');
    }

    return data
        .whereType<Map<String, dynamic>>()
        .map(_productFromJson)
        .toList();
  }

  Future<List<String>> fetchCategories() async {
    final response = await _dio.get<List<dynamic>>('/categories');
    final data = response.data;
    if (data == null) return const [];

    return data
        .whereType<Map<String, dynamic>>()
        .map((category) => category['name']?.toString().trim() ?? '')
        .where((name) => name.isNotEmpty)
        .toSet()
        .toList();
  }

  Product _productFromJson(Map<String, dynamic> json) {
    final rawImages = json['images'];
    final images = rawImages is List
        ? rawImages.map((image) => image.toString()).toList()
        : <String>[];
    final imageUrl = images.firstWhere(
      (image) => image.startsWith('http://') || image.startsWith('https://'),
      orElse: () => '',
    );

    final rawCategory = json['category'];
    final categoryName = rawCategory is Map
        ? rawCategory['name']?.toString() ?? ''
        : '';

    final rawPrice = json['price'];
    final price = rawPrice is num
        ? rawPrice.toDouble()
        : double.tryParse(rawPrice?.toString() ?? '') ?? 0;

    return Product(
      id: json['id']?.toString() ?? '',
      name: json['title']?.toString() ?? 'Unnamed product',
      description: json['description']?.toString() ?? '',
      price: price,
      imageUrl: imageUrl,
      colors: const [],
      sizes: const ['One Size'],
      category: categoryName,
    );
  }
}
