import 'dart:convert';
import 'package:mvvm_consepts/features/auth/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'iauth_repository.dart';

class LocalAuthRepository implements IAuthRepository{
  static const String _userKey = 'cached_user_session';

  @override
  Future<UserModel> login(email,pwd) async {
  await Future.delayed(Duration(seconds: 2)); //Simulate Network Latency

  if(email == "harshil.hyvikk@gmail.com" && pwd == "Harshil@309"){
    final user = UserModel(uid: "1", email: email, token: "JWT_TOKEN_ABC");
    await _saveSession(user);
    return user;
  }
  throw Exception('Invalid Email or Password combination');
  }

  @override
  Future<UserModel> signup(email,pwd) async {
  await Future.delayed(Duration(seconds: 2));
  if(pwd.length < 8){
    throw Exception('Password must be at least 8 character longer...');
  }
  final user = UserModel(uid: DateTime.now().millisecondsSinceEpoch.toString(),email: email, token: "NEW_JWT_TOKEN");
  await _saveSession(user);
  return user;
  }

  @override
  Future<UserModel?> checkExistingSession() async {
    final pref = await SharedPreferences.getInstance();
    final String? userRaw = pref.getString(_userKey);
    if (userRaw == null) return null;
    return UserModel.fromMap(jsonDecode(userRaw));
  }

  @override
  Future<void> logout() async {
  final pref = await SharedPreferences.getInstance();
  await pref.remove(_userKey);
  }

  Future<void> _saveSession(UserModel user) async {
    final pref = await SharedPreferences.getInstance();
    pref.setString(_userKey, jsonEncode(user.toMap()));
  }

}