import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_screen_controller.dart';
import 'home_screen.dart';

class NotificationsScreen extends StatelessWidget {
  NotificationsScreen({super.key});

  final HomeScreenController controller = Get.find<HomeScreenController>();

  final List<Map<String, String>> dummyNotifications = const [
    {
      'title': 'New Country Data Added',
      'body': 'Information about the economic growth of Malawi has been updated.'
    },
    {
      'title': 'Country Profile Featured',
      'body': 'Discover the cultural heritage of Ghana in this week\'s spotlight.'
    },
    {
      'title': 'Travel Advisory Update',
      'body': 'Check the latest travel guidance for Ethiopia before planning your visit.'
    },
    {
      'title': 'New Historical Insights',
      'body': 'Learn about the historic trade routes across West Africa.'
    },
    {
      'title': 'Data Accuracy Improved',
      'body': 'Population figures for several countries have been revised for accuracy.'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        title: const Text('Notifications'),
      ),
      body: dummyNotifications.isEmpty
          ? const Center(child: Text('No new notifications yet.'))
          : ListView.builder(
              itemCount: dummyNotifications.length,
              itemBuilder: (context, index) {
                final notification = dummyNotifications[index];
                return ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: Text(notification['title'] ?? ''),
                  subtitle: Text(notification['body'] ?? ''),
                  onTap: () {
                    // Optional: handle tap for more info or navigation
                  },
                );
              },
            ),
      bottomNavigationBar: Obx(() => BottomNavigationBar(
            currentIndex: controller.selectedIndex.value,
            onTap: (index) {
              controller.changeIndex(index);
              // Optionally navigate back to HomeScreen if not already
              if (index == 0) Get.offAll(() => HomeScreen());
            },
            selectedItemColor: Colors.blueAccent,
            unselectedItemColor: Colors.grey,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(icon: Icon(Icons.public), label: 'Explore'),
              BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorites'),
              BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
            ],
          )),
    );
  }
}
