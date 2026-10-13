import 'package:flutter/foundation.dart';

import '../domain/entities/product.dart';
import '../domain/repositories/product_repository.dart';
import '../domain/usecases/get_categories.dart';
import '../domain/usecases/get_products.dart';

class HomeController extends ChangeNotifier {
  HomeController({required ProductRepository repository})
      : _repository = repository {
    _getProducts = GetProducts(_repository);
    _getCategories = GetCategories(_repository);
  }

  final ProductRepository _repository;
  late final GetProducts _getProducts;
  late final GetCategories _getCategories;

  List<Product> _products = [];
  List<String> _categories = ['All'];
  bool _isLoading = false;
  String? _errorMessage;
  String _searchQuery = '';
  String _selectedCategory = 'All';

  List<Product> get products => List.unmodifiable(_products);
  List<String> get categories => List.unmodifiable(_categories);
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get searchQuery => _searchQuery;
  String get selectedCategory => _selectedCategory;

  List<Product> get visibleProducts {
    final query = _searchQuery.trim().toLowerCase();
    return _products.where((product) {
      final matchesCategory = _selectedCategory == 'All' ||
          product.category.toLowerCase() == _selectedCategory.toLowerCase();
      final matchesSearch = query.isEmpty ||
          product.name.toLowerCase().contains(query) ||
          product.description.toLowerCase().contains(query);
      return matchesCategory && matchesSearch;
    }).toList();
  }

  Future<void> loadProducts() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final products = await _getProducts();
      List<String> categoryNames;
      try {
        categoryNames = await _getCategories();
      } catch (_) {
        categoryNames = products
            .map((product) => product.category)
            .where((name) => name.isNotEmpty)
            .toSet()
            .toList();
      }
      _products = products;
      _categories = ['All', ...categoryNames];
      if (!_categories.contains(_selectedCategory)) {
        _selectedCategory = 'All';
      }
    } catch (_) {
      _errorMessage =
          'Could not load products. Please check your connection and try again.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setSearchQuery(String value) {
    _searchQuery = value;
    notifyListeners();
  }

  void selectCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }
}
