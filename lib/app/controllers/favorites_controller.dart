import 'package:get/get.dart';
import '../models/country.dart';

class FavoritesController extends GetxController {
  // Reactive list of all favorite countries
  var favoriteCountries = <Country>[].obs;

  // Search query for filtering favorites
  var searchQuery = ''.obs;

  // Reactive list of filtered favorites
  var filteredFavorites = <Country>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Initialize filtered list
    filteredFavorites.assignAll(favoriteCountries);

    // Reactively update filteredFavorites whenever
    // favoriteCountries or searchQuery changes
    everAll([favoriteCountries, searchQuery], (_) {
      applyFilters();
    });
  }

  // Check if a country is in favorites
  bool isFavorite(Country country) {
    return favoriteCountries.any((c) => c.name == country.name);
  }

  // Toggle favorite status
  void toggleFavorite(Country country) {
    if (isFavorite(country)) {
      // Remove the country if it is already a favorite
      favoriteCountries.removeWhere((c) => c.name == country.name);
    } else {
      // Add the country to favorites
      favoriteCountries.add(country);
    }
  }

  // Apply search filtering to favorites
  void applyFilters() {
    if (searchQuery.isEmpty) {
      filteredFavorites.assignAll(favoriteCountries);
    } else {
      filteredFavorites.assignAll(
        favoriteCountries
            .where((c) =>
                c.name.toLowerCase().contains(searchQuery.value.toLowerCase()))
            .toList(),
      );
    }
  }
}
