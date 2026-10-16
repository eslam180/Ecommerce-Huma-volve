import '../entities/product.dart';

abstract class ProductRepository {
  Future<List<Product>> getProducts({required int limit, required int offset});
  Future<Product> getProductById(String id);
  Future<List<String>> getCategories();
}
