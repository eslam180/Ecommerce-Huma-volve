import 'package:flutter/foundation.dart';

import '../domain/entities/product.dart';
import '../domain/repositories/product_repository.dart';
import '../domain/usecases/get_categories.dart';
import '../domain/usecases/get_products.dart';

class HomeController extends ChangeNotifier {
  HomeController({required this._repository}) {
    _getProducts = GetProducts(_repository);
    _getCategories = GetCategories(_repository);
  }

  static const int pageSize = 12;

  final ProductRepository _repository;
  late final GetProducts _getProducts;
  late final GetCategories _getCategories;

  List<Product> _products = [];
  List<String> _categories = ['All'];
  bool _isLoading = false;
  bool _isLoadingMore = false;
  bool _hasMore = true;
  String? _errorMessage;
  String? _loadMoreError;
  String _searchQuery = '';
  String _selectedCategory = 'All';

  List<Product> get products => List.unmodifiable(_products);
  List<String> get categories => List.unmodifiable(_categories);
  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  bool get hasMore => _hasMore;
  String? get errorMessage => _errorMessage;
  String? get loadMoreError => _loadMoreError;
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
    if (_isLoading) return;

    _isLoading = true;
    _isLoadingMore = false;
    _hasMore = true;
    _errorMessage = null;
    _loadMoreError = null;
    _products = [];
    notifyListeners();

    try {
      final firstPage = await _getProducts(limit: pageSize, offset: 0);
      _products = firstPage;
      _hasMore = firstPage.length == pageSize;

      List<String> categoryNames;
      try {
        categoryNames = await _getCategories();
      } catch (_) {
        categoryNames = firstPage
            .map((product) => product.category)
            .where((name) => name.isNotEmpty)
            .toSet()
            .toList();
      }
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

  Future<void> loadMoreProducts() async {
    if (_isLoading || _isLoadingMore || !_hasMore || _errorMessage != null) {
      return;
    }

    _isLoadingMore = true;
    _loadMoreError = null;
    notifyListeners();

    try {
      final nextPage = await _getProducts(
        limit: pageSize,
        offset: _products.length,
      );
      _products = [..._products, ...nextPage];
      _hasMore = nextPage.length == pageSize;
    } catch (_) {
      _loadMoreError = 'Could not load more products. Tap to try again.';
    } finally {
      _isLoadingMore = false;
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
