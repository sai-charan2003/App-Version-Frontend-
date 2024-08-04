
import 'package:app_version_api/base_client.dart';
import 'package:app_version_api/user.dart';
import 'package:flutter/material.dart';

class Registerchild extends StatefulWidget {
  const Registerchild({super.key});

  @override
  State<Registerchild> createState() => _RegisterchildState();
}

class _RegisterchildState extends State<Registerchild> {
  var isPasswordVisible = false;
  var emailTextController = TextEditingController();
  var passwordTextController = TextEditingController();
  var usernameTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {    
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.all(10.0),
            child: TextField(
              controller: emailTextController,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.email),              
                labelText: 'Email',
                
                
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(10 ),
            child: TextField(
              controller: usernameTextController,
              
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.person),         
                labelText: 'Username',                          
                border: const OutlineInputBorder(),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(10 ),
            child: TextField(
              controller: passwordTextController,
              obscureText: !isPasswordVisible,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.password),
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      isPasswordVisible = !isPasswordVisible;                      
                    });
                  }, 
                  icon: Icon(isPasswordVisible
               ? Icons.visibility
               : Icons.visibility_off,)),          
                labelText: 'Password',                          
                border: const OutlineInputBorder(),
              ),
            ),
          ),
          
          
          ElevatedButton(onPressed: () {
            var user = User(
              emailId: emailTextController.text,
              password: passwordTextController.text,
              userName: usernameTextController.text
            ).toJson();
            
            var response = BaseClient().registerUser(user).catchError((error){print(error);});
                     

          }, child: const Text("Register")),
        ],
      ),
    );;
  }
}