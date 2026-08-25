import 'package:flutter/material.dart';
import 'package:mvvm_consepts/features/store/viewmodels/user_viewmodel.dart';
import 'package:mvvm_consepts/features/store/views/user_detail_screen.dart';
import 'package:provider/provider.dart';

class UserScreen extends StatelessWidget {
  const UserScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final userViewModel = context.watch<UserViewModel>();
    return Scaffold(
      body: _buildBody(userViewModel),
    );
  }

  Widget _buildBody(UserViewModel userViewModel) {
    return ListView.builder(
      itemCount: userViewModel.users.length,
      itemBuilder: (context, index){
        final user = userViewModel.users[index];
        return Hero(
          tag: "card ${user.id}",
          child: Card(
            child: ListTile(
              title: Text("${user.name.firstname} ${user.name.lastname}"),
              subtitle: Text("${user.address.number} - ${user.address.street} , ${user.address.city} - ${user.address.zipcode}"),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>UserDetailScreen(uId:user.id)));
              },
            ),
          ),
        );
      }
    );
  }
}
