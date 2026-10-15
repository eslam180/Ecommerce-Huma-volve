import 'package:ecommerce_app_huma_volve/features/home/controllers/home_controller.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/entities/product.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/repositories/product_repository.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeProductRepository implements ProductRepository {
  FakeProductRepository(this.products, this.categoryNames);

  final List<Product> products;
  final List<String> categoryNames;
  final List<int> requestedOffsets = [];

  @override
  Future<List<Product>> getProducts({
    required int limit,
    required int offset,
  }) async {
    requestedOffsets.add(offset);
    if (offset >= products.length) return [];
    final end = offset + limit < products.length
        ? offset + limit
        : products.length;
    return products.sublist(offset, end);
  }

  @override
  Future<List<String>> getCategories() async => categoryNames;
}

Product makeProduct(int index, {String category = 'Shoes'}) {
  return Product(
    id: '$index',
    name: index == 13 ? 'Denim Jacket' : 'Product $index',
    description: 'Description $index',
    price: 20.0 + index,
    imageUrl: 'https://example.com/$index.png',
    colors: const [0xFF000000],
    sizes: const ['M'],
    category: category,
  );
}

void main() {
  late HomeController controller;
  late FakeProductRepository repository;

  final products = List<Product>.generate(14, (index) => makeProduct(index));

  setUp(() {
    repository = FakeProductRepository(products, ['Shoes', 'Clothing']);
    controller = HomeController(repository: repository);
  });

  tearDown(() => controller.dispose());

  test('loads the first page and categories', () async {
    await controller.loadProducts();

    expect(controller.isLoading, isFalse);
    expect(controller.errorMessage, isNull);
    expect(controller.products, hasLength(HomeController.pageSize));
    expect(controller.categories, ['All', 'Shoes', 'Clothing']);
    expect(controller.hasMore, isTrue);
    expect(repository.requestedOffsets, [0]);
  });

  test('loads the next page without replacing existing products', () async {
    await controller.loadProducts();
    await controller.loadMoreProducts();

    expect(controller.products, hasLength(14));
    expect(controller.products.last.id, '13');
    expect(controller.hasMore, isFalse);
    expect(controller.isLoadingMore, isFalse);
    expect(repository.requestedOffsets, [0, HomeController.pageSize]);
  });

  test('filters products by search and selected category', () async {
    await controller.loadProducts();

    controller.setSearchQuery('jacket');
    expect(controller.visibleProducts.map((product) => product.name),
        ['Denim Jacket']);

    controller.setSearchQuery('');
    controller.selectCategory('Shoes');
    expect(controller.visibleProducts, hasLength(HomeController.pageSize));
  });
}
