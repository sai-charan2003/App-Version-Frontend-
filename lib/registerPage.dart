import 'dart:math';
import 'dart:ui';

import 'package:app_version_api/SharedPrefHelper';
import 'package:app_version_api/base_client.dart';
import 'package:app_version_api/components/Toast/ErrorToast.dart';
import 'package:app_version_api/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = screenWidth < 600 ? screenWidth * 0.9 : 550;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: ShadCard(
            width: cardWidth.toDouble(),
            padding: const EdgeInsets.all(16),
            child: const RegisterFields(),
          ),
        ),
      ),
    );
  }
}

class RegisterFields extends StatefulWidget {
  const RegisterFields({Key? key}) : super(key: key);

  @override
  State<RegisterFields> createState() => _RegisterFieldsState();
}

class _RegisterFieldsState extends State<RegisterFields> {
  bool isSignScreen = true;
  bool isPasswordVisible = false;
  bool isLoading = false;
  bool hasEmailEntered = false;
  bool hasPasswordEntered = false;
  bool hasUserNameEntered = false;

  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  final usernameTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    emailTextController.addListener(_updateButtonState);
    passwordTextController.addListener(_updateButtonState);
    usernameTextController.addListener(_updateButtonState);
  }

  void _updateButtonState() {
    setState(() {
      hasEmailEntered = emailTextController.text.trim().isNotEmpty;
      hasPasswordEntered = passwordTextController.text.trim().isNotEmpty;
      hasUserNameEntered =
          isSignScreen ? usernameTextController.text.trim().isNotEmpty : true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final horizontalMargin = max(constraints.maxWidth * 0.1, 16.0);

      return Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _buildWelcomeText(),
          const SizedBox(height: 10),
          _buildAppLogo(),
          const SizedBox(height: 20),
          _buildTextField(
            controller: emailTextController,
            labelText: 'Email',
            icon: Icons.email,
            horizontalMargin: horizontalMargin,
          ),
          const SizedBox(height: 20),
          if (isSignScreen) ...[
            _buildTextField(
              controller: usernameTextController,
              labelText: 'Username',
              icon: Icons.person,
              horizontalMargin: horizontalMargin,
            ),
            const SizedBox(height: 20),
          ],
          _buildPasswordField(horizontalMargin: horizontalMargin),
          const SizedBox(height: 20),
          _buildActionButton(context, horizontalMargin: horizontalMargin),
          const SizedBox(height: 20),
          _buildSwitchScreenText(),
        ],
      );
    });
  }

  Widget _buildWelcomeText() {
    return Text(
      isSignScreen ? "Welcome to app version tracker" : "Welcome back",
      style: ShadTheme.of(context).textTheme.h3,
      textAlign: TextAlign.center,
    );
  }

  Widget _buildAppLogo() {
    return SvgPicture.asset(
      'assets/images/logo_svg.svg',
      fit: BoxFit.contain,
      width: 100,
      height: 100,
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    required double horizontalMargin,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: horizontalMargin),
      child: ShadInput(
        placeholder: Text(labelText),
        controller: controller,
        keyboardType: TextInputType.emailAddress,
      ),
    );
  }

  Widget _buildPasswordField({required double horizontalMargin}) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: horizontalMargin),
      child: ShadInput(
        placeholder: const Text('Password'),
        controller: passwordTextController,
        obscureText: !isPasswordVisible,
        textInputAction: TextInputAction.done,
        keyboardType: TextInputType.visiblePassword,
      ),
    );
  }

  void _togglePasswordVisibility() {
    setState(() {
      isPasswordVisible = !isPasswordVisible;
    });
  }

  Widget _buildActionButton(BuildContext context,
      {required double horizontalMargin}) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: horizontalMargin, vertical: 20),
      width: double.infinity,
      child: ShadButton(
        enabled: !isLoading &&
            hasEmailEntered &&
            hasPasswordEntered &&
            hasUserNameEntered,
        onPressed: _handleActionButtonPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isLoading)
              SizedBox.square(
                dimension: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: ShadTheme.of(context).colorScheme.primaryForeground,
                ),
              ),
            if (isLoading) const SizedBox(width: 5),
            Text(isSignScreen ? "Register" : "Sign In"),
          ],
        ),
      ),
    );
  }

  Future<void> _handleActionButtonPressed() async {
    setState(() {
      isLoading = true;
    });

    final user = User(
      emailId: emailTextController.text,
      password: passwordTextController.text,
      userName: usernameTextController.text,
    ).toJson();

    final response = isSignScreen
        ? await BaseClient()
            .registerUser(user)
            .catchError((error) => print(error))
        : await BaseClient()
            .loginUser(user)
            .catchError((error) => print(error));

    _handleResponse(response);
  }

  void _handleResponse(dynamic response) {
    setState(() {
      isLoading = false;
    });
    if (response is User) {
      _saveUserCredentials(response);
      _navigateToHomePage();
    } else {
      // ShadAlert.destructive(
      //   iconSrc: LucideIcons.circleAlert,
      //   title: Text(response),
      //   );
      ErrorToast.show(context, response);
     
    }
  }

  void _saveUserCredentials(User user) {
    SharedPreferencesHelper.setUsername(user.emailId!);
    SharedPreferencesHelper.setJWTToken(user.token!);
    SharedPreferencesHelper.setAPIKey(user.apiKey!);
  }

  void _navigateToHomePage() {
    context.go('/home');
  }

  Widget _buildSwitchScreenText() {
    return Center(
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        alignment: WrapAlignment.center,
        children: [
          Text(isSignScreen
              ? "Already have an account?"
              : "Don't have an account?"),
          const SizedBox(width: 5),
          InkWell(
            onTap: _toggleSignScreen,
            child: Text(
              isSignScreen ? "Sign in" : "Create an account",
              style: const TextStyle(decoration: TextDecoration.underline),
            ),
          ),
        ],
      ),
    );
  }

  void _toggleSignScreen() {
    setState(() {
      isSignScreen = !isSignScreen;
      emailTextController.clear();
      passwordTextController.clear();
      usernameTextController.clear();
      hasEmailEntered = false;
      hasPasswordEntered = false;
      hasUserNameEntered = isSignScreen ? false : true;
    });
  }
}
