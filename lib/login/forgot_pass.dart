import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_page.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _otpSent = false;
  bool _otpVerified = false;
  String? _verificationId;

  Future<void> _sendOTP() async {
    String email = _emailController.text.trim();
    if (email.isEmpty) {
      _showMessage("Please enter your email");
      return;
    }

    try {
      // Attempt to sign in with a fake password to check if the email exists
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: "wrong_password",
      );
    } on FirebaseAuthException catch (e) {
      debugPrint("FirebaseAuthException Code: ${e.code}"); // Debugging
      debugPrint("FirebaseAuthException Message: ${e.message}");

      // If the error is due to a wrong password, it means the email exists
      if (e.code == 'wrong-password' || e.code == 'user-not-found') {
        if (e.code == 'user-not-found') {
          _showMessage("Email not registered");
        } else {
          // Email exists, proceed with sending the password reset email
          await _auth.sendPasswordResetEmail(email: email);
          _showMessage("Password reset email sent. Check your inbox.");

          setState(() {
            _otpSent = true;
          });
        }
      } else if (e.code == 'invalid-email') {
        _showMessage("Invalid email format");
      } else {
        _showMessage("Error: ${e.message}");
      }
    } catch (e) {
      debugPrint("Unexpected Error: $e"); // Debugging
      _showMessage("An unexpected error occurred: $e");
    }
  }

  Future<void> _verifyOTP() async {
    if (_otpController.text == _verificationId) {
      setState(() {
        _otpVerified = true;
      });
      _showMessage("OTP Verified");
    } else {
      _showMessage("Incorrect OTP");
    }
  }

  Future<void> _resetPassword() async {
    if (_newPasswordController.text != _confirmPasswordController.text) {
      _showMessage("Passwords do not match");
      return;
    }

    try {
      await _auth.confirmPasswordReset(
        code: _verificationId!,
        newPassword: _newPasswordController.text.trim(),
      );
      _showMessage("Password reset successful");

      Navigator.pushReplacement(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    } catch (e) {
      _showMessage("Error: $e");
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Forgot Password")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: "Enter Email"),
            ),
            const SizedBox(height: 15),
            if (!_otpSent)
              ElevatedButton(
                onPressed: _sendOTP,
                child: const Text("Continue"),
              ),
            if (_otpSent && !_otpVerified) ...[
              TextField(
                controller: _otpController,
                decoration: const InputDecoration(labelText: "Enter OTP"),
              ),
              const SizedBox(height: 15),
              ElevatedButton(
                onPressed: _verifyOTP,
                child: const Text("Verify OTP"),
              ),
            ],
            if (_otpVerified) ...[
              TextField(
                controller: _newPasswordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: "New Password"),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Confirm New Password",
                ),
              ),
              const SizedBox(height: 15),
              ElevatedButton(
                onPressed: _resetPassword,
                child: const Text("Reset Password"),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
