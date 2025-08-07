// forgot_password_screen.dart - REFACTORED
// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:hiringmanagementsystem/screens/authentication/otp_verification_screen.dart';
import 'package:hiringmanagementsystem/widgets/auth_layout.dart';
import 'package:hiringmanagementsystem/widgets/custom_button.dart';
import 'package:hiringmanagementsystem/widgets/custom_text_field.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _emailFocusNode = FocusNode();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _emailFocusNode.dispose();
    super.dispose();
  }

  void _handleResetPassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const OtpVerificationScreen(),
        ),
      );

      setState(() => _isLoading = false);
    }
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Email is required';
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return AuthLayout(
      desktopTitle: 'Forgot Password?',
      desktopSubtitle: 'Enter your email to reset your password.',
      showBackButton: true,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon
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
                    Icons.lock_reset,
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
                  'Reset Your Password',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F2937),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Email field
            CustomTextField(
              label: 'Email',
              hintText: 'example@gmail.com',
              controller: _emailController,
              focusNode: _emailFocusNode,
              validator: _validateEmail,
              keyboardType: TextInputType.emailAddress,
              prefixIcon: Icons.email_outlined,
              onSubmitted: _handleResetPassword, // Added submit on enter
            ),
            const SizedBox(height: 24),

            // Reset button
            CustomButton(
              text: 'Send',
              onPressed: _handleResetPassword,
              isLoading: _isLoading,
              borderRadius: 20,
            ),
          ],
        ),
      ),
    );
  }
}
