import 'package:flutter_test/flutter_test.dart';
import 'package:afrisight/app/controllers/country_controller.dart';
import 'package:afrisight/app/models/country.dart';
import 'package:afrisight/app/services/api_service.dart';

// Mock ApiService
class MockApiService extends ApiService {
  @override
  Future<List<Country>> fetchAfricanCountries() async {
    return [
      Country(
        name: 'Kenya',
        languages: {'eng': 'English', 'swa': 'Swahili'},
        capital: 'Nairobi',
        flagUrl: 'https://flagcdn.com/ke.png',
        population: 53000000,
        area: 580367,
        borders: ['ETH', 'UGA'],
        currencies: {'KES': {'name': 'Kenyan shilling', 'symbol': 'KSh'}},
        region: 'Africa',
        subregion: 'Eastern Africa',
        timezones: ['UTC+03:00'],
      ),
      Country(
        name: 'Nigeria',
        languages: {'eng': 'English'},
        capital: 'Abuja',
        flagUrl: 'https://flagcdn.com/ng.png',
        population: 200000000,
        area: 923768,
        borders: ['BEN', 'CMR'],
        currencies: {'NGN': {'name': 'Naira', 'symbol': '₦'}},
        region: 'Africa',
        subregion: 'Western Africa',
        timezones: ['UTC+01:00'],
      ),
      Country(
        name: 'Egypt',
        languages: {'ara': 'Arabic'},
        capital: 'Cairo',
        flagUrl: 'https://flagcdn.com/eg.png',
        population: 100000000,
        area: 1010408,
        borders: ['LBY', 'SDN', 'ISR'],
        currencies: {'EGP': {'name': 'Egyptian pound', 'symbol': '£'}},
        region: 'Africa',
        subregion: 'Northern Africa',
        timezones: ['UTC+02:00'],
      ),
    ];
  }
}

void main() {
  late CountryController controller;

  setUp(() {
    controller = CountryController(apiService: MockApiService());
  });

  test('fetchCountries loads countries successfully', () async {
    await controller.fetchCountries();
    expect(controller.countries.length, 3);
    expect(controller.countries[0].name, 'Kenya');
    expect(controller.errorMessage.value, '');
  });

  test('applyFilters filters by search query', () async {
    await controller.fetchCountries();
    controller.searchQuery.value = 'Kenya';
    controller.applyFilters();
    expect(controller.filteredCountries.length, 1);
    expect(controller.filteredCountries[0].name, 'Kenya');
  });

  test('applyFilters filters alphabetically', () async {
    await controller.fetchCountries();
    controller.filter.value = CountryFilter.alphabetical;
    controller.applyFilters();
    expect(controller.filteredCountries.first.name, 'Egypt');
    expect(controller.filteredCountries.last.name, 'Nigeria');
  });

  test('applyFilters filters by region', () async {
    await controller.fetchCountries();
    controller.filter.value = CountryFilter.region;
    controller.filterValue.value = 'Africa';
    controller.applyFilters();
    // All countries are in Africa
    expect(controller.filteredCountries.length, 3);
    // Test region filtering with non-matching value
    controller.filterValue.value = 'Asia';
    controller.applyFilters();
    expect(controller.filteredCountries.length, 0);
  });

  test('applyFilters filters by language', () async {
    await controller.fetchCountries();
    controller.filter.value = CountryFilter.language;
    controller.filterValue.value = 'Swahili';
    controller.applyFilters();
    expect(controller.filteredCountries.length, 1);
    expect(controller.filteredCountries[0].name, 'Kenya');

    // Test another language
    controller.filterValue.value = 'Arabic';
    controller.applyFilters();
    expect(controller.filteredCountries.length, 1);
    expect(controller.filteredCountries[0].name, 'Egypt');

    // Non-existent language
    controller.filterValue.value = 'French';
    controller.applyFilters();
    expect(controller.filteredCountries.length, 0);
  });
}
