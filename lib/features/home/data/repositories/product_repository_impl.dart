import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_remote_data_source.dart';

class ProductRepositoryImpl implements ProductRepository {
  ProductRepositoryImpl({ProductRemoteDataSource? dataSource})
      : _dataSource = dataSource ?? ProductRemoteDataSource();

  final ProductRemoteDataSource _dataSource;

  @override
  Future<List<Product>> getProducts() => _dataSource.fetchProducts();

  @override
  Future<List<String>> getCategories() => _dataSource.fetchCategories();
}
