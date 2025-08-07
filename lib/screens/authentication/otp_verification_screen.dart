// otp_verification_screen.dart - REFACTORED
// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hiringmanagementsystem/providers/auth_provider.dart';
import 'package:hiringmanagementsystem/widgets/auth_layout.dart';
import 'package:hiringmanagementsystem/screens/authentication/verification_completed_screen.dart';
import 'package:pinput/pinput.dart';
import 'package:hiringmanagementsystem/widgets/custom_button.dart';
import 'package:provider/provider.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String? email;
  final String? phone;

  const OtpVerificationScreen({super.key, this.email, this.phone});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen>
    with TickerProviderStateMixin {
  late final TextEditingController _pinController;
  late final FocusNode _pinFocusNode;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _pinController = TextEditingController();
    _pinFocusNode = FocusNode();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      authProvider.setUserContact(
        email: widget.email ?? '',
        phone: widget.phone,
      );
      _animationController.forward();
      _pinFocusNode.requestFocus(); // Auto-focus on OTP field
    });
  }

  @override
  void dispose() {
    _pinController.dispose();
    _pinFocusNode.dispose();
    _animationController.dispose();
    super.dispose();
  }

  PinTheme get _pinTheme => PinTheme(
        width: 56,
        height: 56,
        textStyle: const TextStyle(
          fontSize: 22,
          color: Color(0xFF1F2937),
          fontWeight: FontWeight.w600,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFFF9FAFB),
          border: Border.all(color: const Color(0xFFE5E7EB)),
          borderRadius: BorderRadius.circular(12),
        ),
      );

  PinTheme get _focusedPinTheme => _pinTheme.copyWith(
        decoration: _pinTheme.decoration!.copyWith(
          border: Border.all(color: const Color(0xFFF97316), width: 2),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFF97316).withAlpha((0.1 * 255).toInt()),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
      );

  PinTheme get _submittedPinTheme => _pinTheme.copyWith(
        decoration: _pinTheme.decoration!.copyWith(
          color: const Color(0xFFF97316).withAlpha((0.1 * 255).toInt()),
          border: Border.all(color: const Color(0xFFF97316)),
        ),
      );

  PinTheme get _errorPinTheme => _pinTheme.copyWith(
        decoration: _pinTheme.decoration!.copyWith(
          border: Border.all(color: const Color(0xFFEF4444), width: 2),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFEF4444).withAlpha((0.1 * 255).toInt()),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
      );

  void _handleOtpComplete(String pin) {
    Provider.of<AuthProvider>(context, listen: false).setOtpCode(pin);
    _handleVerifyOtp(); // Auto-submit when OTP is complete
  }

  Future<void> _handleVerifyOtp() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (authProvider.otpCode.length != 6) return;

    _pinFocusNode.unfocus(); // Hide keyboard during verification
    if (await authProvider.verifyOtp()) {
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const VerificationCompletedScreen(),
          ),
        );
      }
    } else {
      _pinFocusNode.requestFocus(); // Return focus if verification fails
    }
  }

  Future<void> _handleResendOtp() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (await authProvider.resendOtp()) {
      _pinController.clear();
      _pinFocusNode.requestFocus(); // Return focus after resend
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('OTP sent successfully!'),
            backgroundColor: Color(0xFF10B981),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthLayout(
      desktopTitle: 'Verify your OTP',
      desktopSubtitle:
          'Enter the OTP sent to your registered email to verify your identity for secure access.',
      showBackButton: true,
      child: ScaleTransition(
        scale: _animation,
        child: Consumer<AuthProvider>(
          builder: (context, authProvider, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon
                Container(
                  width: 60,
                  height: 60,
                  decoration: const BoxDecoration(
                    color: Color(0xFFF6F8FB),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.lock_outline,
                    color: Colors.black,
                    size: 30,
                  ),
                ),
                const SizedBox(height: 24),

                // Title
                const Text(
                  'Verify OTP',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F2937),
                  ),
                ),
                const SizedBox(height: 8),

                // Description with contact info
                Text(
                  'Enter the OTP sent to your registered ${authProvider.getContactType()} to verify your identity for secure access.',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF6B7280),
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),

                if (authProvider.getMaskedContact().isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      authProvider.getMaskedContact(),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF374151),
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 32),

                // PIN Input
                Pinput(
                  controller: _pinController,
                  focusNode: _pinFocusNode,
                  length: 6,
                  defaultPinTheme: _pinTheme,
                  focusedPinTheme: _focusedPinTheme,
                  submittedPinTheme: _submittedPinTheme,
                  errorPinTheme: _errorPinTheme,
                  pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                  showCursor: true,
                  onCompleted: _handleOtpComplete,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  onChanged: (value) => authProvider.setOtpCode(value),
                  cursor: Container(
                    width: 2,
                    height: 24,
                    decoration: const BoxDecoration(
                      color: Color(0xFFF97316),
                      borderRadius: BorderRadius.all(
                        Radius.circular(1),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Error message
                if (authProvider.errorMessage != null) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEF2F2),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: const Color(0xFFEF4444)
                            .withAlpha((0.2 * 255).toInt()),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 16,
                          color: Color(0xFFEF4444),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            authProvider.errorMessage!,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFFEF4444),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // Resend OTP
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Didn't receive the OTP? ",
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                    if (authProvider.canResend)
                      GestureDetector(
                        onTap: authProvider.isLoading ? null : _handleResendOtp,
                        child: Text(
                          'Resend OTP',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: authProvider.isLoading
                                ? const Color(0xFF9CA3AF)
                                : const Color(0xFFF97316),
                          ),
                        ),
                      )
                    else
                      Text(
                        'Resend in ${authProvider.resendTimer}s',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF9CA3AF),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 32),

                // Verify button
                CustomButton(
                  text: 'Verify OTP',
                  onPressed: _handleVerifyOtp,
                  isLoading: authProvider.isLoading,
                  borderRadius: 20,
                  backgroundColor: authProvider.otpCode.length == 6
                      ? const Color(0xFFF97316)
                      : const Color(0xFF9CA3AF),
                ),
                const SizedBox(height: 16),

                // Back to login
                TextButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(
                    Icons.arrow_back,
                    size: 16,
                    color: Color(0xFF6B7280),
                  ),
                  label: const Text(
                    'Back to Login',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
