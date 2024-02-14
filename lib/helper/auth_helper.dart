import 'package:stackfood_multivendor/features/auth/controllers/auth_controller.dart';
import 'package:get/get.dart';

class AuthHelper {

  static bool isGuestLoggedIn() {
    return Get.find<AuthController>().isGuestLoggedIn();
  }

  static String getGuestId() {
    return Get.find<AuthController>().getGuestId();
  }

  static bool isLoggedIn() {
    return Get.find<AuthController>().isLoggedIn();
  }
}