import 'package:stackfood_multivendor/common/widgets/custom_snackbar_widget.dart';
import 'package:stackfood_multivendor/features/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor/features/address/domain/models/address_model.dart';
import 'package:stackfood_multivendor/features/location/controllers/location_controller.dart';
import 'package:stackfood_multivendor/features/location/widgets/location_search_dialog.dart';
import 'package:stackfood_multivendor/features/location/widgets/permission_dialog.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/images.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:stackfood_multivendor/common/widgets/custom_button_widget.dart';
import 'package:stackfood_multivendor/common/widgets/web_menu_bar.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PickMapScreen extends StatefulWidget {
  final bool fromSignUp;
  final bool fromAddAddress;
  final bool canRoute;
  final String? route;
  final GoogleMapController? googleMapController;
  const PickMapScreen({
    super.key, required this.fromSignUp, required this.fromAddAddress, required this.canRoute,
    required this.route, this.googleMapController,
  });

  @override
  State<PickMapScreen> createState() => _PickMapScreenState();
}

class _PickMapScreenState extends State<PickMapScreen> {
  GoogleMapController? _mapController;
  CameraPosition? _cameraPosition;
  late LatLng _initialPosition;

  @override
  void initState() {
    super.initState();

    if(widget.fromAddAddress) {
      Get.find<LocationController>().setPickData();
    }
    _initialPosition = LatLng(
      double.parse(Get.find<SplashController>().configModel!.defaultLocation!.lat ?? '0'),
      double.parse(Get.find<SplashController>().configModel!.defaultLocation!.lng ?? '0'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ResponsiveHelper.isDesktop(context) ? const WebMenuBar() : null,
      body: SafeArea(child: Center(child: SizedBox(
        width: Dimensions.webMaxWidth,
        child: GetBuilder<LocationController>(builder: (locationController) {
          return Stack(children: [

            GoogleMap(
              initialCameraPosition: CameraPosition(
                target: widget.fromAddAddress ? LatLng(locationController.position.latitude, locationController.position.longitude)
                    : _initialPosition,
                zoom: 16,
              ),
              minMaxZoomPreference: const MinMaxZoomPreference(0, 16),
              onMapCreated: (GoogleMapController mapController) {
                _mapController = mapController;
                if(!widget.fromAddAddress) {
                  Get.find<LocationController>().getCurrentLocation(false, mapController: mapController);
                }
              },
              zoomControlsEnabled: false,
              onCameraMove: (CameraPosition cameraPosition) {
                _cameraPosition = cameraPosition;
              },
              onCameraMoveStarted: () {
                locationController.disableButton();
              },
              onCameraIdle: () {
                Get.find<LocationController>().updatePosition(_cameraPosition, false);
              },
            ),

            Center(child: !locationController.loading ? Image.asset(Images.pickMarker, height: 50, width: 50)
                : const CircularProgressIndicator()),

            Positioned(
              top: Dimensions.paddingSizeLarge, left: Dimensions.paddingSizeSmall, right: Dimensions.paddingSizeSmall,
              child: InkWell(
                onTap: () => Get.dialog(LocationSearchDialog(mapController: _mapController)),
                child: Container(
                  height: 50,
                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                  decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
                  child: Row(children: [
                    Icon(Icons.location_on, size: 25, color: Theme.of(context).primaryColor),
                    const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                    Expanded(
                      child: Text(
                        locationController.pickAddress!,
                        style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeLarge), maxLines: 1, overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: Dimensions.paddingSizeSmall),
                    Icon(Icons.search, size: 25, color: Theme.of(context).textTheme.bodyLarge!.color),
                  ]),
                ),
              ),
            ),

            Positioned(
              bottom: 80, right: Dimensions.paddingSizeSmall,
              child: FloatingActionButton(
                mini: true, backgroundColor: Theme.of(context).cardColor,
                onPressed: () => _checkPermission(() {
                  Get.find<LocationController>().getCurrentLocation(false, mapController: _mapController);
                }),
                child: Icon(Icons.my_location, color: Theme.of(context).primaryColor),
              ),
            ),

            Positioned(
              bottom: Dimensions.paddingSizeLarge, left: Dimensions.paddingSizeSmall, right: Dimensions.paddingSizeSmall,
              child: CustomButtonWidget(
                buttonText: locationController.inZone ? widget.fromAddAddress ? 'pick_address'.tr : 'pick_location'.tr
                    : 'service_not_available_in_this_area'.tr,
                isLoading: locationController.isLoading,
                onPressed: (locationController.buttonDisabled || locationController.loading) ? null
                    : () => _onPickAddressButtonPressed(locationController),
              ),
            ),

          ]);
        }),
      ))),
    );
  }

  void _onPickAddressButtonPressed(LocationController locationController) {
    if(locationController.pickPosition.latitude != 0 && locationController.pickAddress!.isNotEmpty) {
      if(widget.fromAddAddress) {
        if(widget.googleMapController != null) {
          widget.googleMapController!.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(
            locationController.pickPosition.latitude, locationController.pickPosition.longitude,
          ), zoom: 17)));
          locationController.addAddressData();
        }
        Get.back();
      }else {
        AddressModel address = AddressModel(
          latitude: locationController.pickPosition.latitude.toString(),
          longitude: locationController.pickPosition.longitude.toString(),
          addressType: 'others', address: locationController.pickAddress,
        );
        locationController.saveAddressAndNavigate(address, widget.fromSignUp, widget.route, widget.canRoute, ResponsiveHelper.isDesktop(Get.context));
      }
    }else {
      showCustomSnackBar('pick_an_address'.tr);
    }
  }

  void _checkPermission(Function onTap) async {
    LocationPermission permission = await Geolocator.checkPermission();
    if(permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if(permission == LocationPermission.denied) {
      showCustomSnackBar('you_have_to_allow'.tr);
    }else if(permission == LocationPermission.deniedForever) {
      Get.dialog(const PermissionDialog());
    }else {
      onTap();
    }
  }
}
