import '../repositories/auth_repository.dart';

class GetProfile {
  const GetProfile(this._repository);
  final AuthRepository _repository;

  Future<Map<String, dynamic>> call() => _repository.getProfile();
}
