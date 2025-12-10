import 'package:flutter/material.dart';
import '../theme/theme_data.dart';
import '../components/form_fields.dart';
import '../components/buttons.dart';
import '../components/animations.dart';
import 'login.dart';
import '../services/auth_service.dart';
import 'package:appwrite/appwrite.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'main_wrapper.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  bool _isPasswordObscured = true;
  bool _isConfirmPasswordObscured = true;
  XFile? _avatar;

  void _onSignUpPressed() async {
    try {
      final fullName = nameController.text.trim();
      final email = emailController.text.trim();
      final password = passwordController.text.trim();
      final confirm = confirmPasswordController.text.trim();
      await AuthService().signUp(
        fullName,
        email,
        password,
        confirm,
        avatarPath: _avatar?.path,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Akun berhasil dibuat!')));
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const MainWrapper(initialIndex: 2)),
        (route) => false,
      );
    } on AppwriteException catch (e) {
      if (!mounted) return;
      if (e.code == 409) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Akun sudah ada, silakan login')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.message ?? e.toString())));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  Future<void> _pickAvatar() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (picked != null) {
      setState(() => _avatar = picked);
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
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundImage: (_avatar != null)
                          ? Image.file(File(_avatar!.path)).image
                          : null,
                      child: _avatar == null ? const Icon(Icons.person) : null,
                    ),
                    const SizedBox(width: 12),
                    OutlinedButton(
                      onPressed: _pickAvatar,
                      child: const Text('Choose Photo (Optional)'),
                    ),
                  ],
                ),
              ),
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
                  obscureText: _isPasswordObscured,
                  onToggleObscure: () => setState(
                    () => _isPasswordObscured = !_isPasswordObscured,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              FadeIn(
                child: TextInputField(
                  label: 'Confirm Password',
                  hintText: 'Re-enter your password',
                  controller: confirmPasswordController,
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: _isConfirmPasswordObscured,
                  onToggleObscure: () => setState(
                    () => _isConfirmPasswordObscured =
                        !_isConfirmPasswordObscured,
                  ),
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
