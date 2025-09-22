import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user.dart';

class ProfileController extends GetxController {
  final Rx<User> user = User.empty().obs;
  Rx<XFile?> profileImage = Rx<XFile?>(null);

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();

  final darkMode = false.obs;
  final notificationsEnabled = true.obs;

  final ImagePicker _picker = ImagePicker();
  Worker? _userChangeWorker;

  @override
  void onInit() async {
    super.onInit();
    await loadUserData();
    await loadAppSettings();

    _userChangeWorker = ever(user, (User updatedUser) {
      if (nameController.text != updatedUser.fullName) {
        nameController.text = updatedUser.fullName;
      }
      if (emailController.text != updatedUser.email) {
        emailController.text = updatedUser.email;
      }
      if (phoneController.text != updatedUser.phoneNumber) {
        phoneController.text = updatedUser.phoneNumber;
      }
      if (addressController.text != updatedUser.address) {
        addressController.text = updatedUser.address;
      }
    });
  }

  Future<void> loadUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString('user_data');
      if (userJson != null && userJson.isNotEmpty) {
        user.value = User.fromJson(userJson);
      } else {
        final userName = prefs.getString('userName');
        final userEmail = prefs.getString('userEmail');
        if (userName != null && userEmail != null) {
          final nameParts = userName.split(' ');
          final firstName = nameParts.isNotEmpty ? nameParts.first : '';
          final lastName = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';
          user.value = User(
            id: 'user_${DateTime.now().millisecondsSinceEpoch}',
            firstName: firstName,
            lastName: lastName,
            email: userEmail,
            phoneNumber: '',
            address: '',
            profileImage: null,
          );
          await saveUserData();
          await prefs.remove('userName');
          await prefs.remove('userEmail');
        }
      }
      nameController.text = user.value.fullName;
      emailController.text = user.value.email;
      phoneController.text = user.value.phoneNumber;
      addressController.text = user.value.address;
    } catch (e) {
      debugPrint('Error loading user data: $e');
      Get.snackbar('Error', 'Failed to load user data');
    }
  }

  Future<void> loadAppSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      darkMode.value = prefs.getBool('dark_mode') ?? false;
      notificationsEnabled.value = prefs.getBool('notifications_enabled') ?? true;
      if (darkMode.value) {
        Get.changeThemeMode(ThemeMode.dark);
      }
    } catch (e) {
      debugPrint('Error loading app settings: $e');
    }
  }

  Future<void> saveUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_data', user.value.toJson());
    } catch (e) {
      debugPrint('Error saving user data: $e');
      Get.snackbar('Error', 'Failed to save user data');
    }
  }

  Future<void> saveAppSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('dark_mode', darkMode.value);
      await prefs.setBool('notifications_enabled', notificationsEnabled.value);
    } catch (e) {
      debugPrint('Error saving app settings: $e');
    }
  }

  Future<void> refreshUserData() async {
    await loadUserData();
    update();
  }

  void updateUserProfile() {
    final nameParts = nameController.text.split(' ');
    final firstName = nameParts.isNotEmpty ? nameParts.first : '';
    final lastName = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';

    user.update((val) {
      val?.firstName = firstName;
      val?.lastName = lastName;
      val?.email = emailController.text;
      val?.phoneNumber = phoneController.text;
      val?.address = addressController.text;
    });

    saveUserData();
    Get.snackbar('Success', 'Profile updated successfully');
  }

  Future<void> pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(source: source, imageQuality: 75);
      if (image != null) {
        setProfileImage(image);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to pick image: $e');
    }
  }

  void setProfileImage(XFile pickedFile) {
    profileImage.value = pickedFile;
    user.update((val) {
      if (val != null) {
        val.profileImage = pickedFile.path;
      }
    });
    saveUserData();
    Get.snackbar('Success', 'Profile image updated');
  }

  void removeImage() {
    profileImage.value = null;
    user.update((val) {
      if (val != null) {
        val.profileImage = null;
      }
    });
    saveUserData();
    Get.snackbar('Success', 'Profile image removed');
  }

  void toggleDarkMode(bool val) {
    darkMode.value = val;
    Get.changeThemeMode(val ? ThemeMode.dark : ThemeMode.light);
    saveAppSettings();
  }

  void toggleNotifications(bool val) {
    notificationsEnabled.value = val;
    saveAppSettings();
  }

  void logout() {
    clearLoginStatus();
    Get.offAllNamed('/signin');
  }

  Future<void> clearLoginStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', false);
      Get.snackbar('Logout', 'User logged out successfully', snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      debugPrint('Error clearing login status: $e');
    }
  }

  @override
  void onClose() {
    _userChangeWorker?.dispose();
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    super.onClose();
  }
}
