import 'package:flutter/material.dart';
import 'package:mvvm_consepts/features/store/repository/user_repository.dart';
import '../models/user_model.dart';

class USerDetailViewModel extends ChangeNotifier{
  final UserRepository _userRepository = UserRepository();
  UserModel? user;
  bool isLoad = false;
  String errorMessage = '';

  Future<void> loadUserDetails(int id) async {
    isLoad = true;
    errorMessage = '';
    notifyListeners();

    try{
      user = await _userRepository.fetchUserDetailByID(id);
    }catch(e){
      errorMessage = e.toString();
    }finally{
      isLoad = false;
      notifyListeners();
    }
  }
}