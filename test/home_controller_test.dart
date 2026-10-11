import 'package:ecommerce_app_huma_volve/core/dummy_data.dart';
import 'package:ecommerce_app_huma_volve/features/home/controllers/home_controller.dart';
import 'package:ecommerce_app_huma_volve/features/home/services/product_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeProductService extends ProductService {
  FakeProductService(this.products, this.categoryNames);

  final List<Product> products;
  final List<String> categoryNames;

  @override
  Future<List<Product>> fetchProducts() async => products;

  @override
  Future<List<String>> fetchCategories() async => categoryNames;
}

void main() {
  late HomeController controller;

  final products = [
    Product(
      id: '1',
      name: 'Classic Sneakers',
      description: 'Everyday shoes',
      price: 59.99,
      imageUrl: 'https://example.com/shoes.png',
      colors: [Colors.black],
      sizes: ['42'],
      category: 'Shoes',
    ),
    Product(
      id: '2',
      name: 'Denim Jacket',
      description: 'Blue denim jacket',
      price: 89.99,
      imageUrl: 'https://example.com/jacket.png',
      colors: [Colors.blue],
      sizes: ['M'],
      category: 'Clothing',
    ),
  ];

  setUp(() {
    controller = HomeController(
      productService: FakeProductService(products, ['Shoes', 'Clothing']),
    );
  });

  tearDown(() {
    controller.dispose();
  });

  test('loads products and categories from the service', () async {
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
