import '../repositories/product_repository.dart';

class GetCategories {
  const GetCategories(this._repository);

  final ProductRepository _repository;

  Future<List<String>> call() => _repository.getCategories();
}
