import 'package:ecommerce_app_huma_volve/features/home/domain/entities/product.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/repositories/product_repository.dart';
import 'package:ecommerce_app_huma_volve/features/home/controllers/home_controller.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeProductRepository implements ProductRepository {
  FakeProductRepository(this.products, this.categoryNames);

  final List<Product> products;
  final List<String> categoryNames;

  @override
  Future<List<Product>> getProducts() async => products;

  @override
  Future<List<String>> getCategories() async => categoryNames;
}

void main() {
  late HomeController controller;

  final products = [
    const Product(
      id: '1',
      name: 'Classic Sneakers',
      description: 'Everyday shoes',
      price: 59.99,
      imageUrl: 'https://example.com/shoes.png',
      colors: [0xFF000000],
      sizes: ['42'],
      category: 'Shoes',
    ),
    const Product(
      id: '2',
      name: 'Denim Jacket',
      description: 'Blue denim jacket',
      price: 89.99,
      imageUrl: 'https://example.com/jacket.png',
      colors: [0xFF0000FF],
      sizes: ['M'],
      category: 'Clothing',
    ),
  ];

  setUp(() {
    controller = HomeController(
      repository: FakeProductRepository(products, ['Shoes', 'Clothing']),
    );
  });

  tearDown(() => controller.dispose());

  test('loads products and categories through the domain repository', () async {
    await controller.loadProducts();

    expect(controller.isLoading, isFalse);
    expect(controller.errorMessage, isNull);
    expect(controller.products, hasLength(2));
    expect(controller.categories, ['All', 'Shoes', 'Clothing']);
  });

  test('filters products by search and selected category', () async {
    await controller.loadProducts();

    controller.setSearchQuery('jacket');
    expect(controller.visibleProducts.map((product) => product.name),
        ['Denim Jacket']);

    controller.setSearchQuery('');
    controller.selectCategory('Shoes');
    expect(controller.visibleProducts.map((product) => product.name),
        ['Classic Sneakers']);
  });
}
