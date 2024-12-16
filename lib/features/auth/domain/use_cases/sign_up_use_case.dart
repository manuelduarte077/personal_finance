import '../../data/models/user_model.dart';
import '../../data/repositories/auth_repository.dart';

class SignUpUseCase {
  final AuthRepository _authRepository;

  SignUpUseCase(this._authRepository);

  Future<UserModel> call(
      String name, String email, String password, String profilePic) async {
    return await _authRepository.signUp(name, email, password, profilePic);
  }
}
