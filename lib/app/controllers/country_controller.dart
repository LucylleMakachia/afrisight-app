import 'package:get/get.dart';
import '../models/country.dart';
import '../services/api_service.dart';

enum CountryFilter { all, language, region, alphabetical }

class CountryController extends GetxController {
  final ApiService apiService;

  CountryController({required this.apiService});

  var countries = <Country>[].obs;
  var filteredCountries = <Country>[].obs;

  var isLoading = false.obs;
  var errorMessage = ''.obs;

  var searchQuery = ''.obs;
  var filter = CountryFilter.all.obs;
  var filterValue = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCountries();

    // React to search, filter, or filterValue changes
    everAll([searchQuery, filter, filterValue], (_) {
      applyFilters();
    });
  }

  Future<void> fetchCountries() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final fetched = await apiService.fetchAfricanCountries();
      countries.value = fetched;
      filteredCountries.value = fetched;
    } catch (e) {
      errorMessage.value = 'Failed to load countries: $e';
    } finally {
      isLoading.value = false;
    }
  }

  void applyFilters() {
    List<Country> list = countries.toList();

    // Apply search
    if (searchQuery.value.isNotEmpty) {
      final query = searchQuery.value.toLowerCase();
      list = list.where((c) => c.name.toLowerCase().contains(query)).toList();
    }

    // Apply filter
    switch (filter.value) {
      case CountryFilter.language:
        if (filterValue.value.isNotEmpty) {
          final val = filterValue.value.toLowerCase();
          list = list
              .where((c) => c.languages.values
                  .any((lang) => lang.toLowerCase() == val))
              .toList();
        }
        break;
      case CountryFilter.region:
        if (filterValue.value.isNotEmpty) {
          final val = filterValue.value.toLowerCase();
          list =
              list.where((c) => c.region.toLowerCase() == val).toList();
        }
        break;
      case CountryFilter.alphabetical:
        list.sort((a, b) => a.name.compareTo(b.name));
        break;
      case CountryFilter.all:
        // no filter, keep as-is
        break;
    }

    filteredCountries.value = list;
  }

  /// Explicitly trigger re-filtering (optional helper)
  void filterCountries() {
    applyFilters();
  }

  /// Resets the search query and filters
  void resetFilter() {
    searchQuery.value = '';
    filter.value = CountryFilter.all;
    filterValue.value = '';
    filteredCountries.value = countries.toList();
  }
}
