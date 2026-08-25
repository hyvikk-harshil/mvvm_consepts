import 'package:flutter/material.dart';
import 'package:mvvm_consepts/dashboard.dart';
import 'package:provider/provider.dart';
import '../viewmodels/auth_viewmodel.dart';
import 'login_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authPro = context.watch<AuthViewModel>();

    //central app status routing switcher
    switch (authPro.status){
      case AuthStatus.checking:
        return Scaffold(
          body: Center(child: CircularProgressIndicator(),),
        );
      case AuthStatus.authenticated:
        //context.go("/dashboard");
        return Dashboard();
      case AuthStatus.unauthenticated:
        //context.go("/dashboard");
        return LoginScreen();
    }
  }
}
