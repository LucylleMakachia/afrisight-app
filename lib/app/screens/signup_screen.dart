import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_storage/get_storage.dart';
import '../routes/app_routes.dart';
import '../controllers/profile_controller.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void showToast(String message, {bool isError = false}) {
    Fluttertoast.showToast(
      msg: message,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: isError ? Colors.red.shade600 : Colors.green.shade600,
      textColor: Colors.white,
      fontSize: 16,
      toastLength: Toast.LENGTH_LONG,
    );
  }

  Future<void> signUp() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (name.isEmpty) {
      showToast('Please enter your name', isError: true);
      return;
    }
    if (email.isEmpty) {
      showToast('Please enter your email', isError: true);
      return;
    }

    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(email)) {
      showToast('Enter a valid email', isError: true);
      return;
    }

    if (password.isEmpty) {
      showToast('Please enter your password', isError: true);
      return;
    }
    if (password.length < 6) {
      showToast('Password must be at least 6 characters', isError: true);
      return;
    }
    if (password != confirmPassword) {
      showToast('Passwords do not match', isError: true);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final box = GetStorage();
    List<String> registeredEmails = box.read<List>('registeredEmails')?.cast<String>() ?? [];

    if (registeredEmails.contains(email)) {
      setState(() {
        _isLoading = false;
      });
      showToast('User already exists. Please sign in.', isError: true);
      Get.offNamed(Routes.signin);
      return;
    }

    final ProfileController profileController = Get.find<ProfileController>();

    final nameParts = name.split(' ');
    final firstName = nameParts.isNotEmpty ? nameParts.first : '';
    final lastName = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';

    profileController.user.update((val) {
      val?.firstName = firstName;
      val?.lastName = lastName;
      val?.email = email;
    });

    await profileController.saveUserData();
    await profileController.refreshUserData();

    registeredEmails.add(email);
    box.write('registeredEmails', registeredEmails);
    box.write('isLoggedIn', true);

    setState(() {
      _isLoading = false;
    });

    showToast('Sign up successful! Welcome, $name!');
    Get.offNamed(Routes.home);
  }

  void onGoogleSignUp() => showToast('Google sign-up not implemented', isError: true);
  void onAppleSignUp() => showToast('Apple sign-up not implemented', isError: true);
  void onXSignUp() => showToast('X sign-up not implemented', isError: true);
  void goToSignIn() => Get.back();

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
        title: const Text('Sign Up'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                textCapitalization: TextCapitalization.words,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Password'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: confirmPasswordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Confirm Password'),
              ),
              const SizedBox(height: 24),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: signUp,
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Theme.of(context).primaryColor,
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                        minimumSize: const Size(double.infinity, 48),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text('Sign Up'),
                    ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: goToSignIn,
                child: const Text("Already have an account? Sign In"),
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                icon: Image.asset(
                  'assets/icons/google_logo.png',
                  height: 24,
                  width: 24,
                ),
                label: const Text('Sign up with Google'),
                onPressed: onGoogleSignUp,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
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
                label: const Text('Sign up with Apple'),
                onPressed: onAppleSignUp,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                icon: const Icon(Icons.login),
                label: const Text('Sign up with X'),
                onPressed: onXSignUp,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey.shade900,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 48),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
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