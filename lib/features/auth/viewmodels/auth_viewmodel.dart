import 'package:flutter/cupertino.dart';
import '../models/user_model.dart';
import '../repositorys/iauth_repository.dart';

enum AuthStatus{checking, authenticated, unauthenticated}

class AuthViewModel extends ChangeNotifier{
 final IAuthRepository _authRepository;

 AuthViewModel(this._authRepository){
  checkUserSession(); //run auto-login immediate upon application launch
 }

 UserModel? _currentUser;
 AuthStatus _status = AuthStatus.checking;
 bool _isBusy = false; // Tracks individual screen loading button spinners

 // Public Getters
 UserModel? get currentUser => _currentUser;
 AuthStatus get status => _status;
 bool get isBusy => _isBusy;

 void _setBusy(bool value) {
  _isBusy = value;
  notifyListeners();
 }

 //core authentication work flow
Future<void> checkUserSession() async {
  _status = AuthStatus.checking;
  notifyListeners();
  try{
   _currentUser = await _authRepository.checkExistingSession();
   _status = _currentUser != null? AuthStatus.authenticated : AuthStatus.unauthenticated;
  }catch (_){
   _status = AuthStatus.unauthenticated;
  }finally{
   notifyListeners();
  }
}

Future<bool> loginUser(String email, String password) async {
  _setBusy(true);
  try{
    _currentUser = await _authRepository.login(email,password);
    _status = AuthStatus.authenticated;
    return true;
  }catch(e){
    rethrow;
  }finally{
    _setBusy(false);
  }
}

Future<bool> signUpUser(String email, String password) async {
  _setBusy(true);
  try{
    _currentUser = await _authRepository.signup(email,password);
    _status = AuthStatus.authenticated;
    return true;
  }catch(e){
    rethrow;
  }finally{
    _setBusy(false);
  }
}

Future<void> logOutUser() async {
   await _authRepository.logout();
   _currentUser = null;
   _status = AuthStatus.unauthenticated;
   notifyListeners();
}
}