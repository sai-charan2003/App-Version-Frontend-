import 'package:app_version_api/SharedPrefHelper';
import 'package:app_version_api/homePage.dart';
import 'package:app_version_api/registerPage.dart';
import 'package:flutter/material.dart';
import 'util.dart';
import 'theme.dart';

Future<void> main() async {
  await SharedPreferencesHelper.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final brightness = View.of(context).platformDispatcher.platformBrightness;
    TextTheme textTheme = createTextTheme(context, "Nunito Sans", "Nunito");
    MaterialTheme theme = MaterialTheme(textTheme);
    return MaterialApp(
      
      theme: brightness == Brightness.light ? theme.light() : theme.dark(),
      home: Scaffold(
        body : Homepage()
      ),
    );
  }
}

