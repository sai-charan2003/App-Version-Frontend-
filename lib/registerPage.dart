import 'dart:io';
import 'dart:ui';

import 'package:app_version_api/SharedPrefHelper';
import 'package:app_version_api/base_client.dart';
import 'package:app_version_api/components/Toast/ErrorToast.dart';
import 'package:app_version_api/homePage.dart';
import 'package:app_version_api/user.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
  bool isLoading = false;
  bool hasEmailEntered = false;
  bool hasPasswordEntered = false;
  bool hasUserNameEntered = false;
  final _formKey = GlobalKey<FormState>();

  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  final usernameTextController = TextEditingController();

  @override
  void initState() {
    emailTextController.addListener(_updateButtonState);
    passwordTextController.addListener(_updateButtonState);
    usernameTextController.addListener(_updateButtonState);

    super.initState();
  }

  void _updateButtonState() {
    setState(() {
      if (emailTextController.text.trim().isNotEmpty) {
        hasEmailEntered = true;
      }
      if (passwordTextController.text.trim().isNotEmpty) {
        hasPasswordEntered = true;
      }

      if (usernameTextController.text.trim().isNotEmpty) {
        hasUserNameEntered = true;
      }

      if (isSignScreen == false) {
        hasUserNameEntered = true;
      }
    });
  }

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
      child: TextFormField(
        keyboardType: TextInputType.emailAddress,
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
        textInputAction: TextInputAction.done,
        keyboardType: TextInputType.visiblePassword,
        onSubmitted: (value) {
          // Trigger the sign-in or sign-up function when "Enter" is pressed
          if (!isLoading && hasEmailEntered && hasPasswordEntered && hasUserNameEntered) {
            _handleActionButtonPressed();
          }
        },
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
          onPressed: isLoading == false && hasEmailEntered && hasPasswordEntered && hasUserNameEntered
              ? _handleActionButtonPressed
              : null,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isLoading)
                Container(
                    width: 12,
                    height: 12,
                    child: const CircularProgressIndicator(
                      strokeCap: StrokeCap.round,
                      strokeWidth: 3,
                    )),
              if (isLoading)
                SizedBox(
                  width: 5,
                ),
              Text(
                isSignScreen ? "Register" : "Sign In",
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleActionButtonPressed() async {
    setState(() {
      isLoading = true;
    });
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
      setState(() {
        isLoading = false;
      });
      _saveUserCredentials(response);
      _navigateToHomePage();
    } else {
      setState(() {
        isLoading = false;
      });
      ErrorToast.show(context, response);
    }
  }

  void _saveUserCredentials(User user) {
    SharedPreferencesHelper.setUsername(user.emailId!);
    SharedPreferencesHelper.setJWTToken(user.token!);
    SharedPreferencesHelper.setAPIKey(user.apiKey!);
  }

  void _navigateToHomePage() {
    Navigator.pushNamed(context, "/home");
  }

  void _showSnackBar(dynamic response) {
    final snackBar = SnackBar(
    dismissDirection: DismissDirection.up,    
    margin: EdgeInsets.only(
      bottom: MediaQuery.of(context).size.height-100,
      left: MediaQuery.of(context).size.width/3,
      right: MediaQuery.of(context).size.width/3,     
      
      
    ),
    elevation: 0,
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.transparent,
    content: Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.withOpacity(0.7), width: 1),

      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                color: Colors.red,
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      response.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),

                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);

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

      // Clear validation checks and reset fields
      emailTextController.clear();
      passwordTextController.clear();
      usernameTextController.clear();

      hasEmailEntered = false;
      hasPasswordEntered = false;
      hasUserNameEntered = isSignScreen; // No username validation needed for sign-in screen
    });
  }
}
