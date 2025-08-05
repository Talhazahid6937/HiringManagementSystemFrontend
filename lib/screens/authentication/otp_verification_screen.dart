// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:hiringmanagementsystem/providers/auth_provider.dart';
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
  late final FocusNode _focusNode;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _pinController = TextEditingController();
    _focusNode = FocusNode();
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
    });
  }

  @override
  void dispose() {
    _pinController.dispose();
    _focusNode.dispose();
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

  void _handleOtpComplete(String pin) =>
      Provider.of<AuthProvider>(context, listen: false).setOtpCode(pin);
  void _handleVerifyOtp() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (await authProvider.verifyOtp()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('OTP Verified Successfully!'),
          backgroundColor: Color(0xFF10B981),
        ),
      );
    }
  }

  void _handleResendOtp() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (await authProvider.resendOtp()) {
      _pinController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('OTP sent successfully!'),
          backgroundColor: Color(0xFF10B981),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isDesktop = screenSize.width > 768;
    final isMobile = screenSize.width < 480;
    final isTablet = screenSize.width >= 480 && screenSize.width <= 768;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFF3F4F6), Color(0xFFE5E7EB)],
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: -100,
              left: -100,
              child: Container(
                width: 300,
                height: 300,
                decoration: const BoxDecoration(
                  color: Color(0xFFF97316),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              bottom: -150,
              right: -150,
              child: Container(
                width: 400,
                height: 400,
                decoration: const BoxDecoration(
                  color: Color(0xFFF97316),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile
                        ? 24
                        : isTablet
                        ? 32
                        : 48,
                    vertical: 24,
                  ),
                  child: Row(
                    children: [
                      if (isDesktop) ...[
                        Expanded(
                          flex: 2,
                          child: Container(
                            padding: const EdgeInsets.all(48),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Text(
                                  'Verify your OTP',
                                  style: TextStyle(
                                    fontSize: 36,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1F2937),
                                  ),
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'Enter the OTP sent to your registered email to verify your identity for secure access.',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Color(0xFF6B7280),
                                    height: 1.5,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 48),
                      ],
                      Expanded(
                        flex: isDesktop ? 1 : 1,
                        child: ScaleTransition(
                          scale: _animation,
                          child: Container(
                            constraints: const BoxConstraints(maxWidth: 450),
                            padding: EdgeInsets.symmetric(
                              horizontal: isMobile ? 24 : 32,
                              vertical: 50,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(43),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withAlpha(
                                    (0.1 * 255).toInt(),
                                  ),
                                  blurRadius: 20,
                                  offset: Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Consumer<AuthProvider>(
                              builder: (context, authProvider, child) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
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
                                    const Text(
                                      'Verify OTP',
                                      style: TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF1F2937),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Enter the OTP sent to your registered ${authProvider.getContactType()} to verify your identity for secure access.',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Color(0xFF6B7280),
                                        height: 1.5,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    if (authProvider
                                        .getMaskedContact()
                                        .isNotEmpty) ...[
                                      const SizedBox(height: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFF3F4F6),
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
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
                                    Pinput(
                                      controller: _pinController,
                                      focusNode: _focusNode,
                                      length: 6,
                                      defaultPinTheme: _pinTheme,
                                      focusedPinTheme: _focusedPinTheme,
                                      submittedPinTheme: _submittedPinTheme,
                                      errorPinTheme: _errorPinTheme,
                                      pinputAutovalidateMode:
                                          PinputAutovalidateMode.onSubmit,
                                      showCursor: true,
                                      onCompleted: _handleOtpComplete,
                                      onChanged: (value) =>
                                          authProvider.setOtpCode(value),
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
                                    if (authProvider.errorMessage != null) ...[
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 8,
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFFEF2F2),
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          border: Border.all(
                                            color: const Color(
                                              0xFFEF4444,
                                            ).withAlpha((0.2 * 255).toInt()),
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
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                            onTap: authProvider.isLoading
                                                ? null
                                                : _handleResendOtp,
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
                                    CustomButton(
                                      text: 'Verify OTP',
                                      onPressed: _handleVerifyOtp,
                                      isLoading: authProvider.isLoading,
                                      borderRadius: 20,
                                      backgroundColor:
                                          authProvider.otpCode.length == 6
                                          ? const Color(0xFFF97316)
                                          : const Color(0xFF9CA3AF),
                                    ),
                                    const SizedBox(height: 16),
                                    TextButton.icon(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
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
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
