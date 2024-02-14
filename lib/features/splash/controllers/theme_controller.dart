import 'package:stackfood_multivendor/features/splash/domain/services/splash_service_interface.dart';
import 'package:get/get.dart';

class ThemeController extends GetxController implements GetxService {
  final SplashServiceInterface splashServiceInterface;
  ThemeController({required this.splashServiceInterface}) {
    _loadCurrentTheme();
  }

  bool _darkTheme = false;
  bool get darkTheme => _darkTheme;

  void toggleTheme() {
    _darkTheme = !_darkTheme;
    splashServiceInterface.toggleTheme(_darkTheme);
    update();
  }

  void _loadCurrentTheme() async {
    _darkTheme = await splashServiceInterface.loadCurrentTheme();
    update();
  }
}
