import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'explore_screen.dart';
import 'favorites_screen.dart';
import 'profile_screen.dart';
import '../controllers/home_screen_controller.dart';
import '../controllers/country_controller.dart';
import '../controllers/profile_controller.dart';
import 'package:image_picker/image_picker.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final RxBool controllersInitialized = false.obs;

  Timer? _notificationTimer;
  bool _hasNotified = false;
  Worker? _indexWorker;

  late final TextEditingController searchTextController;

  final List<String> welcomeMessages = [
    "Welcome {name} - ready to explore the beautiful countries of Africa?",
    "Discover new cultures every day, {name}!",
    "Let's journey through Africa together, {name}.",
  ];

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _setupSearchController();
  }

  Future<void> _initializeControllers() async {
    try {
      controllersInitialized.value = true;
      _setupIndexListener();
      _startNotificationTimer();
    } catch (e) {
      debugPrint('Error initializing controllers: $e');
      controllersInitialized.value = true;
    }
  }

  void _setupSearchController() {
    searchTextController = TextEditingController();
  }

  void _setupIndexListener() {
    final homeController = Get.find<HomeScreenController>();
    _indexWorker = ever(homeController.selectedIndex, (int idx) {
      if (idx != 0) {
        _clearSearch();
      }
    });
  }

  void _clearSearch() {
    searchTextController.clear();
    final countryController = Get.find<CountryController>();
    countryController.searchQuery.value = '';
    countryController.applyFilters();
  }

  void _startNotificationTimer() {
    _notificationTimer = Timer(const Duration(seconds: 5), () {
      if (!_hasNotified && mounted) {
        _hasNotified = true;
        final homeController = Get.find<HomeScreenController>();
        homeController.incrementNotification();
        Get.snackbar(
          'New Notification',
          'You have received a new notification.',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3),
        );
      }
    });
  }

  @override
  void dispose() {
    searchTextController.dispose();
    _notificationTimer?.cancel();
    _indexWorker?.dispose();
    super.dispose();
  }

  String getGreetingMessage(String firstName) {
    final String name = firstName.isNotEmpty ? firstName : "User";
    int index = DateTime.now().day % welcomeMessages.length;
    return welcomeMessages[index].replaceAll('{name}', name);
  }

  void _showProfileImageOptions(ProfileController profileCtrl) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        final profileImage = profileCtrl.profileImage.value;
        final userImage = profileCtrl.user.value.profileImage;
        final theme = Theme.of(context);
        final primaryColor = theme.colorScheme.primary;
        final onPrimaryColor = theme.colorScheme.onPrimary;
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Hero(
                tag: 'profile-image-hero',
                child: CircleAvatar(
                  radius: 80,
                  backgroundImage: profileImage != null
                      ? (kIsWeb
                          ? NetworkImage(profileImage.path)
                          : FileImage(File(profileImage.path)) as ImageProvider)
                      : (userImage != null && userImage.isNotEmpty
                          ? NetworkImage(userImage)
                          : null),
                  child: (profileImage == null && (userImage == null || userImage.isEmpty))
                      ? const Icon(Icons.person, size: 80, color: Colors.white)
                      : null,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                icon: const Icon(Icons.camera_alt),
                label: const Text("Take Photo"),
                style: ElevatedButton.styleFrom(
                  foregroundColor: onPrimaryColor,
                  backgroundColor: primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  profileCtrl.pickImage(ImageSource.camera);
                },
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                icon: const Icon(Icons.photo_library),
                label: const Text("Choose from Gallery"),
                style: ElevatedButton.styleFrom(
                  foregroundColor: onPrimaryColor,
                  backgroundColor: primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  profileCtrl.pickImage(ImageSource.gallery);
                },
              ),
              if (profileImage != null || (userImage != null && userImage.isNotEmpty))
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.delete),
                    label: const Text("Delete Image"),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: theme.colorScheme.onError,
                      backgroundColor: theme.colorScheme.error,
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      profileCtrl.removeImage();
                    },
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAppBarActions() {
    return Obx(() {
      if (!controllersInitialized.value) return const SizedBox.shrink();

      final ProfileController profileCtrl = Get.find<ProfileController>();
      final user = profileCtrl.user.value;

      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Obx(() {
                  final profileImage = profileCtrl.profileImage.value;
                  final userImage = user.profileImage;

                  Widget avatar;

                  if (profileImage != null) {
                    avatar = kIsWeb
                        ? CircleAvatar(
                            radius: 16,
                            backgroundImage: NetworkImage(profileImage.path),
                          )
                        : CircleAvatar(
                            radius: 16,
                            backgroundImage: FileImage(File(profileImage.path)),
                          );
                  } else if (userImage != null && userImage.isNotEmpty) {
                    avatar = CircleAvatar(
                      radius: 16,
                      backgroundImage: NetworkImage(userImage),
                    );
                  } else {
                    avatar = const CircleAvatar(
                      radius: 16,
                      child: Icon(Icons.person, size: 18, color: Colors.white),
                    );
                  }

                  return GestureDetector(
                    onTap: () => _showProfileImageOptions(profileCtrl),
                    child: Hero(
                      tag: 'profile-image-hero',
                      child: avatar,
                    ),
                  );
                }),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    user.fullName.isNotEmpty ? user.fullName : "User",
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          Obx(() {
            final homeController = Get.find<HomeScreenController>();
            final count = homeController.notificationCount.value;
            return Stack(
              children: [
                IconButton(
                  icon: const Icon(Icons.notifications),
                  onPressed: () {
                    homeController.clearNotifications();
                    Get.toNamed('/notifications');
                  },
                ),
                if (count > 0)
                  Positioned(
                    right: 11,
                    top: 11,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                      constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                      child: Text(
                        '$count',
                        style: const TextStyle(color: Colors.white, fontSize: 10),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
              ],
            );
          }),
          Obx(() {
            return IconButton(
              icon: Icon(profileCtrl.darkMode.value ? Icons.light_mode_outlined : Icons.dark_mode_outlined),
              onPressed: () => profileCtrl.toggleDarkMode(!profileCtrl.darkMode.value),
            );
          }),
        ],
      );
    });
  }

  Widget _buildQuickStats() {
    final CountryController countryCtrl = Get.find<CountryController>();
    final int totalCountries = countryCtrl.countries.length;
    final int totalPopulation =
        countryCtrl.countries.fold(0, (sum, country) => sum + country.population);
    final double totalArea =
        countryCtrl.countries.fold(0.0, (sum, country) => sum + country.area);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            colors: [Color(0xFF1976D2), Color(0xFF0D47A1)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )),
      child: Column(
        children: [
          const Text(
            'Africa at a Glance',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem('$totalCountries', 'Countries', Icons.flag),
              _buildStatItem(
                  '${(totalPopulation / 1000000000).toStringAsFixed(1)}B', 'People', Icons.people),
              _buildStatItem(
                  '${(totalArea / 1000000).toStringAsFixed(1)}M', 'km² Area', Icons.public),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Discover the diversity of 54 nations',
            style: TextStyle(fontSize: 12, color: Colors.white70, fontStyle: FontStyle.italic),
          )
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String label, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 24, color: Colors.white),
        const SizedBox(height: 4),
        Text(value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.white70)),
      ],
    );
  }

  Widget _buildHomeContent() {
    return Obx(() {
      if (!controllersInitialized.value) {
        return const Center(child: CircularProgressIndicator());
      }

      final ProfileController profileCtrl = Get.find<ProfileController>();
      final user = profileCtrl.user.value;
      final firstName = user.firstName.isNotEmpty ? user.firstName : "User";

      return Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                getGreetingMessage(firstName),
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blueAccent),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              _buildQuickStats(),
              const SizedBox(height: 48),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.green[100]!)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.explore, size: 40, color: Colors.green),
                    const SizedBox(height: 12),
                    const Text(
                      'Ready to explore more?',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Discover all African countries and their unique cultures',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => Get.find<HomeScreenController>().changeIndex(1),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12)),
                      child: const Text('Explore All Countries'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Get.find<HomeScreenController>().changeIndex(0);
          },
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Image.asset(
              'assets/images/mosaic_logo.png',
              height: 32,
              width: 32,
            ),
          ),
        ),
        title: const Text('Afrisight'),
        centerTitle: true,
        actions: [_buildAppBarActions()],
      ),
      body: Obx(() {
        if (!controllersInitialized.value) {
          return const Center(child: CircularProgressIndicator());
        }
        final HomeScreenController homeCtrl = Get.find<HomeScreenController>();
        return IndexedStack(
          index: homeCtrl.selectedIndex.value,
          children: [
            _buildHomeContent(),
            ExploreScreen(),
            FavoritesScreen(),
            ProfileScreen(),
          ],
        );
      }),
      bottomNavigationBar: Obx(() {
        if (!controllersInitialized.value) {
          return const SizedBox.shrink();
        }
        final HomeScreenController homeCtrl = Get.find<HomeScreenController>();
        return BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: homeCtrl.selectedIndex.value,
          onTap: (index) => homeCtrl.changeIndex(index),
          selectedItemColor: Colors.blueAccent,
          unselectedItemColor: Colors.grey,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.public), label: 'Explore'),
            BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorites'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
        );
      }),
    );
  }
}
