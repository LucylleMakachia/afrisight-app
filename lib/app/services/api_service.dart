import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/country.dart';

class ApiService {
  static const _baseUrl = 'https://restcountries.com/v3.1';

  final Map<String, List<Country>> _cache = {};

  /// Common HTTP timeout duration
  static const Duration _timeoutDuration = Duration(seconds: 10);

  /// Fetch all African countries with all required fields
  Future<List<Country>> fetchAfricanCountries() async {
    const cacheKey = 'africa_countries';
    if (_cache.containsKey(cacheKey)) {
      return _cache[cacheKey]!;
    }

    final uri = Uri.parse(
      '$_baseUrl/region/africa?fields='
      'name,languages,capital,flags,region,subregion,population,area,borders,currencies,timezones',
    );

    try {
      final response = await http.get(uri).timeout(_timeoutDuration);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final countries = data.map((item) => Country.fromJson(item)).toList();
        _cache[cacheKey] = countries;
        return countries;
      } else {
        throw Exception('Failed to fetch countries: HTTP ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Fetch details for a single country by name
  Future<Country> fetchCountryDetails(String name) async {
    final cacheKey = 'country_$name';
    if (_cache.containsKey(cacheKey)) {
      return _cache[cacheKey]!.first;
    }

    final uri = Uri.parse(
      '$_baseUrl/name/$name?fullText=true&fields='
      'name,languages,capital,flags,region,subregion,population,area,borders,currencies,timezones',
    );

    try {
      final response = await http.get(uri).timeout(_timeoutDuration);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        if (data.isNotEmpty) {
          final country = Country.fromJson(data[0]);
          _cache[cacheKey] = [country];
          return country;
        } else {
          throw Exception('Country not found');
        }
      } else {
        throw Exception('Failed to fetch country details: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Clear cached data
  void clearCache() {
    _cache.clear();
  }
}
