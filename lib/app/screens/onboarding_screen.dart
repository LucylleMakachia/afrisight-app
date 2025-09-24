import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../routes/app_routes.dart'; // Import Routes for named routes

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late final PageController _pageController;
  int currentIndex = 0;

  final List<Map<String, String>> slides = [
    {
      "title": "Welcome to Afrisight",
      "description": "Explore the rich cultures and countries of Africa in one app.",
      "image": "assets/images/onboarding1.png"
    },
    {
      "title": "Discover Countries",
      "description": "Get details, maps, and statistics about 54 African countries.",
      "image": "assets/images/onboarding2.png"
    },
    {
      "title": "Favorites & Profiles",
      "description": "Save favorite countries and manage your profile easily.",
      "image": "assets/images/onboarding3.png"
    },
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (currentIndex < slides.length - 1) {
      _pageController.nextPage(
          duration: const Duration(milliseconds: 300), curve: Curves.ease);
    } else {
      _completeOnboarding();
    }
  }

  void _completeOnboarding() {
    final box = GetStorage();
    box.write('onboarded', true);
    // Navigate to signin screen removing onboarding from stack
    Get.offNamed(Routes.signin);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        controller: _pageController,
        itemCount: slides.length,
        onPageChanged: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        itemBuilder: (_, index) {
          return Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(slides[index]["image"]!, height: 300),
                const SizedBox(height: 24),
                Text(
                  slides[index]["title"]!,
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  slides[index]["description"]!,
                  style: const TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    textStyle: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  onPressed: _nextPage,
                  child: Text(currentIndex == slides.length - 1
                      ? "Get Started"
                      : "Next"),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
