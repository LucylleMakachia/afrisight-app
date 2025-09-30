import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../controllers/profile_controller.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<void> _pickImage(ProfileController controller, ImageSource source) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? pickedFile = await picker.pickImage(source: source, imageQuality: 85);
      if (pickedFile != null) {
        controller.setProfileImage(pickedFile);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to pick image: $e');
    }
  }

  Widget _buildImage(ProfileController controller) {
    final XFile? profileImage = controller.profileImage.value;
    final String? userImage = controller.user.value.profileImage;

    if (profileImage != null) {
      if (kIsWeb) {
        return CircleAvatar(
          radius: 60,
          backgroundImage: NetworkImage(profileImage.path),
        );
      } else {
        return CircleAvatar(
          radius: 60,
          backgroundImage: FileImage(File(profileImage.path)),
        );
      }
    } else if (userImage != null && userImage.isNotEmpty) {
      return CircleAvatar(
        radius: 60,
        backgroundImage: NetworkImage(userImage),
      );
    } else {
      return CircleAvatar(
        radius: 60,
        backgroundColor: Colors.grey.shade300,
        child: const Icon(Icons.person, size: 50, color: Colors.white),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final ProfileController controller = Get.find<ProfileController>();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Obx(() => _buildImage(controller)),
              PopupMenuButton<String>(
                icon: const CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.black54,
                  child: Icon(Icons.camera_alt, color: Colors.white, size: 20),
                ),
                onSelected: (value) {
                  if (value == 'camera') {
                    _pickImage(controller, ImageSource.camera);
                  } else if (value == 'gallery') {
                    _pickImage(controller, ImageSource.gallery);
                  } else if (value == 'remove') {
                    controller.removeImage();
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(value: 'camera', child: Text('Take Photo')),
                  const PopupMenuItem(value: 'gallery', child: Text('Choose from Gallery')),
                  if (controller.profileImage.value != null ||
                      (controller.user.value.profileImage != null &&
                          controller.user.value.profileImage!.isNotEmpty))
                    const PopupMenuItem(value: 'remove', child: Text('Remove Photo')),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Obx(() {
            final user = controller.user.value;
            return Text(
              user.fullName.isNotEmpty ? user.fullName : 'User',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            );
          }),
          const SizedBox(height: 24),
          _buildTextField(controller.nameController, 'Full Name', TextInputType.name),
          const SizedBox(height: 16),
          _buildTextField(controller.emailController, 'Email', TextInputType.emailAddress),
          const SizedBox(height: 16),
          _buildTextField(controller.phoneController, 'Phone Number', TextInputType.phone),
          const SizedBox(height: 16),
          _buildTextField(controller.addressController, 'Home Address', TextInputType.streetAddress, maxLines: 2),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: controller.updateUserProfile,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
              ),
              child: const Text('Save Changes', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(height: 16),
          Obx(() => SwitchListTile(
                title: const Text('Dark Mode'),
                value: controller.darkMode.value,
                onChanged: controller.toggleDarkMode,
              )),
          Obx(() => SwitchListTile(
                title: const Text('Enable Notifications'),
                value: controller.notificationsEnabled.value,
                onChanged: controller.toggleNotifications,
              )),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: controller.logout,
              icon: const Icon(Icons.logout),
              label: const Text('Logout'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, TextInputType inputType,
      {int maxLines = 1}) {
    return TextField(
      controller: controller,
      keyboardType: inputType,
      maxLines: maxLines,
      decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
    );
  }
}
