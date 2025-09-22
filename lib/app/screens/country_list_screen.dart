import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:country_picker/country_picker.dart';
import 'package:logger/logger.dart';
import '../controllers/country_controller.dart';
import '../widgets/country_card.dart';
import '../routes/app_routes.dart';

class CountryListScreen extends StatelessWidget {
  final CountryController controller = Get.find<CountryController>();

  // Create a logger instance
  final Logger logger = Logger();

  CountryListScreen({super.key});

  void _showCountryPicker(BuildContext context) {
    showCountryPicker(
      context: context,
      showPhoneCode: true,
      onSelect: (Country country) {
        logger.i('Selected country: ${country.name}');
        // Navigate to country details screen with selected country name
        Get.toNamed(Routes.countryDetails, arguments: country.name);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('African Countries'),
        actions: [
          PopupMenuButton<CountryFilter>(
            onSelected: (filter) {
              controller.filter.value = filter;
              if (filter == CountryFilter.alphabetical) {
                controller.filterValue.value = '';
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: CountryFilter.all,
                child: Text('All'),
              ),
              const PopupMenuItem(
                value: CountryFilter.alphabetical,
                child: Text('Alphabetical'),
              ),
              const PopupMenuItem(
                value: CountryFilter.language,
                child: Text('Filter by Language'),
              ),
              const PopupMenuItem(
                value: CountryFilter.region,
                child: Text('Filter by Region'),
              ),
            ],
            icon: const Icon(Icons.filter_list),
          ),
          IconButton(
            icon: const Icon(Icons.public),
            tooltip: 'Pick Country',
            onPressed: () => _showCountryPicker(context),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: TextField(
              onChanged: (value) => controller.searchQuery.value = value,
              decoration: InputDecoration(
                hintText: 'Search countries',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Theme.of(context).scaffoldBackgroundColor,
              ),
            ),
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        } else if (controller.errorMessage.value.isNotEmpty) {
          return Center(
            child: Text(controller.errorMessage.value),
          );
        } else if (controller.filteredCountries.isEmpty) {
          return const Center(child: Text('No countries found.'));
        } else {
          return ListView.builder(
            itemCount: controller.filteredCountries.length,
            itemBuilder: (context, index) {
              final country = controller.filteredCountries[index];
              return CountryCard(
                flagUrl: country.flagUrl,
                name: country.name,
                capital: country.capital,
                onTap: () => Get.toNamed(
                  Routes.countryDetails,
                  arguments: country.name,
                ),
              );
            },
          );
        }
      }),
    );
  }
}
