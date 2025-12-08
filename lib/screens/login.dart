import 'package:flutter/material.dart';
import '../components/buttons.dart';
import '../components/form_fields.dart';
import '../components/animations.dart';
import '../theme/theme_data.dart';
import '../theme/typography.dart';
import '../services/auth_service.dart';
import 'item_list_screen.dart';
import 'sign_up.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isPasswordObscured = true;

  void _onLoginPressed() async {
    try {
      final success = await AuthService().login(
        emailController.text,
        passwordController.text,
      );

      if (success) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Login berhasil!')));
          Navigator.of(context).pop();
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  void _onSignUpPressed() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => SignUpScreen()),
    );
  }

  void _onForgotPasswordPressed() {
    // TODO: Implement forgot password flow
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appThemeData.scaffoldBackgroundColor,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FadeIn(
                child: Text(
                  'Welcome Back',
                  style: appThemeData.textTheme.displayLarge,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 16),
              FadeIn(
                child: Text(
                  'Please login to your account',
                  style: AppTypography.bodyText1,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 40),
              FadeIn(
                child: TextInputField(
                  label: 'Email',
                  hintText: 'your.email@example.com',
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                ),
              ),
              const SizedBox(height: 24),
              FadeIn(
                child: TextInputField(
                  label: 'Password',
                  hintText: 'Enter your password',
                  controller: passwordController,
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: _isPasswordObscured,
                  onToggleObscure: () => setState(
                    () => _isPasswordObscured = !_isPasswordObscured,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              FadeIn(
                child: PrimaryButton(
                  label: 'Login',
                  onPressed: _onLoginPressed,
                ),
              ),
              const SizedBox(height: 16),
              FadeIn(
                child: TextButton(
                  onPressed: _onForgotPasswordPressed,
                  child: Text(
                    'Forgot password?',
                    style: appThemeData.textTheme.bodyMedium!.copyWith(
                      color: appThemeData.colorScheme.primary,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              FadeIn(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account?",
                      style: AppTypography.bodyText2,
                    ),
                    TextButton(
                      onPressed: _onSignUpPressed,
                      child: Text(
                        'Sign Up',
                        style: appThemeData.textTheme.bodyMedium!.copyWith(
                          color: appThemeData.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
