import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_storage/get_storage.dart';
import '../routes/app_routes.dart';
import '../controllers/profile_controller.dart';

class SignInScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  SignInScreen({super.key});

  Future<void> signIn() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showStyledToast("Email and password cannot be empty", isError: true);
      return;
    }

    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(email)) {
      _showStyledToast("Please enter a valid email address", isError: true);
      return;
    }

    final box = GetStorage();
    final registeredUsers = box.read<List>('registeredEmails')?.cast<String>() ?? [];

    if (!registeredUsers.contains(email)) {
      _showStyledToast(
        "User not registered. Redirecting to Sign Up...",
        isError: true,
      );
      await Future.delayed(const Duration(seconds: 1));
      Get.offNamed(Routes.signup);
      return;
    }

    final ProfileController profileController = Get.find<ProfileController>();
    
    await profileController.loadUserData();
    
    if (profileController.user.value.email.isNotEmpty && 
        profileController.user.value.email != email) {
      _showStyledToast("User data mismatch. Please try again.", isError: true);
      return;
    }

    box.write('isLoggedIn', true);
    
    final userName = profileController.user.value.firstName.isNotEmpty 
        ? profileController.user.value.firstName 
        : "User";
    _showStyledToast("Welcome back, $userName!", isError: false);
    
    Get.offNamed(Routes.home);
  }

  void _showStyledToast(String message, {required bool isError}) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      backgroundColor: isError ? Colors.red.shade600 : Colors.green.shade600,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  void goToSignUp() {
    Get.toNamed(Routes.signup);
  }

  void onGoogleSignIn() {
    _showStyledToast("Google sign-in not implemented", isError: true);
  }

  void onAppleSignIn() {
    _showStyledToast("Apple sign-in not implemented", isError: true);
  }

  void onXSignIn() {
    _showStyledToast("X sign-in not implemented", isError: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            'assets/images/mosaic_logo.png',
            height: 32,
            width: 32,
            fit: BoxFit.contain,
          ),
        ),
        title: const Text('Sign In'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.lock),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: signIn,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Theme.of(context).primaryColor,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text(
                  'Sign In',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () {
                  _showStyledToast("Forgot Password not implemented", isError: true);
                },
                child: const Text("Forgot Password?"),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: goToSignUp,
                child: const Text("Don't have an account? Sign Up"),
              ),
              const SizedBox(height: 32),
              const Text(
                'Or sign in with',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                icon: Image.asset(
                  'assets/icons/google_logo.png',
                  height: 24,
                  width: 24,
                ),
                label: const Text(
                  'Continue with Google',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                onPressed: onGoogleSignIn,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue,
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                icon: Image.asset(
                  'assets/icons/apple_logo.png',
                  height: 24,
                  width: 24,
                ),
                label: const Text(
                  'Continue with Apple',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                onPressed: onAppleSignIn,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.black,
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                icon: const Icon(Icons.login, color: Colors.white),
                label: const Text(
                  'Sign in with X',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
                onPressed: onXSignIn,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}