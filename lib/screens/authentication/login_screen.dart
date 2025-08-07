// login_screen.dart - REFACTORED
// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:hiringmanagementsystem/screens/authentication/forgot_password_screen.dart';
import 'package:hiringmanagementsystem/screens/authentication/otp_verification_screen.dart';
import 'package:hiringmanagementsystem/widgets/auth_layout.dart';
import 'package:hiringmanagementsystem/widgets/custom_button.dart';
import 'package:hiringmanagementsystem/widgets/custom_check_box.dart';
import 'package:hiringmanagementsystem/widgets/custom_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  bool _keepMeLoggedIn = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleSignIn() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      await Future.delayed(const Duration(seconds: 2));

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const OtpVerificationScreen(
            email: 'farhanshakoor@gmail.com',
            phone: '1234567890',
          ),
        ),
      );

      setState(() => _isLoading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login Successful!')),
      );
    }
  }

  void _navigateToForgotPassword() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ForgotPasswordScreen(),
      ),
    );
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Email is required';
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Password is required';
    if (value.length < 6) return 'Password must be at least 6 characters';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return AuthLayout(
      desktopTitle: 'Welcome!',
      desktopSubtitle:
          'Log in to simplify hiring and streamline financial operations.',
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Login Icon
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 45,
                  height: 45,
                  decoration: const BoxDecoration(
                    color: Color(0xFFF6F8FB),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.login_outlined,
                    color: Colors.black,
                    size: 20,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Title
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Sign In to your Account',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F2937),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Email Field
            CustomTextField(
              label: 'Email',
              hintText: 'example@gmail.com',
              controller: _emailController,
              focusNode: _emailFocusNode,
              nextFocusNode: _passwordFocusNode,
              validator: _validateEmail,
              keyboardType: TextInputType.emailAddress,
              prefixIcon: Icons.email_outlined,
            ),
            const SizedBox(height: 20),

            // Password Field
            CustomTextField(
              label: 'Password',
              hintText: 'Password',
              isPassword: true,
              controller: _passwordController,
              focusNode: _passwordFocusNode,
              validator: _validatePassword,
              prefixIcon: Icons.lock_outline,
              onSubmitted: _handleSignIn,
            ),
            const SizedBox(height: 16),

            // Keep me logged in & Forgot Password
            Row(
              children: [
                Expanded(
                  child: CustomCheckbox(
                    value: _keepMeLoggedIn,
                    onChanged: (value) {
                      setState(() {
                        _keepMeLoggedIn = value ?? false;
                      });
                    },
                    text: 'Keep me Logged in',
                  ),
                ),
                GestureDetector(
                  onTap: _navigateToForgotPassword,
                  child: const Text(
                    'Forgot Password?',
                    style: TextStyle(
                      color: Color.fromARGB(255, 255, 0, 0),
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Sign In Button
            CustomButton(
              text: 'Sign In',
              onPressed: _handleSignIn,
              isLoading: _isLoading,
              borderRadius: 20,
            ),
          ],
        ),
      ),
    );
  }
}
