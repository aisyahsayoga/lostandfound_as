import 'package:flutter/material.dart';
import '../theme/theme_data.dart';
import '../components/form_fields.dart';
import '../components/buttons.dart';
import '../components/animations.dart';
import '../services/auth_service.dart';
import 'login.dart';
import 'demo_home.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  void _onSignUpPressed() async {
    try {
      final success = await AuthService().signUp(
        nameController.text,
        emailController.text,
        passwordController.text,
        confirmPasswordController.text,
      );

      if (success) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Akun berhasil dibuat!')),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const DemoHomeScreen()),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }

  void _onLoginPressed() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
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
                  'Create Account',
                  style: appThemeData.textTheme.headlineLarge,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 24),
              FadeIn(
                child: TextInputField(
                  label: 'Full Name',
                  hintText: 'Your full name',
                  controller: nameController,
                ),
              ),
              const SizedBox(height: 20),
              FadeIn(
                child: TextInputField(
                  label: 'Email',
                  hintText: 'your.email@example.com',
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                ),
              ),
              const SizedBox(height: 20),
              FadeIn(
                child: TextInputField(
                  label: 'Password',
                  hintText: 'Create a password',
                  controller: passwordController,
                  keyboardType: TextInputType.visiblePassword,
                ),
              ),
              const SizedBox(height: 20),
              FadeIn(
                child: TextInputField(
                  label: 'Confirm Password',
                  hintText: 'Re-enter your password',
                  controller: confirmPasswordController,
                  keyboardType: TextInputType.visiblePassword,
                ),
              ),
              const SizedBox(height: 32),
              FadeIn(
                child: PrimaryButton(
                  label: 'Sign Up',
                  onPressed: _onSignUpPressed,
                ),
              ),
              const SizedBox(height: 16),
              FadeIn(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account?",
                      style: appThemeData.textTheme.bodyMedium,
                    ),
                    TextButton(
                      onPressed: _onLoginPressed,
                      child: Text(
                        'Login',
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
