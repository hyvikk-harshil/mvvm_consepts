import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mvvm_consepts/features/store/models/user_model.dart';

import '../../../const/network/network_manager.dart';

final NetworkBoundClient _client = NetworkBoundClient();

class UserRepository {
  Future<List<UserModel>> fetchUserData()async{
    final response = await _client.get(Uri.parse("https://fakestoreapi.com/users"));
    if(response.statusCode==200){
      List<dynamic> data = jsonDecode(response.body);
      return data.map((usersData)=>UserModel.fromJson(usersData)).toList();
    }
    else{
      throw Exception('users cant load');
    }
  }

  Future<UserModel> fetchUserDetailByID(int id) async {
    final response = await _client.get(Uri.parse("https://fakestoreapi.com/users/$id"));
    if(response.statusCode == 200){
      dynamic data = json.decode(response.body);
      return UserModel.fromJson(data);
    }
    else{
      throw Exception("User details can not load");
    }
  }
}