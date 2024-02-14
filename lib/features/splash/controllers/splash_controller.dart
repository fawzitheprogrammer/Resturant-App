import 'package:stackfood_multivendor/common/widgets/custom_loader_widget.dart';
import 'package:stackfood_multivendor/features/address/controllers/address_controller.dart';
import 'package:stackfood_multivendor/features/auth/controllers/auth_controller.dart';
import 'package:stackfood_multivendor/features/location/controllers/location_controller.dart';
import 'package:stackfood_multivendor/features/location/widgets/pick_map_dialog.dart';
import 'package:stackfood_multivendor/features/splash/domain/models/config_model.dart';
import 'package:stackfood_multivendor/features/splash/domain/services/splash_service_interface.dart';
import 'package:stackfood_multivendor/helper/address_helper.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/helper/route_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashController extends GetxController implements GetxService {
  final SplashServiceInterface splashServiceInterface;

  SplashController({required this.splashServiceInterface});

  ConfigModel? _configModel;
  ConfigModel? get configModel => _configModel;

  bool _firstTimeConnectionCheck = true;
  bool get firstTimeConnectionCheck => _firstTimeConnectionCheck;

  bool _hasConnection = true;
  bool get hasConnection => _hasConnection;

  int _nearestRestaurantIndex = -1;
  int get nearestRestaurantIndex => _nearestRestaurantIndex;

  bool _savedCookiesData = false;
  bool get savedCookiesData => _savedCookiesData;

  String? _htmlText;
  String? get htmlText => _htmlText;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  DateTime get currentTime => DateTime.now();

  Future<bool> getConfigData() async {
    _hasConnection = true;
    _savedCookiesData = getCookiesData();
    Response response = await splashServiceInterface.getConfigData();
    bool isSuccess = false;
    _configModel = splashServiceInterface.prepareConfigData(response);
    isSuccess = _configModel != null;
    update();
    return isSuccess;
  }

  Future<bool> initSharedData() {
    return splashServiceInterface.initSharedData();
  }

  bool? showIntro() {
    return splashServiceInterface.showIntro();
  }

  void disableIntro() {
    splashServiceInterface.disableIntro();
  }

  void setFirstTimeConnectionCheck(bool isChecked) {
    _firstTimeConnectionCheck = isChecked;
  }

  void setNearestRestaurantIndex(int index, {bool notify = true}) {
    _nearestRestaurantIndex = index;
    if(notify) {
      update();
    }
  }

  void saveCookiesData(bool data) {
    splashServiceInterface.saveCookiesData(data);
    _savedCookiesData = true;
    update();
  }

  bool getCookiesData() {
    return splashServiceInterface.getCookiesData();
  }

  void cookiesStatusChange(String? data) {
    splashServiceInterface.cookiesStatusChange(data);
  }

  bool getAcceptCookiesStatus(String data) {
    return splashServiceInterface.getAcceptCookiesStatus(data);
  }

  Future<bool> subscribeMail(String email) async {
    _isLoading = true;
    bool isSuccess = false;
    update();
    isSuccess = await splashServiceInterface.subscribeMail(email);
    _isLoading = false;
    update();
    return isSuccess;
  }

  Future<void> navigateToLocationScreen(String page, {bool offNamed = false, bool offAll = false}) async {
    bool fromSignup = page == RouteHelper.signUp;
    bool fromHome = page == 'home';
    if(!fromHome && AddressHelper.getAddressFromSharedPref() != null) {
      Get.dialog(const CustomLoaderWidget(), barrierDismissible: false);
      Get.find<LocationController>().autoNavigate(
          AddressHelper.getAddressFromSharedPref(), fromSignup, null, false, ResponsiveHelper.isDesktop(Get.context)
      );
    }else if(Get.find<AuthController>().isLoggedIn()) {
      Get.dialog(const CustomLoaderWidget(), barrierDismissible: false);
      await Get.find<AddressController>().getAddressList();
      Get.back();
      if(Get.find<AddressController>().addressList != null && Get.find<AddressController>().addressList!.isEmpty) {
        if(ResponsiveHelper.isDesktop(Get.context)) {
          showGeneralDialog(context: Get.context!, pageBuilder: (_,__,___) {
            return SizedBox(
              height: 300, width: 300,
              child: PickMapDialog(
                fromSignUp: (page == RouteHelper.signUp), canRoute: false, fromAddAddress: false, route: null,
              ),
            );
          });
        } else {
          Get.toNamed(RouteHelper.getPickMapRoute(page, false));
        }
      }else {
        if(offNamed) {
          Get.offNamed(RouteHelper.getAccessLocationRoute(page));
        }else if(offAll) {
          Get.offAllNamed(RouteHelper.getAccessLocationRoute(page));
        }else {
          Get.toNamed(RouteHelper.getAccessLocationRoute(page));
        }
      }
    }else {
      if(ResponsiveHelper.isDesktop(Get.context)) {
        showGeneralDialog(context: Get.context!, pageBuilder: (_,__,___) {
          return SizedBox(
            height: 300, width: 300,
            child: PickMapDialog(
                fromSignUp: (page == RouteHelper.signUp), canRoute: false, fromAddAddress: false, route: null),
          );
        });
      } else {
        Get.toNamed(RouteHelper.getPickMapRoute(page, false));
      }
    }
  }

}