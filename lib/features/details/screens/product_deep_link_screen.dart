import 'package:flutter/material.dart';

import '../../../core/di/app_dependencies.dart';
import '../../../core/theme.dart';
import '../../home/domain/entities/product.dart';
import '../../home/domain/usecases/get_product_by_id.dart';
import 'product_details_screen.dart';

class ProductDeepLinkScreen extends StatefulWidget {
  const ProductDeepLinkScreen({super.key, required this.productId});

  final String productId;

  @override
  State<ProductDeepLinkScreen> createState() => _ProductDeepLinkScreenState();
}

class _ProductDeepLinkScreenState extends State<ProductDeepLinkScreen> {
  late Future<Product> _productFuture;

  @override
  void initState() {
    super.initState();
    _loadProduct();
  }

  void _loadProduct() {
    _productFuture =
        GetProductById(AppDependencies.createProductRepository())(
      widget.productId,
    );
  }

  void _retry() {
    setState(_loadProduct);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Product>(
      future: _productFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ProductDetailsScreen(product: snapshot.data!);
        }

        if (snapshot.hasError) {
          return Scaffold(
            backgroundColor: AppTheme.background,
            appBar: AppBar(
              title: const Text('Product details'),
              backgroundColor: AppTheme.background,
            ),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.link_off, size: 48, color: Colors.grey),
                    const SizedBox(height: 16),
                    const Text(
                      'This product could not be opened.',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: _retry,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Try again'),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        return Scaffold(
          backgroundColor: AppTheme.background,
          body: const Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
