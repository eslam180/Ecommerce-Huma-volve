import 'package:dio/dio.dart';

import '../../domain/entities/auth_session.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl._() : _dataSource = AuthRemoteDataSource();

  static final AuthRepositoryImpl instance = AuthRepositoryImpl._();
  final AuthRemoteDataSource _dataSource;

  @override
  Future<AuthSession> login({required String email, required String password}) async {
    try {
      return await _dataSource.login(email: email, password: password);
    } on DioException catch (error) {
      throw Exception(_messageFrom(error));
    } on FormatException catch (error) {
      throw Exception(error.message);
    }
  }

  @override
  Future<void> register({required String name, required String email, required String password}) async {
    try {
      await _dataSource.register(name: name, email: email, password: password);
    } on DioException catch (error) {
      throw Exception(_messageFrom(error));
    }
  }

  @override
  Future<Map<String, dynamic>> getProfile() async {
    try {
      return await _dataSource.getProfile();
    } on DioException catch (error) {
      throw Exception(_messageFrom(error));
    }
  }

  @override
  void logout() => _dataSource.logout();

  String _messageFrom(DioException error) {
    final data = error.response?.data;
    if (data is Map) {
      final message = data['message'] ?? data['error'];
      if (message is List && message.isNotEmpty) return message.join('\n');
      if (message is String && message.isNotEmpty) return message;
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
        return 'Request failed. Please try again.';
    }
  }
}
