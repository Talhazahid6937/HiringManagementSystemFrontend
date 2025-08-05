import 'package:flutter/material.dart';
import 'dart:async';

class AuthProvider extends ChangeNotifier {
  // OTP related properties
  String _otpCode = '';
  bool _isLoading = false;
  bool _isVerificationComplete = false;
  String? _errorMessage;
  int _resendTimer = 0;
  Timer? _timer;

  // User data
  String _userEmail = '';
  String _userPhone = '';

  // Getters
  String get otpCode => _otpCode;
  bool get isLoading => _isLoading;
  bool get isVerificationComplete => _isVerificationComplete;
  String? get errorMessage => _errorMessage;
  int get resendTimer => _resendTimer;
  bool get canResend => _resendTimer == 0;
  String get userEmail => _userEmail;
  String get userPhone => _userPhone;

  // Set user contact info
  void setUserContact({required String email, String? phone}) {
    _userEmail = email;
    _userPhone = phone ?? '';
    notifyListeners();
  }

  // Set OTP code
  void setOtpCode(String code) {
    _otpCode = code;
    _errorMessage = null; // Clear error when user types
    notifyListeners();
  }

  // Clear OTP
  void clearOtp() {
    _otpCode = '';
    _errorMessage = null;
    notifyListeners();
  }

  // Set loading state
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // Set error message
  void _setError(String? error) {
    _errorMessage = error;
    notifyListeners();
  }

  // Start resend timer
  void _startResendTimer() {
    _resendTimer = 60; // 60 seconds
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendTimer > 0) {
        _resendTimer--;
        notifyListeners();
      } else {
        timer.cancel();
      }
    });
  }

  // Verify OTP
  Future<bool> verifyOtp() async {
    if (_otpCode.length != 6) {
      _setError('Please enter complete OTP');
      return false;
    }

    _setLoading(true);
    _setError(null);

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // Simulate verification logic
      // In real app, you would call your API here
      if (_otpCode == '123456') {
        _isVerificationComplete = true;
        _setLoading(false);
        return true;
      } else {
        _setError('Invalid OTP. Please try again.');
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _setError('Verification failed. Please try again.');
      _setLoading(false);
      return false;
    }
  }

  // Resend OTP
  Future<bool> resendOtp() async {
    if (!canResend) {
      _setError('Please wait before requesting another OTP');
      return false;
    }

    _setLoading(true);
    _setError(null);

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      // In real app, you would call your resend OTP API here
      // _clearOtp();
      _startResendTimer();
      _setLoading(false);

      return true;
    } catch (e) {
      _setError('Failed to resend OTP. Please try again.');
      _setLoading(false);
      return false;
    }
  }

  // Send initial OTP
  Future<bool> sendOtp({required String contact, required String type}) async {
    _setLoading(true);
    _setError(null);

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      // Set contact based on type
      if (type == 'email') {
        _userEmail = contact;
      } else {
        _userPhone = contact;
      }

      _startResendTimer();
      _setLoading(false);

      return true;
    } catch (e) {
      _setError('Failed to send OTP. Please try again.');
      _setLoading(false);
      return false;
    }
  }

  // Reset verification state
  void resetVerification() {
    _otpCode = '';
    _isLoading = false;
    _isVerificationComplete = false;
    _errorMessage = null;
    _resendTimer = 0;
    _timer?.cancel();
    notifyListeners();
  }

  // Helper method to get masked contact
  String getMaskedContact() {
    if (_userEmail.isNotEmpty) {
      return _maskEmail(_userEmail);
    } else if (_userPhone.isNotEmpty) {
      return _maskPhone(_userPhone);
    }
    return '';
  }

  // Helper method to get contact type
  String getContactType() {
    if (_userEmail.isNotEmpty) {
      return 'email';
    } else if (_userPhone.isNotEmpty) {
      return 'phone';
    }
    return 'contact';
  }

  // Mask email for display
  String _maskEmail(String email) {
    if (email.isEmpty) return '';

    final parts = email.split('@');
    if (parts.length != 2) return email;

    final username = parts[0];
    final domain = parts[1];

    if (username.length <= 2) return email;

    final maskedUsername =
        username[0] +
        '*' * (username.length - 2) +
        username[username.length - 1];

    return '$maskedUsername@$domain';
  }

  // Mask phone for display
  String _maskPhone(String phone) {
    if (phone.isEmpty || phone.length < 4) return phone;

    return phone.substring(0, 2) +
        '*' * (phone.length - 4) +
        phone.substring(phone.length - 2);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
