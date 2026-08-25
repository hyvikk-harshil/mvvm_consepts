import 'package:flutter/material.dart';
import 'package:mvvm_consepts/features/store/viewmodels/user_detail_viewmodel.dart';
import 'package:provider/provider.dart';

import '../../../const/constant/image_manager.dart';

class UserDetailScreen extends StatelessWidget {
  final int uId;
  const UserDetailScreen({super.key,required this.uId});

  @override
  Widget build(BuildContext context) {

    return ChangeNotifierProvider(
      create: (context)=> USerDetailViewModel()..loadUserDetails(uId),
      child:
      Scaffold(
        body: SafeArea(
          child: Consumer<USerDetailViewModel>(
            builder: (context,userDVM,child)
            {
              if(userDVM.isLoad) return Center(child: CircularProgressIndicator(),);
              if(userDVM.errorMessage.isNotEmpty) return Center(child: Text(userDVM.errorMessage),);
              return Stack(
                children: [
                  Hero(tag:"card $uId",child: Image.asset(AppImages.img5, width: double.infinity,)),
                  Positioned(
                    child: Center(

                      child: Column(
                        mainAxisAlignment: .center,
                        children: [
                          Text("${userDVM.user!.name.firstname} ${userDVM.user!.name
                              .lastname}",style: TextStyle(fontSize: 24),),
                          SizedBox(height: 10,),
                          Text(userDVM.user!.email),
                          SizedBox(height: 10,),
                          Text(userDVM.user!.phone),
                          SizedBox(height: 10,),
                          Text("${userDVM.user!.address.number}-${userDVM.user!.address
                              .street},${userDVM.user!.address.city} - ${userDVM.user!.address
                              .zipcode}"),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }
          ),
        ),
      )
    );
  }
}
