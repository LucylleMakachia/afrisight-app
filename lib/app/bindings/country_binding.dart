import 'package:get/get.dart';
import '../controllers/country_controller.dart';
import '../controllers/favorites_controller.dart';
import '../services/api_service.dart';

class CountryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ApiService>(() => ApiService());
    Get.lazyPut<CountryController>(() => CountryController(apiService: Get.find()));
    Get.lazyPut<FavoritesController>(() => FavoritesController());
  }
}
