import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/presentation/controllers/auth_controller.dart';
import '../../features/home/controllers/home_controller.dart';
import '../../features/home/data/repositories/product_repository_impl.dart';

class AppDependencies {
  AppDependencies._();

  static AuthController createAuthController() {
    return AuthController(repository: AuthRepositoryImpl.instance);
  }

  static HomeController createHomeController() {
    return HomeController(repository: ProductRepositoryImpl());
  }
}
