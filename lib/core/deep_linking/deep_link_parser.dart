String? productIdFromRoute(String? routeName) {
  if (routeName == null || routeName.isEmpty) return null;

  final uri = Uri.tryParse(routeName);
  if (uri == null) return null;

  final segments = uri.pathSegments.where((segment) => segment.isNotEmpty).toList();

  if (uri.scheme == 'humavolve' && uri.host == 'product') {
    return segments.length == 1 && _isProductId(segments.first)
        ? segments.first
        : null;
  }

  if (segments.length == 2 &&
      segments.first == 'product' &&
      _isProductId(segments.last)) {
    return segments.last;
  }

  // Flutter may pass only the path portion of an incoming Android intent.
  if (segments.length == 1 && _isProductId(segments.first)) {
    return segments.first;
  }

  return null;
}

bool _isProductId(String value) => RegExp(r'^\d+$').hasMatch(value);
