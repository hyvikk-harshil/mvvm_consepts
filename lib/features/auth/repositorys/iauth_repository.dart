import '../models/user_model.dart';

abstract class IAuthRepository {
  Future<UserModel> login(String email, String pwd);
  Future<UserModel> signup(String email, String pwd);
  Future<UserModel?> checkExistingSession();
  Future<void> logout();
}