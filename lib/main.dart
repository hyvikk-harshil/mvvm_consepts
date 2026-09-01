import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:mvvm_consepts/const/global_widgets/drawer/drawer_provider.dart';
import 'package:mvvm_consepts/const/theme/theme_provider.dart';
import 'package:mvvm_consepts/features/auth/viewmodels/auth_viewmodel.dart';
import 'package:mvvm_consepts/features/auth/repositorys/local_auth_repository.dart';
import 'package:mvvm_consepts/features/store/viewmodels/delete_product_viewmodel.dart';
import 'package:mvvm_consepts/features/store/viewmodels/product_viewmodel.dart';
import 'package:mvvm_consepts/features/store/viewmodels/update_product_viewmodel.dart';
import 'package:mvvm_consepts/firebase_options.dart';
import 'package:provider/provider.dart';
import 'const/routing/app_router.dart';
import 'const/service/notification_service.dart';
import 'const/theme/app_theme.dart';
import 'features/currency/repositorys/currency_repository.dart';
import 'features/currency/view_models/currency_viewmodel.dart';
import 'features/punching_time/repositorys/attendance_repository.dart';
import 'features/punching_time/viewmodels/attendance_viewmodel.dart';
import 'features/store/viewmodels/add_product_viewmodel.dart';
import 'features/store/viewmodels/user_viewmodel.dart';
import 'features/transaction_diary/viewmodels/transaction_viewmodel.dart';

import 'l10n/app_localizations.dart';
// Create a global navigator key
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
/*  WidgetsFlutterBinding.ensureInitialized();
  // Hide both bottom navigation bar and top status bar
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);*/
  WidgetsFlutterBinding.ensureInitialized();
  // Make sure you have configured Firebase via FlutterFire CLI or google-services.json first!
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Initialize notification structures
  NotificationService().initializeNotifications();

  await MobileAds.instance.initialize();
  runApp(
      MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_)=>DrawerProvider()),
            ChangeNotifierProvider(create: (_)=>ThemeProvider()),
            ChangeNotifierProvider(create: (_)=>TransactionViewModel()),
            ChangeNotifierProvider(create: (_)=>AttendanceViewModel(LocalAttendanceRepository())),
            ChangeNotifierProvider(create: (_)=>AuthViewModel(LocalAuthRepository())),
            ChangeNotifierProvider(create: (_)=>CurrencyViewModel(CurrencyRepository())),
            ChangeNotifierProvider(create: (_)=>ProductViewModel()..loadProduct()),
            ChangeNotifierProvider(create: (_)=>AddProductViewModel()),
            ChangeNotifierProvider(create: (_)=>UserViewModel()..loadUsers()),
            ChangeNotifierProvider(create: (_)=>UpdateProductViewmodel()),
            ChangeNotifierProvider(create: (_)=>DeleteProductViewmodel()),
          ],
      child: const MyApp(),)
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeProvider.themeMode,
      routerConfig: AppRouter.router,

      /// We need to manually change language here, still not selection control implementation.
      locale: const Locale('en'),
      supportedLocales: const [
        Locale('en'),
        Locale('hi'),
        Locale('gu')
        ],
      localizationsDelegates: AppLocalizations.localizationsDelegates,
    );
    }
}