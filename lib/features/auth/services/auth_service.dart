import 'package:dio/dio.dart';

class AuthService {
  AuthService._();

  static final AuthService instance = AuthService._();
  static const String _baseUrl = 'https://api.escuelajs.co/api/v1';

  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: const {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    ),
  );

  String? _accessToken;
  String? get accessToken => _accessToken;

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/auth/login',
        data: {'email': email.trim(), 'password': password},
      );
      final data = response.data ?? <String, dynamic>{};
      final token = data['access_token'] ?? data['accessToken'] ?? data['token'];
      if (token is! String || token.isEmpty) {
        throw const AuthException(
          'Login succeeded but the API did not return an access token.',
        );
      }
      _accessToken = token;
      return data;
    } on DioException catch (error) {
      throw AuthException(_messageFrom(error));
    }
  }

  Future<Map<String, dynamic>> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/users/',
        data: {
          'name': name.trim(),
          'email': email.trim(),
          'password': password,
          'avatar': 'https://i.pravatar.cc/300',
        },
      );
      return response.data ?? <String, dynamic>{};
    } on DioException catch (error) {
      throw AuthException(_messageFrom(error));
    }
  }

  Future<Map<String, dynamic>> getProfile() async {
    final token = _accessToken;
    if (token == null || token.isEmpty) {
      throw const AuthException('Please log in first.');
    }
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '/auth/profile',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return response.data ?? <String, dynamic>{};
    } on DioException catch (error) {
      throw AuthException(_messageFrom(error));
    }
  }

  void logout() {
    _accessToken = null;
  }

  String _messageFrom(DioException error) {
    final data = error.response?.data;
    if (data is Map) {
      final message = data['message'] ?? data['error'];
      if (message is List && message.isNotEmpty) {
        return message.join('\n');
      }
      if (message is String && message.isNotEmpty) {
        return message;
      }
    }
    switch (error.response?.statusCode) {
      case 400:
        return 'Please check the information you entered.';
      case 401:
        return 'Email or password is incorrect.';
      case 409:
        return 'This email is already registered.';
      case 422:
        return 'The submitted information is invalid or the email is already used.';
      default:
        if (error.response == null) {
          return 'Could not connect to the server. Check your internet connection.';
        }
        return 'Request failed (${error.response!.statusCode}). Please try again.';
    }
  }
}

class AuthException implements Exception {
  final String message;
  const AuthException(this.message);

  @override
  String toString() => message;
}
