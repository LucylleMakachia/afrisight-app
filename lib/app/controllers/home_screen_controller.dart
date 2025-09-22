import 'package:get/get.dart';
import '../models/country.dart';

class HomeScreenController extends GetxController {
  // Bottom navigation index
  var selectedIndex = 0.obs;

  // Notification count
  var notificationCount = 0.obs;

  // Selected country for CountryDetails tab
  Rx<Country?> selectedCountry = Rx<Country?>(null);

  // Flag for viewing notifications tab
  var viewingNotifications = false.obs;

  /// Change bottom navigation index
  void changeIndex(int index) {
    selectedIndex.value = index;

    // Reset selectedCountry if leaving CountryDetails tab
    if (index != 4) {
      selectedCountry.value = null;
    }

    // Reset notifications flag if leaving Notifications tab
    if (index != 5) {
      viewingNotifications.value = false;
    }
  }

  /// Select a country and switch to CountryDetails tab
  void selectCountry(Country country) {
    selectedCountry.value = country;
    selectedIndex.value = 4; // CountryDetails tab index
  }

  /// Open Notifications tab
  void openNotifications() {
    viewingNotifications.value = true;
    selectedIndex.value = 5; // Notifications tab index
  }

  /// Increment notification count
  void incrementNotification() {
    notificationCount.value++;
  }

  /// Clear all notifications
  void clearNotifications() {
    notificationCount.value = 0;
  }
}
