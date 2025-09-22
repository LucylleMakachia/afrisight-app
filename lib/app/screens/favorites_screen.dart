import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/favorites_controller.dart';
import '../widgets/country_card.dart';
import 'country_details_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get controllers safely inside build method
    final FavoritesController favoritesController;

    try {
      favoritesController = Get.find<FavoritesController>();
    } catch (e) {
      return const Center(
        child: Text('Controllers not initialized yet'),
      );
    }

    return Column(
      children: [
        // Search bar to filter favorites
        Padding(
          padding: const EdgeInsets.all(12),
          child: TextField(
            decoration: InputDecoration(
              hintText: "Search favorites...",
              prefixIcon: const Icon(Icons.search),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onChanged: (query) {
              favoritesController.searchQuery.value = query;
              favoritesController.applyFilters();
            },
          ),
        ),
        Expanded(
          child: Obx(() {
            final favorites = favoritesController.filteredFavorites;

            if (favorites.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.favorite, size: 80, color: Colors.redAccent),
                    SizedBox(height: 20),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40),
                      child: Text(
                        "Your favorite countries will be saved and shown here.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              );
            }

            return GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final country = favorites[index];
                final isFav = favoritesController.isFavorite(country);

                return CountryCard(
                  flagUrl: country.flagUrl,
                  name: country.name,
                  capital: country.capital,
                  onTap: () {
                    Get.to(() => CountryDetailsScreen(country: country))
                        ?.then((_) {
                      favoritesController.searchQuery.value = '';
                      favoritesController.applyFilters();
                    });
                  },
                  isFavorite: isFav,
                  onFavoriteToggle: () {
                    favoritesController.toggleFavorite(country);
                    Get.snackbar(
                      isFav ? 'Removed' : 'Added',
                      '${country.name} ${isFav ? 'removed from' : 'added to'} favorites',
                      snackPosition: SnackPosition.BOTTOM,
                      duration: const Duration(seconds: 2),
                    );
                  },
                );
              },
            );
          }),
        ),
      ],
    );
  }
}