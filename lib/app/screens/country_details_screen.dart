import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/country.dart';
import '../controllers/favorites_controller.dart';
import 'package:intl/intl.dart';

class CountryDetailsScreen extends StatelessWidget {
  final Country country;
  final FavoritesController favoritesController = Get.find<FavoritesController>();

  CountryDetailsScreen({super.key, required this.country});

  final NumberFormat numberFormatter = NumberFormat('#,###');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Get.back()),
        title: Text(country.name),
        actions: [
          Obx(() {
            final isFav = favoritesController.isFavorite(country);
            return IconButton(
              icon: Icon(isFav ? Icons.favorite : Icons.favorite_border, color: isFav ? Colors.redAccent : Colors.white),
              onPressed: () => favoritesController.toggleFavorite(country),
            );
          }),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Center(
            child: country.flagUrl.isNotEmpty
                ? Image.network(country.flagUrl, height: 150, fit: BoxFit.contain)
                : Container(height: 150, color: Colors.grey),
          ),
          const SizedBox(height: 16),
          Center(
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(country.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(width: 8),
              Obx(() {
                final isFav = favoritesController.isFavorite(country);
                return IconButton(
                  icon: Icon(isFav ? Icons.favorite : Icons.favorite_border, color: isFav ? Colors.redAccent : Colors.grey, size: 28),
                  onPressed: () => favoritesController.toggleFavorite(country),
                );
              }),
            ]),
          ),
          const SizedBox(height: 16),
          InfoRow(label: 'Capital', value: country.capital),
          InfoRow(label: 'Region', value: country.region),
          if (country.subregion.isNotEmpty) InfoRow(label: 'Subregion', value: country.subregion),
          InfoRow(label: 'Population', value: numberFormatter.format(country.population)),
          InfoRow(label: 'Area', value: '${numberFormatter.format(country.area)} km²'),
          if (country.languages.isNotEmpty) InfoRow(label: 'Languages', value: country.languages.values.join(', ')),
          if (country.currencies.isNotEmpty)
            InfoRow(
                label: 'Currencies',
                value: country.currencies.entries.map((e) => '${e.value['name']} (${e.value['symbol'] ?? ''})').join(', ')),
          if (country.timezones.isNotEmpty) InfoRow(label: 'Timezones', value: country.timezones.join(', ')),
          if (country.borders.isNotEmpty) InfoRow(label: 'Borders', value: country.borders.join(', ')),
        ]),
      ),
    );
  }
}

class InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const InfoRow({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        Expanded(child: Text(value, style: const TextStyle(fontSize: 16))),
      ]),
    );
  }
}
