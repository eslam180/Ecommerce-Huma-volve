import 'package:dio/dio.dart';

import '../models/auth_session_model.dart';

class AuthRemoteDataSource {
  AuthRemoteDataSource({Dio? dio})
      : _dio = dio ??
            Dio(
              BaseOptions(
                baseUrl: 'https://api.escuelajs.co/api/v1',
                connectTimeout: const Duration(seconds: 15),
                receiveTimeout: const Duration(seconds: 15),
                headers: const {
                  'Accept': 'application/json',
                  'Content-Type': 'application/json',
                },
              ),
            );

  final Dio _dio;
  String? _accessToken;

  Future<AuthSessionModel> login({required String email, required String password}) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/auth/login',
      data: {'email': email.trim(), 'password': password},
    );
    final session = AuthSessionModel.fromJson(response.data ?? {});
    _accessToken = session.accessToken;
    return session;
  }

  Future<void> register({required String name, required String email, required String password}) async {
    await _dio.post<Map<String, dynamic>>(
      '/users/',
      data: {
        'name': name.trim(),
        'email': email.trim(),
        'password': password,
        'avatar': 'https://i.pravatar.cc/300',
      },
    );
  }

  Future<Map<String, dynamic>> getProfile() async {
    final token = _accessToken;
    if (token == null || token.isEmpty) {
      throw Exception('Please log in first.');
    }
    final response = await _dio.get<Map<String, dynamic>>(
      '/auth/profile',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return response.data ?? <String, dynamic>{};
  }

  void logout() => _accessToken = null;
}
