import 'package:flutter/material.dart';

import 'core/deep_linking/deep_link_parser.dart';
import 'core/theme.dart';
import 'features/details/screens/product_deep_link_screen.dart';
import 'features/splash/screens/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'E-Commerce App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
      onGenerateRoute: (settings) {
        final productId = productIdFromRoute(settings.name);
        if (productId != null) {
          return MaterialPageRoute<void>(
            settings: settings,
            builder: (_) => ProductDeepLinkScreen(productId: productId),
          );
        }
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => const SplashScreen(),
        );
      },
    );
  }
}
