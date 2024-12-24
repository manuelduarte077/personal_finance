import 'profile_repository.dart';

class DeleteAccountUseCase {
  final ProfileRepository deleteAccountRepository;

  DeleteAccountUseCase(this.deleteAccountRepository);

  Future<void> call() async {
    await deleteAccountRepository.deleteAccount();
  }
}
