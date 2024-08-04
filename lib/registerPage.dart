import 'package:app_version_api/components/registerChild.dart';
import 'package:flutter/material.dart';

class Registerpage extends StatefulWidget {
  const Registerpage({super.key});

  @override
  State<Registerpage> createState() => _RegisterpageState();
}

class _RegisterpageState extends State<Registerpage> {
  
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Expanded(child: Image(image: AssetImage('assets/images/homeImage.png'),fit: BoxFit.fill,)),
          Expanded(child: Registerchild()),
        ],
      ),
    );
  }
}

