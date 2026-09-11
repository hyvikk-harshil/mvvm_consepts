import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'const/global_widgets/bottom_navigation_bar/navigation_model.dart';
import 'const/global_widgets/bottom_navigation_bar/navigation_view.dart';
import 'const/global_widgets/bottom_navigation_bar/navigation_viewmodel.dart';
import 'const/global_widgets/custom_gradient_appbar.dart';
import 'const/global_widgets/drawer/navigation_drawer.dart';
import 'const/service/notification_service.dart';
import 'features/currency/views/currency_convert_view.dart';
import 'features/store/views/product_screen.dart';
import 'features/store/views/user_screen.dart';
import 'features/subscribe/views/subscription_view.dart';
import 'features/transaction_diary/views/transaction_view.dart';
import 'l10n/app_localizations.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});
  @override
  Widget build(BuildContext context) {
    final language = AppLocalizations.of(context)!;
    // 1. Declare the screens for this specific dashboard
    final List<NavItemModel> tabs = [
      NavItemModel(
        icon: const Icon(Icons.person_outline_outlined),
        label: AppLocalizations.of(context)!.users,
        screen: const UserScreen(),
      ), NavItemModel(
        icon: const Icon(Icons.shopping_bag_outlined),
        label: language.shop,
        screen: const ProductScreen(),
      ), NavItemModel(
        icon: Icon(Icons.currency_bitcoin),
        label: language.t_dairy,
        screen: TransactionView(),
      ),
       NavItemModel(
        icon: Icon(Icons.currency_exchange),
        label: language.currency,
        screen: CurrencyConvertView(),
      ),  NavItemModel(
        icon: Icon(Icons.subscriptions_outlined),
        label: language.menu,
        screen: SubscriptionView(),
      ),
    ];

    // 2. Wrap your view layout inside a ChangeNotifierProvider
    return ChangeNotifierProvider(
      create: (_) => NavigationViewModel(),
      child: ReusableNavShell(
        navItems: tabs,
        appBar: CustomGradientAppBar(title: language.dashboard ,actions: [
          IconButton(
          icon: const Icon(Icons.notifications,color: Colors.deepOrange,),
          onPressed: (){
            ForegroundBanner.show(
                title: "Local",
                message: "Notification"
            );          },
        ),
          IconButton(
          icon: const Icon(Icons.chat_bubble_outline,color: Colors.white,),
          onPressed: (){
            // Navigates cleanly by passing data straight into the path parameters map
            context.pushNamed(
              'chat_room',
              pathParameters: {
                'chatRoomId': 'room_abc123', // Unique combination of user IDs
                'peerUsername': 'Harshil',
              },
            );
            },
        ),
          IconButton(
            icon: const Icon(Icons.chat_bubble, color: Colors.white),
            onPressed: () {
              // Navigates cleanly out to the standalone Chat Inbox screen
              context.pushNamed('chat_inbox');
            },
          ),
      ],),
        drawer: const NavDrawer(),
      ),
    );
  }
}




