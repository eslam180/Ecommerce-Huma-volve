import 'package:ecommerce_app_huma_volve/core/deep_linking/deep_link_parser.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('productIdFromRoute', () {
    test('reads a product path', () {
      expect(productIdFromRoute('/product/42'), '42');
    });

    test('reads a full HTTPS product link', () {
      expect(
        productIdFromRoute('https://humavolve.app/product/42'),
        '42',
      );
    });

    test('reads the custom scheme product link', () {
      expect(productIdFromRoute('humavolve://product/42'), '42');
    });

    test('supports Flutter passing only a numeric path', () {
      expect(productIdFromRoute('/42'), '42');
    });

    test('ignores unsupported or malformed routes', () {
      expect(productIdFromRoute('/profile'), isNull);
      expect(productIdFromRoute('/product/not-a-number'), isNull);
      expect(productIdFromRoute(null), isNull);
    });
  });
}
