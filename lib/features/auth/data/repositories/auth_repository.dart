import '../models/user_model.dart';

abstract class AuthRepository {
  Future<UserModel> signIn(String email, String password);
  Future<UserModel> signUp(
      String name, String email, String password, String profilePic);
  Future<void> resetPassword(String email);
  Future<void> signOut();
  Future<UserModel?> getCurrentUser();
}
