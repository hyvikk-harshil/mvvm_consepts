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
import 'const/network/network_connectivity_checker.dart';
import 'const/network/network_manager.dart';
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

      builder: (context, child) {
        return GlobalNetworkObserver(
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
    }
}


/// check only device network is connected or not
/*class GlobalNetworkObserver extends StatefulWidget {
  final Widget child;
  const GlobalNetworkObserver({super.key, required this.child});

  @override
  State<GlobalNetworkObserver> createState() => _GlobalNetworkObserverState();
}

class _GlobalNetworkObserverState extends State<GlobalNetworkObserver> with NetworkCheckerMixin {
  @override
  Widget build(BuildContext context) {
    return widget.child; // Keeps rendering your app pages underneath safely
  }
}*/




class GlobalNetworkObserver extends StatelessWidget {
  final Widget child;
  const GlobalNetworkObserver({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final networkManager = NetworkManager();
    final statusBarHeight = MediaQuery.of(context).padding.top;

    return Directionality(
      textDirection: TextDirection.ltr,
      child: ListenableBuilder(
        listenable: networkManager,
        builder: (context, _) {
          final state = networkManager.currentStatus;

          return Stack(
            children: [
              // The application screens run normally underneath
              child,

              // Animated Top Warning Banner
              AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                curve: Curves.fastOutSlowIn,
                top: state == NetworkState.good ? -100 : 0, // Slides out of view if speed is good
                left: 0,
                right: 0,
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    padding: EdgeInsets.only(top: statusBarHeight + 8, bottom: 8, left: 16, right: 16),
                    color: state == NetworkState.disconnected ? Colors.red.shade800 : Colors.orange.shade800,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          state == NetworkState.disconnected
                              ? Icons.wifi_off
                              : Icons.signal_cellular_connected_no_internet_4_bar,
                          color: Colors.white,
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          state == NetworkState.disconnected ? "No Internet Connection" : "Your network is weak",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}


