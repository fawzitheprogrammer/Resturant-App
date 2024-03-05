import 'package:swift_tech_resto/features/auth/controllers/auth_controller.dart';
import 'package:swift_tech_resto/features/favourite/controllers/favourite_controller.dart';
import 'package:swift_tech_resto/helper/route_helper.dart';
import 'package:swift_tech_resto/common/widgets/custom_snackbar_widget.dart';
import 'package:get/get.dart';

class ApiChecker {
  static void checkApi(Response response, {bool showToaster = false}) {
    if (response.statusCode == 401) {
      Get.find<AuthController>().clearSharedData();
      Get.find<FavouriteController>().removeFavourites();
      Get.offAllNamed(GetPlatform.isWeb
          ? RouteHelper.getInitialRoute()
          : RouteHelper.getSplashRoute(null, null));
      // Get.offAllNamed(RouteHelper.getSignInRoute(RouteHelper.splash));
    } else {
      showCustomSnackBar(response.statusText, showToaster: showToaster);
    }
  }
}
