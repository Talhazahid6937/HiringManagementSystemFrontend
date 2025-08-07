// verification_completed_screen.dart - REFACTORED
import 'package:flutter/material.dart';
import 'package:hiringmanagementsystem/widgets/auth_layout.dart';

class VerificationCompletedScreen extends StatelessWidget {
  const VerificationCompletedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthLayout(
      desktopTitle: 'Verification Completed!',
      desktopSubtitle:
          'Logged in successfully. Streamline recruitment and finance today.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: const BoxDecoration(
              color: Color(0xFFF6F8FB),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_circle_outlined,
              color: Color(0xFF10B981),
              size: 30,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'OTP Verified!',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Congratulations! Your OTP has been successfully verified.',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF6B7280),
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
