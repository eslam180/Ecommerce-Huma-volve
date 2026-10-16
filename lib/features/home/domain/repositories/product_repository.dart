import '../entities/product.dart';

abstract class ProductRepository {
  Future<List<Product>> getProducts({required int limit, required int offset});
  Future<List<String>> getCategories();
}
