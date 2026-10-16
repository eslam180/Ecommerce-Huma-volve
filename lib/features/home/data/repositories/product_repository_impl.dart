import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_remote_data_source.dart';

class ProductRepositoryImpl implements ProductRepository {
  ProductRepositoryImpl({ProductRemoteDataSource? dataSource})
      : _dataSource = dataSource ?? ProductRemoteDataSource();

  final ProductRemoteDataSource _dataSource;

  @override
  Future<List<Product>> getProducts({
    required int limit,
    required int offset,
  }) =>
      _dataSource.fetchProducts(limit: limit, offset: offset);

  @override
  Future<Product> getProductById(String id) => _dataSource.fetchProductById(id);

  @override
  Future<List<String>> getCategories() => _dataSource.fetchCategories();
}
