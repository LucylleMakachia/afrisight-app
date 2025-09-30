# Afrisight

Afrisight is a cross-platform Flutter application that lets users explore, search, and learn about African countries, manage favorites, and personalize their experience with profile and notification features.

## Features

- **Explore African Countries:** Browse, search, and filter all African countries with details like capital, population, area, borders, currencies, languages, region, subregion, and timezones.
- **Favorites:** Mark countries as favorites for quick access.
- **Profile Management:** Edit your profile, upload a profile image, and manage preferences (dark mode, notifications).
- **Onboarding & Authentication:** Guided onboarding for new users, sign up/sign in with validation and local persistence.
- **Notifications:** Receive and view app notifications.
- **Robust Error Handling:** Handles API/network errors gracefully.
- **Caching:** Reduces redundant API calls for better performance.
- **Unit Tests:** Ensures stability and correctness of core logic.

## Project Structure

```
afrisight/
  ├── lib/
  │   ├── app/
  │   │   ├── bindings/            # Dependency injection setup ([app_bindings.dart](lib/app/bindings/app_bindings.dart))
  │   │   ├── controllers/         # State management ([country_controller.dart](lib/app/controllers/country_controller.dart), [profile_controller.dart](lib/app/controllers/profile_controller.dart), etc.)
  │   │   ├── models/              # Data models ([country.dart](lib/app/models/country.dart), [user.dart](lib/app/models/user.dart))
  │   │   ├── routes/              # App routing ([app_pages.dart](lib/app/routes/app_pages.dart), [app_routes.dart](lib/app/routes/app_routes.dart))
  │   │   ├── screens/             # UI screens ([home_screen.dart](lib/app/screens/home_screen.dart), [country_details_screen.dart](lib/app/screens/country_details_screen.dart), etc.)
  │   │   ├── services/            # API, cache, notification services ([api_service.dart](lib/app/services/api_service.dart), [cache_service.dart](lib/app/services/cache_service.dart), [notification_service.dart](lib/app/services/notification_service.dart))
  │   │   ├── themes/              # Light/dark theme ([app_theme.dart](lib/app/themes/app_theme.dart))
  │   │   ├── widgets/             # Reusable widgets ([custom_search_bar.dart](lib/app/widgets/custom_search_bar.dart), [loading_widget.dart](lib/app/widgets/loading_widget.dart))
  │   ├── main.dart                # App entry point ([main.dart](lib/main.dart))
  ├── test/                        # Unit and widget tests ([widget_test.dart](test/widget_test.dart))
  ├── assets/                      # Images and icons
  ├── android/, ios/, linux/, macos/, windows/, web/  # Platform-specific code
  ├── pubspec.yaml                 # Dependencies and assets
  ├── README.md                    # Project documentation
```

## Getting Started

1. **Clone the repository:**
   ```sh
   git clone <repo-url>
   cd afrisight
   ```

2. **Install dependencies:**
   ```sh
   flutter pub get
   ```

3. **Run the app:**
   ```sh
   flutter run
   ```

4. **Run tests:**
   ```sh
   flutter test
   ```

## Key Files & References

- **App Entry:** [`main.dart`](lib/main.dart)
- **Routing:** [`app_pages.dart`](lib/app/routes/app_pages.dart), [`app_routes.dart`](lib/app/routes/app_routes.dart)
- **Country Model:** [`country.dart`](lib/app/models/country.dart)
- **API Service (with error handling & caching):** [`api_service.dart`](lib/app/services/api_service.dart)
- **Profile Controller:** [`profile_controller.dart`](lib/app/controllers/profile_controller.dart)
- **Unit Tests:** [`widget_test.dart`](test/widget_test.dart)
- **Themes:** [`app_theme.dart`](lib/app/themes/app_theme.dart)
- **Onboarding:** [`onboarding_screen.dart`](lib/app/screens/onboarding_screen.dart)
- **Notifications:** [`notification_service.dart`](lib/app/services/notification_service.dart)
- **Favorites:** [`favorites_controller.dart`](lib/app/controllers/favorites_controller.dart)
- **Reusable Widgets:** [`custom_search_bar.dart`](lib/app/widgets/custom_search_bar.dart), [`loading_widget.dart`](lib/app/widgets/loading_widget.dart)

## Error Handling & Caching

- API calls in [`ApiService`](lib/app/services/api_service.dart) use try/catch and HTTP status checks.
- Results are cached in-memory and via [`CacheService`](lib/app/services/cache_service.dart) using GetStorage.

## Testing

- Widget and logic tests are in [`test/widget_test.dart`](test/widget_test.dart).
- Add more tests for controllers and services as needed.

## Platform Support

Afrisight supports Android, iOS, Web, Windows, macOS, and Linux. Platform-specific code is in respective folders.

## Contributing

1. Fork the repo and create your branch.
2. Make changes and add tests.
3. Submit a pull request.

## License

See [LICENSE](LICENSE) for details.

---

For more Flutter resources:
- [Flutter Documentation](https://docs.flutter.dev/)
- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)