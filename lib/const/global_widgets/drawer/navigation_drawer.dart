import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mvvm_consepts/const/theme/theme_provider.dart';
import 'package:mvvm_consepts/features/auth/viewmodels/auth_viewmodel.dart';
import 'package:mvvm_consepts/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'drawer_provider.dart';

Map<String,dynamic> user = {
  "name":"Harshil",
  "email":"harshil@gmail.com",
  "thumb":"HB"
};
class NavDrawer extends StatefulWidget {
  const NavDrawer({super.key,});
  @override
  State<NavDrawer> createState() => _NavDrawerState();
}
class _NavDrawerState extends State<NavDrawer> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    // Keeps your preview auto-open feature intact
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scaffoldKey.currentState?.openDrawer();
    });
  }

  @override
  Widget build(BuildContext context) {
    final lang = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;
    final authProvider = context.read<AuthViewModel>();
    // We wrap NavigationDrawer in a Consumer so only this specific part updates
    return Consumer<DrawerProvider>(
      builder: (context, drawerProvider, child) {
        return NavigationDrawer(
          selectedIndex: drawerProvider.selectedIndex, // Pulled from Provider
          backgroundColor: Theme.of(context).colorScheme.onInverseSurface,
          indicatorColor: Theme.of(context).colorScheme.primaryContainer,
          onDestinationSelected: (i) async {
            drawerProvider.setIndex(i); // Updates the index globally without parent setState
            Navigator.pop(context); // Closes the drawer safely
              if (i == 0) context.go('/dashboard');
              if (i == 1) context.go('/carousel');
              if (i == 2) context.go('/attendance');
              if (i == 3) {
                await authProvider.logOutUser();
                if (!context.mounted) return;
                context.go('/login');
              }
          },
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 28, 16, 16),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 26,
                    backgroundColor:Theme.of(context).colorScheme.primaryContainer,
                    child: Text(
                      user["thumb"],
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                       Text(
                        user['name'],
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        user['email'],
                        style: TextStyle(color: scheme.onSurfaceVariant),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(),
            NavigationDrawerDestination(
                icon: const Icon(Icons.home_outlined), label: Text(lang.home)),
             NavigationDrawerDestination(
                icon: Icon(Icons.photo_album_outlined), label: Text(lang.carousel_album)),
             NavigationDrawerDestination(
                icon: Icon(Icons.fingerprint), label: Text(lang.attendance)),

            Row(
              children: [
                SizedBox(width: 28,),
                // Dynamic icon showing a sun or moon based on active theme status
                Icon(context.watch<ThemeProvider>().isDarkMode ? Icons.dark_mode_outlined : Icons.light_mode_outlined,),
                const SizedBox(width: 12),
                 Text(lang.theme,style: TextStyle(fontWeight: FontWeight.w500),),
                Spacer(),
                Switch(
                  value: context.watch<ThemeProvider>().isDarkMode,
                  activeThumbColor: Colors.blue[100], // Optional color customizations
                  trackColor: WidgetStateProperty.resolveWith<Color>((states) {
                  if (states.contains(WidgetState.selected)) {
                  // Track color when the switch is turned ON
                  return Colors.black.withValues(alpha: 0.5);
                  }
                  // Track color when the switch is turned OFF
                  return Colors.white.withValues(alpha: 0.2);
                  }),
                  onChanged: (value) {
                    // Triggers your central theme model update
                    context.read<ThemeProvider>().toggleTheme();
                  },
                ),
                const SizedBox(width: 8),
              ],
            ),

            const Padding(
              padding: EdgeInsets.fromLTRB(28, 16, 28, 8),
              child: Divider(),
            ),
             NavigationDrawerDestination(
              icon: Icon(Icons.logout, color: Colors.red),
              label: Text(lang.sign_out, style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}

