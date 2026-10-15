import '../entities/product.dart';
import '../repositories/product_repository.dart';

class GetProducts {
  const GetProducts(this._repository);

  final ProductRepository _repository;

  Future<List<Product>> call({required int limit, required int offset}) {
    return _repository.getProducts(limit: limit, offset: offset);
  }
}
