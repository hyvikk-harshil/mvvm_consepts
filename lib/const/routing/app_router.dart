import 'package:go_router/go_router.dart';
import 'package:mvvm_consepts/const/global_widgets/carousel_slider.dart';
import 'package:mvvm_consepts/const/google_service/banner_ad_example.dart';
import 'package:mvvm_consepts/const/google_service/g_map.dart';
import 'package:mvvm_consepts/const/google_service/interstitial_ad_example.dart';
import 'package:mvvm_consepts/const/google_service/rewarded_ad_example.dart';
import 'package:mvvm_consepts/const/theme/colorscheme_example.dart';
import 'package:mvvm_consepts/dashboard.dart';
import 'package:mvvm_consepts/features/punching_time/views/attendance_navbar.dart';
import 'package:mvvm_consepts/features/store/views/product_update_screen.dart';
import 'package:mvvm_consepts/main.dart';
import '../../features/auth/views/splash_screen.dart';
import '../../features/store/models/product_model.dart';
import '../../features/store/views/add_product_screen.dart';
import '../../features/store/views/product_detail_screen.dart';
import '../../features/transaction_diary/views/add_transaction.dart';
import '../constant/image_manager.dart';

List<String> images = [
  AppImages.img1,
  AppImages.img2,
  AppImages.img3,
  AppImages.img4,
  AppImages.img5,
  AppImages.img6
];
class AppRouter {
static final GoRouter router =GoRouter(
  navigatorKey: navigatorKey,
  initialLocation: "/login",
  routes: [
    GoRoute(
        path: "/login",
      builder: (context, state) => const SplashScreen()
    ),
    GoRoute(
        path: "/carousel",
      builder: (context, state) => UniversalCarouselSlider(images: images,aspectRatio: 2.0,)
    ),
    GoRoute(
        path: "/attendance",
      builder: (context, state) => AttendanceNavBar()
    ),
    GoRoute(
        path: "/color",
      builder: (context, state) => ColorSchemeExample()
    ),

    GoRoute(
        path: "/dashboard",
        builder: (context, state) => const Dashboard()
    ),
    GoRoute(
        path: "/add_transaction",
        builder: (context, state) => const AddTransaction()
    ),


    GoRoute(
      // The :id creates a dynamic path variable placeholder parameter slot
      path: '/detail/:id',
      builder: (context, state) {
        // Extract the path parameter directly from the route state map framework
        final String idString = state.pathParameters['id']!;
        final int id = int.parse(idString);

        return ProductDetailScreen(productId: id);
      },
    ),
    GoRoute(
        path: "/add_product",
        builder: (context, state) => const AddProductScreen()
    ), 
    GoRoute(
        path: '/edit/:id',
        builder: (context, state) {
         final product = state.extra as ProductModel;
         return ProductUpdateScreen(productToEdit: product);
        }
    ),

    GoRoute(
        path: "/google_map",
        builder: (context, state) => const GoogleMapScreen()
    ),
    GoRoute(
        path: "/banner_ad",
        builder: (context, state) => const BannerAdWidget()
    ),
    GoRoute(
        path: "/interstitial_ad",
        builder: (context, state) => const InterstitialAdExample()
    ),
    GoRoute(
        path: "/rewarded_ad",
        builder: (context, state) => const RewardedAdExample()
    ),
  ]
);
}