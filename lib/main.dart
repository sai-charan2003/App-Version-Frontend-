
import 'package:app_version_api/SharedPrefHelper';
import 'package:app_version_api/homePage.dart';
import 'package:app_version_api/registerPage.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'util.dart';
import 'theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferencesHelper.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isLoggedIn = SharedPreferencesHelper.getJwtToken() != null;
    final GoRouter router = GoRouter(
      initialLocation: isLoggedIn ? '/home' : '/register',
      redirect: (BuildContext context, GoRouterState state) {
        final bool loggedIn = SharedPreferencesHelper.getJwtToken() != null;
        if (!loggedIn && state.uri.toString() == '/home') return '/register';
        if (loggedIn && (state.uri.toString() == '/login' || state.uri.toString() == '/register')) {
          return '/home';
        }
        return null;
      },
      routes: [
        GoRoute(
          path: '/home',
          builder: (BuildContext context, GoRouterState state) => const Homepage(),
        ),
        GoRoute(
          path: '/register',
          builder: (BuildContext context, GoRouterState state) => const RegisterPage(),
        ),
        GoRoute(
          path: '/login',
          builder: (BuildContext context, GoRouterState state) => const RegisterPage(),
        ),
      ],
    );

    return ShadApp.router(
      routerConfig: router,
      darkTheme: ShadThemeData(
        colorScheme: ShadColorScheme.fromName('zinc', brightness: Brightness.dark),
        brightness: Brightness.dark,
      ),
    );
  }
}
