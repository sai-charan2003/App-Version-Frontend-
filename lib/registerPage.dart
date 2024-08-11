import 'dart:io';

import 'package:app_version_api/SharedPrefHelper';
import 'package:app_version_api/base_client.dart';
import 'package:app_version_api/homePage.dart';
import 'package:app_version_api/user.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:glossy/glossy.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GlossyContainer(
          child: const RegisterFields(),
          width: 500,
          height: 500,
          borderRadius: BorderRadius.circular(12),
          padding: const EdgeInsets.all(8),
        ),
      ),
    );
  }
}

class RegisterFields extends StatefulWidget {
  const RegisterFields({super.key});

  @override
  State<RegisterFields> createState() => _RegisterFieldsState();
}

class _RegisterFieldsState extends State<RegisterFields> {
  bool isSignScreen = true;
  bool isPasswordVisible = false;
  bool isClicked = false;

  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  final usernameTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        _buildWelcomeText(),
        _buildAppLogo(),
        _buildTextField(controller: emailTextController, labelText: 'Email', icon: Icons.email),
        if (isSignScreen)
          _buildTextField(controller: usernameTextController, labelText: 'Username', icon: Icons.person),
        _buildPasswordField(),
        _buildActionButton(context),
        _buildSwitchScreenText(),
      ],
    );
  }

  Widget _buildWelcomeText() {
    return Text(
      isSignScreen ? "Welcome to app version vault" : "Welcome back",
      style: Theme.of(context).textTheme.titleLarge,
    );
  }

  Widget _buildAppLogo() {
    return const SizedBox(
      height: 50,
      width: 50,
      child: Image(
        image: AssetImage('assets/images/appLogo.png'),
        fit: BoxFit.fill,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 40),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          prefixIcon: Icon(icon),
          labelText: labelText,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _buildPasswordField() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 40),
      child: TextField(
        controller: passwordTextController,
        obscureText: !isPasswordVisible,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.password),
          suffixIcon: IconButton(
            onPressed: _togglePasswordVisibility,
            icon: Icon(
              isPasswordVisible ? Icons.visibility : Icons.visibility_off,
            ),
          ),
          labelText: 'Password',
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  void _togglePasswordVisibility() {
    setState(() {
      isPasswordVisible = !isPasswordVisible;
    });
  }

  Widget _buildActionButton(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      child: SizedBox(
        width: double.infinity,
        child: FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.secondary,
          ),
          onPressed: _handleActionButtonPressed,
          child: Text(isSignScreen ? "Register" : "Sign In"),
        ),
      ),
    );
  }

  Future<void> _handleActionButtonPressed() async {
    var user = User(
      emailId: emailTextController.text,
      password: passwordTextController.text,
      userName: usernameTextController.text,
    ).toJson();
    

    var response = isSignScreen
        ? await BaseClient().registerUser(user).catchError((error) => print(error))
        : await BaseClient().loginUser(user).catchError((error) => print(error));

    _handleResponse(response);
  }

  void _handleResponse(dynamic response) {
    if (response is User) {
      _saveUserCredentials(response);
      _navigateToHomePage();
    } else {
      _showSnackBar(response);
    }
  }

  void _saveUserCredentials(User user) {
    SharedPreferencesHelper.setUsername(user.emailId!);
    SharedPreferencesHelper.setJWTToken(user.token!);
    SharedPreferencesHelper.setAPIKey(user.apiKey!);
  }

  void _navigateToHomePage() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const Homepage()),
      (route) => false,
    );
  }

  void _showSnackBar(dynamic response) {
    final snackBar = SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: response == HttpStatus.conflict ? 'Email Already Exists' : 'Error occurred',
        message: response == HttpStatus.conflict
            ? 'Email Already Exists, please login to continue'
            : 'An error occurred, please try again later',
        contentType: ContentType.failure,
      ),
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  Widget _buildSwitchScreenText() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(isSignScreen ? "Already have an account?" : "Don't have an account?"),
        Padding(
          padding: const EdgeInsets.only(left: 5),
          child: InkWell(
            onTap: _toggleSignScreen,
            child: Text(
              isSignScreen ? "Sign in" : "Create an account",
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _toggleSignScreen() {
    setState(() {
      isSignScreen = !isSignScreen;
    });
  }
}
