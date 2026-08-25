import 'package:flutter/material.dart';
import 'package:mvvm_consepts/features/store/models/user_model.dart';
import 'package:mvvm_consepts/features/store/repository/user_repository.dart';

class UserViewModel extends ChangeNotifier {
  final UserRepository _userRepository = UserRepository();
  List<UserModel> users = [];
  bool isLoading = false;
  String errorMessage = '';

  Future<void> loadUsers() async {
    isLoading = true;
    errorMessage ='';
    notifyListeners();

    try{
      users = await _userRepository.fetchUserData();
    }catch(e){
      errorMessage = e.toString();
    }finally{
      notifyListeners();
    }
  }
}