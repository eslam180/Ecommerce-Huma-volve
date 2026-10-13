import 'package:flutter/foundation.dart';

import '../../domain/entities/auth_session.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/get_profile.dart';
import '../../domain/usecases/login.dart';
import '../../domain/usecases/logout.dart';
import '../../domain/usecases/register.dart';

class AuthController extends ChangeNotifier {
  AuthController({required this._repository}) {
    _login = Login(_repository);
    _register = Register(_repository);
    _getProfile = GetProfile(_repository);
    _logout = Logout(_repository);
  }

  final AuthRepository _repository;
  late final Login _login;
  late final Register _register;
  late final GetProfile _getProfile;
  late final Logout _logout;

  bool _isLoading = false;
  String? _errorMessage;
  AuthSession? _session;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  AuthSession? get session => _session;

  Future<bool> login({required String email, required String password}) async {
    _startRequest();
    try {
      _session = await _login(email: email, password: password);
      return true;
    } catch (error) {
      _errorMessage = _readableMessage(error);
      return false;
    } finally {
      _finishRequest();
    }
  }

  Future<bool> register({
    required String name,
    required String email,
    required String password,
  }) async {
    _startRequest();
    try {
      await _register(name: name, email: email, password: password);
      return true;
    } catch (error) {
      _errorMessage = _readableMessage(error);
      return false;
    } finally {
      _finishRequest();
    }
  }

  Future<Map<String, dynamic>?> getProfile() async {
    try {
      return await _getProfile();
    } catch (error) {
      _errorMessage = _readableMessage(error);
      notifyListeners();
      return null;
    }
  }

  void logout() {
    _logout();
    _session = null;
    _errorMessage = null;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void _startRequest() {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
  }

  void _finishRequest() {
    _isLoading = false;
    notifyListeners();
  }

  String _readableMessage(Object error) {
    final message = error.toString();
    return message.startsWith('Exception: ')
        ? message.substring('Exception: '.length)
        : message;
  }
}
