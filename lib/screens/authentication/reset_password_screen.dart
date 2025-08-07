// reset_password_screen.dart
// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:hiringmanagementsystem/widgets/auth_layout.dart';
import 'package:hiringmanagementsystem/widgets/custom_button.dart';
import 'package:hiringmanagementsystem/widgets/custom_text_field.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _passwordFocusNode = FocusNode();
  final _confirmPasswordFocusNode = FocusNode();
  bool _isLoading = false;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleResetPassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      await Future.delayed(const Duration(seconds: 2));

      // Handle password reset logic here

      setState(() => _isLoading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password reset successfully!')),
      );

      Navigator.pop(context); // Return to previous screen
    }
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Password is required';
    if (value.length < 6) return 'Password must be at least 6 characters';
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) return 'Please confirm your password';
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return AuthLayout(
      desktopTitle: 'Reset Password',
      desktopSubtitle: 'Set a new password for your account.',
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Reset Password Icon
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
                    Icons.lock_reset_outlined,
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

            // New Password Field
            CustomTextField(
              label: 'New Password',
              hintText: 'Enter new password',
              controller: _passwordController,
              focusNode: _passwordFocusNode,
              nextFocusNode: _confirmPasswordFocusNode,
              validator: _validatePassword,
              isPassword: true,
              prefixIcon: Icons.lock_outline,
            ),
            const SizedBox(height: 20),

            // Confirm Password Field
            CustomTextField(
              label: 'Confirm Password',
              hintText: 'Re-enter new password',
              isPassword: true,
              controller: _confirmPasswordController,
              focusNode: _confirmPasswordFocusNode,
              validator: _validateConfirmPassword,
              prefixIcon: Icons.lock_outline,
              onSubmitted: _handleResetPassword,
            ),
            const SizedBox(height: 32),

            // Reset Password Button
            CustomButton(
              text: 'Reset Password',
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
