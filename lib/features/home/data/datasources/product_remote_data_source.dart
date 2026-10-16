import 'package:dio/dio.dart';

import '../models/product_model.dart';

class ProductRemoteDataSource {
  ProductRemoteDataSource({Dio? dio})
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

  Future<List<ProductModel>> fetchProducts({
    required int limit,
    required int offset,
  }) async {
    final response = await _dio.get<List<dynamic>>(
      '/products',
      queryParameters: {'limit': limit, 'offset': offset},
    );
    final data = response.data;
    if (data == null) {
      throw Exception('The server returned no products.');
    }

    return data
        .whereType<Map<String, dynamic>>()
        .map(ProductModel.fromJson)
        .toList();
  }

  Future<ProductModel> fetchProductById(String id) async {
    final response = await _dio.get<Map<String, dynamic>>('/products/$id');
    final data = response.data;
    if (data == null || data['id'] == null) {
      throw Exception('Product not found.');
    }
    return ProductModel.fromJson(data);
  }

  Future<List<String>> fetchCategories() async {
    final response = await _dio.get<List<dynamic>>('/categories');
    final data = response.data ?? const <dynamic>[];

    return data
        .whereType<Map<String, dynamic>>()
        .map((category) => category['name']?.toString().trim() ?? '')
        .where((name) => name.isNotEmpty)
        .toSet()
        .toList();
  }
}
