class Country {
  final String name;
  final Map<String, String> languages;
  final String capital;
  final String flagUrl;
  final int population;
  final double area;
  final List<String> borders;
  final Map<String, dynamic> currencies;
  final String region;
  final String subregion;          // New
  final List<String> timezones;    // New

  Country({
    required this.name,
    required this.languages,
    required this.capital,
    required this.flagUrl,
    required this.population,
    required this.area,
    required this.borders,
    required this.currencies,
    required this.region,
    required this.subregion,
    required this.timezones,
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      name: json['name'] != null && json['name']['common'] != null
          ? json['name']['common']
          : '',
      languages: json['languages'] != null
          ? Map<String, String>.from(json['languages'])
          : {},
      capital: (json['capital'] != null && (json['capital'] as List).isNotEmpty)
          ? json['capital'][0]
          : 'N/A',
      flagUrl: json['flags'] != null && json['flags']['png'] != null
          ? json['flags']['png']
          : '',
      population: json['population'] ?? 0,
      area: (json['area'] != null) ? (json['area'] as num).toDouble() : 0.0,
      borders: json['borders'] != null ? List<String>.from(json['borders']) : [],
      currencies: json['currencies'] != null
          ? Map<String, dynamic>.from(json['currencies'])
          : {},
      region: json['region'] ?? 'Unknown',
      subregion: json['subregion'] ?? 'Unknown',                // New
      timezones: json['timezones'] != null
          ? List<String>.from(json['timezones'])
          : [],                                                // New
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': {'common': name},
      'languages': languages,
      'capital': [capital],
      'flags': {'png': flagUrl},
      'population': population,
      'area': area,
      'borders': borders,
      'currencies': currencies,
      'region': region,
      'subregion': subregion,             // New
      'timezones': timezones,             // New
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Country &&
          runtimeType == other.runtimeType &&
          name.toLowerCase() == other.name.toLowerCase();

  @override
  int get hashCode => name.toLowerCase().hashCode;
}
