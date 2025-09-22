import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/country_controller.dart';
import '../controllers/favorites_controller.dart';
import '../widgets/country_card.dart';
import 'country_details_screen.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get controllers safely inside build method
    final CountryController countryController;
    final FavoritesController favoritesController;

    try {
      countryController = Get.find<CountryController>();
      favoritesController = Get.find<FavoritesController>();
    } catch (e) {
      return const Center(
        child: Text('Controllers not initialized yet'),
      );
    }

    return Column(
      children: [
        // Search bar at the top
        Padding(
          padding: const EdgeInsets.all(12),
          child: TextField(
            decoration: InputDecoration(
              hintText: "Search countries...",
              prefixIcon: const Icon(Icons.search),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onChanged: (query) {
              countryController.searchQuery.value = query;
              countryController.applyFilters();
            },
          ),
        ),
        Expanded(
          child: Obx(() {
            if (countryController.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }
            if (countryController.errorMessage.isNotEmpty) {
              return Center(child: Text(countryController.errorMessage.value));
            }

            final countries = countryController.searchQuery.value.isEmpty
                ? countryController.countries
                : countryController.filteredCountries;

            if (countries.isEmpty) {
              return const Center(child: Text("No countries found."));
            }

            return GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: countries.length,
              itemBuilder: (context, index) {
                final country = countries[index];
                final isFav = favoritesController.isFavorite(country);

                return CountryCard(
                  flagUrl: country.flagUrl,
                  name: country.name,
                  capital: country.capital,
                  onTap: () {
                    Get.to(() => CountryDetailsScreen(country: country))
                        ?.then((_) {
                      countryController.searchQuery.value = '';
                      countryController.applyFilters();
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