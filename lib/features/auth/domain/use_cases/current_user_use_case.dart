import '../../data/models/user_model.dart';
import '../repositories/auth_repository.dart';

class CurrentUserUseCase {
  final AuthRepository _authRepository;

  CurrentUserUseCase(this._authRepository);

  Future<UserModel?> call() async {
    return await _authRepository.getCurrentUser();
  }
}
