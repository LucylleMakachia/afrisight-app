import 'package:get/get.dart';
import '../controllers/favorites_controller.dart';
import '../controllers/home_screen_controller.dart';
import '../controllers/country_controller.dart';
import '../controllers/profile_controller.dart';
import '../services/api_service.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ApiService(), fenix: true);
    Get.lazyPut(() => FavoritesController(), fenix: true);
    Get.lazyPut(() => HomeScreenController(), fenix: true);
    Get.lazyPut(() => CountryController(apiService: Get.find<ApiService>()), fenix: true);
    Get.put(ProfileController(), permanent: true);  
  }
}
