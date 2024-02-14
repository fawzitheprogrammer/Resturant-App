import 'dart:collection';

import 'package:custom_map_markers/custom_map_markers.dart';
import 'package:stackfood_multivendor/features/home/widgets/restaurant_details_sheet_widget.dart';
import 'package:stackfood_multivendor/features/restaurant/controllers/restaurant_controller.dart';
import 'package:stackfood_multivendor/features/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor/common/models/restaurant_model.dart';
import 'package:stackfood_multivendor/helper/address_helper.dart';
import 'package:stackfood_multivendor/util/images.dart';
import 'package:stackfood_multivendor/common/widgets/custom_app_bar_widget.dart';
import 'package:stackfood_multivendor/common/widgets/custom_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapViewScreen extends StatefulWidget {
  const MapViewScreen({super.key});

  @override
  State<MapViewScreen> createState() => _MapViewScreenState();
}

class _MapViewScreenState extends State<MapViewScreen> {
  GoogleMapController? _controller;
  List<MarkerData> _customMarkers = [];
  int _reload = 0;
  Set<Marker> _markers = HashSet<Marker>();

  @override
  void initState() {
    super.initState();

    Get.find<RestaurantController>().getRestaurantList(1, false, fromMap: true);
    Get.find<SplashController>().setNearestRestaurantIndex(-1, notify: false);
  }

  @override
  void dispose() {
    super.dispose();

    _controller?.dispose();
  }

  Widget _customMarker(String path) {
    return Stack(
      children: [
        Image.asset(Images.locationMarker, height: 40, width: 40),
        Positioned(top: 3, left: 0, right: 0, child: Center(
          child: ClipOval(child: CustomImageWidget(image: path, placeholder: Images.restaurantPlaceholder, height: 20, width: 20, fit: BoxFit.cover)),
        )),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(title: 'nearby_restaurants'.tr),
      body: GetBuilder<RestaurantController>(builder: (restController) {
        return restController.restaurantModel != null ? CustomGoogleMapMarkerBuilder(
          customMarkers: _customMarkers,
          builder: (context, markers) {
            if (markers == null) {
              return Stack(children: [

                GoogleMap(
                  initialCameraPosition: CameraPosition(zoom: 12, target: LatLng(
                    double.parse(AddressHelper.getAddressFromSharedPref()!.latitude!),
                    double.parse(AddressHelper.getAddressFromSharedPref()!.longitude!),
                  )),
                  myLocationEnabled: false,
                  compassEnabled: false,
                  zoomControlsEnabled: true,
                  onTap: (position) => Get.find<SplashController>().setNearestRestaurantIndex(-1),
                  minMaxZoomPreference: const MinMaxZoomPreference(0, 16),
                  onMapCreated: (GoogleMapController controller) {

                  },
                ),

                GetBuilder<SplashController>(builder: (splashController) {
                  return splashController.nearestRestaurantIndex != -1 ? Positioned(
                    bottom: 0,
                    child: RestaurantDetailsSheetWidget(callback: (int index) => _controller!.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(
                      double.parse(restController.restaurantModel!.restaurants![index].latitude!),
                      double.parse(restController.restaurantModel!.restaurants![index].longitude!),
                    ), zoom: 16)))),
                  ) : const SizedBox();
                }),

              ]);
            }
            return Stack(children: [

              GoogleMap(
                initialCameraPosition: CameraPosition(zoom: 12, target: LatLng(
                  double.parse(AddressHelper.getAddressFromSharedPref()!.latitude!),
                  double.parse(AddressHelper.getAddressFromSharedPref()!.longitude!),
                )),
                markers: GetPlatform.isWeb ? _markers : markers,
                myLocationEnabled: false,
                compassEnabled: false,
                zoomControlsEnabled: true,
                onTap: (position) => Get.find<SplashController>().setNearestRestaurantIndex(-1),
                minMaxZoomPreference: const MinMaxZoomPreference(0, 16),
                onMapCreated: (GoogleMapController controller) {
                  _controller = controller;
                  if(restController.restaurantModel != null && restController.restaurantModel!.restaurants!.isNotEmpty) {
                    GetPlatform.isWeb? _setMarkerForWeb(restController.restaurantModel!.restaurants!) : _setMarkers(restController.restaurantModel!.restaurants!);
                  }
                },
              ),

              GetBuilder<SplashController>(builder: (splashController) {
                return splashController.nearestRestaurantIndex != -1 ? Positioned(
                  bottom: 0,
                  child: RestaurantDetailsSheetWidget(callback: (int index) => _controller!.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(
                    double.parse(restController.restaurantModel!.restaurants![index].latitude!),
                    double.parse(restController.restaurantModel!.restaurants![index].longitude!),
                  ), zoom: 16)))),
                ) : const SizedBox();
              }),

            ]);
          },
        ) : const Center(child: CircularProgressIndicator());
      }),
    );
  }

  void _setMarkers(List<Restaurant> restaurants) async {
    List<LatLng> latLngs = [];
    _customMarkers = [];
    _customMarkers.add(MarkerData(
      marker: Marker(markerId: const MarkerId('id-0'), position: LatLng(
        double.parse(AddressHelper.getAddressFromSharedPref()!.latitude!),
        double.parse(AddressHelper.getAddressFromSharedPref()!.longitude!),
      )),
      child: Image.asset(Images.myLocationMarker, height: 20, width: 20),
    ));
    int index0 = 0;
    for(int index=0; index<restaurants.length; index++) {
      index0++;
      LatLng latLng = LatLng(double.parse(restaurants[index].latitude!), double.parse(restaurants[index].longitude!));
      latLngs.add(latLng);
      _customMarkers.add(MarkerData(
        marker: Marker(markerId: MarkerId('id-$index0'), position: latLng, onTap: () {
          Get.find<SplashController>().setNearestRestaurantIndex(index);
        }),
        child: _customMarker('${Get.find<SplashController>().configModel!.baseUrls!.restaurantImageUrl}/${restaurants[index].logo}'),
      ));
    }
    // if(!ResponsiveHelper.isWeb() && _controller != null) {
    //   Get.find<LocationController>().zoomToFit(_controller, _latLngs, padding: 0);
    // }
    await Future.delayed(const Duration(milliseconds: 500));
    if(_reload == 0) {
      setState(() {});
      _reload = 1;
    }

    await Future.delayed(const Duration(seconds: 3));
    if(_reload == 1) {
      setState(() {});
      _reload = 2;
    }
  }

  void _setMarkerForWeb(List<Restaurant> restaurants) async {
    List<LatLng> latLngs = [];
    _markers = HashSet<Marker>();
    _markers.add(Marker(markerId: const MarkerId('id-0'), position: LatLng(
      double.parse(AddressHelper.getAddressFromSharedPref()!.latitude!),
      double.parse(AddressHelper.getAddressFromSharedPref()!.longitude!),
    ), icon: BitmapDescriptor.defaultMarker));
    int index0 = 0;
    for(int index=0; index<restaurants.length; index++) {
      index0++;
      LatLng latLng = LatLng(double.parse(restaurants[index].latitude!), double.parse(restaurants[index].longitude!));
      latLngs.add(latLng);
      _markers.add(Marker(markerId: MarkerId('id-$index0'), position: latLng, onTap: () {
        Get.find<SplashController>().setNearestRestaurantIndex(index);
      }, icon: BitmapDescriptor.defaultMarker));
    }
    // if(!ResponsiveHelper.isWeb() && _controller != null) {
    //   Get.find<LocationController>().zoomToFit(_controller, _latLngs, padding: 0);
    // }
    await Future.delayed(const Duration(milliseconds: 500));
    if(_reload == 0) {
      setState(() {});
      _reload = 1;
    }

    await Future.delayed(const Duration(seconds: 3));
    if(_reload == 1) {
      setState(() {});
      _reload = 2;
    }
  }


}

