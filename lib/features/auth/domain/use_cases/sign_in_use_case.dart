import '../../data/repositories/auth_repository.dart';
import '../../data/models/user_model.dart';

class SignInUseCase {
  final AuthRepository authRepository;

  SignInUseCase(this.authRepository);

  Future<UserModel> call(String email, String password) {
    return authRepository.signIn(email, password);
  }
}
