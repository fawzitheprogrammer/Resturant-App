import 'package:stackfood_multivendor/features/address/domain/models/address_model.dart';
import 'package:stackfood_multivendor/features/checkout/controllers/checkout_controller.dart';
import 'package:stackfood_multivendor/features/dashboard/domain/services/dashboard_service_interface.dart';
import 'package:stackfood_multivendor/features/location/controllers/location_controller.dart';
import 'package:stackfood_multivendor/helper/address_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DashboardController extends GetxController implements GetxService {
  final DashboardServiceInterface dashboardServiceInterface;
  DashboardController({required this.dashboardServiceInterface});

  bool _showLocationSuggestion = true;
  bool get showLocationSuggestion => _showLocationSuggestion;

  void hideSuggestedLocation(){
    _showLocationSuggestion = !_showLocationSuggestion;
  }

  Future<bool> checkLocationActive() async {
    bool isActiveLocation = await Geolocator.isLocationServiceEnabled();
    if(isActiveLocation) {
      AddressModel currentAddress = await Get.find<LocationController>().getCurrentLocation(true);
      AddressModel? selectedAddress = AddressHelper.getAddressFromSharedPref();

      double? distance = await Get.find<CheckoutController>().getDistanceInKM(
        LatLng(double.parse(currentAddress.latitude!), double.parse(currentAddress.longitude!)),
        LatLng(double.parse(selectedAddress!.latitude!), double.parse(selectedAddress.longitude!)),
        fromDashboard: true,
      );
      if (kDebugMode) {
        print('======== distance is : $distance');
      }
      return dashboardServiceInterface.checkDistanceForAddressPopup(distance);
    }else{
      return false;
    }
  }
}