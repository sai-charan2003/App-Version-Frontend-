import 'package:app_version_api/SharedPrefHelper';

import 'package:app_version_api/homePage.dart';
import 'package:app_version_api/registerPage.dart';
import 'package:flutter/material.dart';
import 'util.dart';
import 'theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();  // Ensure initialization
  await SharedPreferencesHelper.init();  // Initialize SharedPreferences
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final brightness = View.of(context).platformDispatcher.platformBrightness;
    TextTheme textTheme = createTextTheme(context, "DM Sans", "DM Sans");
    MaterialTheme theme = MaterialTheme(textTheme);

    return MaterialApp(
      theme: brightness == Brightness.light ? theme.light() : theme.dark(),

      onGenerateRoute: (page) {
        bool isLoggedIn = SharedPreferencesHelper.getJwtToken() != null;

        if (!isLoggedIn) {
          
          if (page.name == "/home") {
            return MaterialPageRoute(
              builder: (context) => const RegisterPage(),
              settings: const RouteSettings(name: '/register'),
            );
          }
        } else {
          
          if (page.name == "/login" || page.name == "/register") {
            return MaterialPageRoute(
              builder: (context) => const Homepage(),
              settings: const RouteSettings(name: '/home'),
            );
          }
        }

        
        switch (page.name) {
          case "/login":
            return MaterialPageRoute(
              builder: (context) => const RegisterPage(),
              settings: const RouteSettings(name: "/login")
            );
          case "/register":
            return MaterialPageRoute(
              builder: (context) => const RegisterPage(),
              settings: const RouteSettings(name: "/register")
            );
          case "/home":
            return MaterialPageRoute(
              builder: (context) => const Homepage(),
              settings: const RouteSettings(name: "/home")
            );
          default:
            return null;
        }
      },

      initialRoute: "/register", // Start with the register page
    );
  }
}
