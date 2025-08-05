import 'package:flutter/material.dart';
import 'package:hiringmanagementsystem/core/theme.dart';
import 'package:hiringmanagementsystem/screens/authentication/login_screen.dart';
import 'package:hiringmanagementsystem/screens/authentication/otp_verification_screen.dart';
import 'package:hiringmanagementsystem/providers/auth_provider.dart';
import 'package:hiringmanagementsystem/screens/authentication/verification_completed_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        // Add more providers here as needed, e.g.:
        // ChangeNotifierProvider(create: (context) => OtherProvider()),
      ],
      child: MaterialApp(
        title: 'Visa Booking System',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        home: const VerificationCompletedScreen(),
        routes: {
          '/login': (context) => const LoginScreen(),
          '/otp': (context) => const OtpVerificationScreen(),
          '/verification-completed': (context) =>
              const VerificationCompletedScreen(),
          // Add other routes as needed, e.g., '/dashboard': (context) => const DashboardScreen(),
        },
      ),
    );
  }
}
