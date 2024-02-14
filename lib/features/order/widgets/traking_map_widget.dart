import 'package:stackfood_multivendor/features/address/domain/models/address_model.dart';
import 'package:stackfood_multivendor/features/order/domain/models/order_model.dart';
import 'package:stackfood_multivendor/common/models/restaurant_model.dart';
import 'package:stackfood_multivendor/features/location/controllers/location_controller.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'dart:collection';
import 'dart:ui';

class TrackingMapWidget extends StatefulWidget {
  final OrderModel? track;
  const TrackingMapWidget({super.key, required this.track});

  @override
  State<TrackingMapWidget> createState() => _TrackingMapWidgetState();
}

class _TrackingMapWidgetState extends State<TrackingMapWidget> {
  GoogleMapController? _controller;
  bool _isLoading = true;
  Set<Marker> _markers = HashSet<Marker>();

  @override
  void initState() {
    super.initState();

    // RestaurantLocationCoverage coverage = Provider.of<SplashProvider>(context, listen: false).configModel!.restaurantLocationCoverage!;
    // _deliveryBoyLatLng = LatLng(double.parse(widget.deliveryManModel?.latitude ?? '0'), double.parse(widget.deliveryManModel?.longitude ?? '0'));
    // _addressLatLng = widget.addressModel != null ? LatLng(double.parse(widget.addressModel?.latitude ?? '0'), double.parse(widget.addressModel?.longitude ?? '0')) : const LatLng(0,0);
    // _restaurantLatLng = LatLng(double.parse(coverage.latitude!), double.parse(coverage.longitude!));
  }

  @override
  void dispose() {
    super.dispose();

    _controller?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Container(
      height: 200, width: ResponsiveHelper.isMobilePhone() ? width : 1170.0 - 100.0,
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
      ),
      child: widget.track!.deliveryMan != null ? Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
            child: GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: CameraPosition(target: LatLng(
                double.parse(widget.track!.deliveryAddress!.latitude!), double.parse(widget.track!.deliveryAddress!.longitude!),
              ), zoom: 16),
              minMaxZoomPreference: const MinMaxZoomPreference(0, 16),
              zoomControlsEnabled: true,
              markers: _markers,
              onMapCreated: (GoogleMapController controller) {
                _controller = controller;
                _isLoading = false;
                setMarker(
                  widget.track!.restaurant, widget.track!.deliveryMan,
                  widget.track!.orderType == 'take_away' ? Get.find<LocationController>().position.latitude == 0 ? widget.track!.deliveryAddress : AddressModel(
                    latitude: Get.find<LocationController>().position.latitude.toString(),
                    longitude: Get.find<LocationController>().position.longitude.toString(),
                    address: Get.find<LocationController>().address,
                  ) : widget.track!.deliveryAddress,
                  widget.track!.orderType == 'take_away',
                );
              },
            ),
          ),

          _isLoading ? Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor))) : const SizedBox(),
        ],
      ) : FittedBox(child: Text('no_delivery_man_data_found'.tr)),
    );
  }

  void setMarker(Restaurant? restaurant, DeliveryMan? deliveryMan, AddressModel? addressModel, bool takeAway) async {
    try {
      Uint8List restaurantImageData = await convertAssetToUnit8List(Images.restaurantMarker, width: 100);
      Uint8List deliveryBoyImageData = await convertAssetToUnit8List(Images.deliveryManMarker, width: 100);
      Uint8List destinationImageData = await convertAssetToUnit8List(
        takeAway ? Images.myLocationMarker : Images.userMarker,
        width: takeAway ? 50 : 100,
      );

      // Animate to coordinate
      LatLngBounds? bounds;
      double rotation = 0;
      if(_controller != null) {
        if (double.parse(addressModel!.latitude!) < double.parse(restaurant!.latitude!)) {
          bounds = LatLngBounds(
            southwest: LatLng(double.parse(addressModel.latitude!), double.parse(addressModel.longitude!)),
            northeast: LatLng(double.parse(restaurant.latitude!), double.parse(restaurant.longitude!)),
          );
          rotation = 0;
        }else {
          bounds = LatLngBounds(
            southwest: LatLng(double.parse(restaurant.latitude!), double.parse(restaurant.longitude!)),
            northeast: LatLng(double.parse(addressModel.latitude!), double.parse(addressModel.longitude!)),
          );
          rotation = 180;
        }
      }
      LatLng centerBounds = LatLng(
        (bounds!.northeast.latitude + bounds.southwest.latitude)/2,
        (bounds.northeast.longitude + bounds.southwest.longitude)/2,
      );

      _controller!.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(target: centerBounds, zoom: GetPlatform.isWeb ? 10 : 17)));
      if(!ResponsiveHelper.isWeb()) {
        zoomToFit(_controller, bounds, centerBounds, padding: 1.5);
      }

      // Marker
      _markers = HashSet<Marker>();
      addressModel != null ? _markers.add(Marker(
        markerId: const MarkerId('destination'),
        position: LatLng(double.parse(addressModel.latitude!), double.parse(addressModel.longitude!)),
        infoWindow: InfoWindow(
          title: 'Destination',
          snippet: addressModel.address,
        ),
        icon: GetPlatform.isWeb ? BitmapDescriptor.defaultMarker : BitmapDescriptor.fromBytes(destinationImageData),
      )) : const SizedBox();

      restaurant != null ? _markers.add(Marker(
        markerId: const MarkerId('restaurant'),
        position: LatLng(double.parse(restaurant.latitude!), double.parse(restaurant.longitude!)),
        infoWindow: InfoWindow(
          title: 'restaurant'.tr,
          snippet: restaurant.address,
        ),
        icon: GetPlatform.isWeb ? BitmapDescriptor.defaultMarker : BitmapDescriptor.fromBytes(restaurantImageData),
      )) : const SizedBox();

      deliveryMan != null ? _markers.add(Marker(
        markerId: const MarkerId('delivery_boy'),
        position: LatLng(double.parse(deliveryMan.lat ?? '0'), double.parse(deliveryMan.lng ?? '0')),
        infoWindow: InfoWindow(
          title: 'delivery_man'.tr,
          snippet: deliveryMan.location,
        ),
        rotation: rotation,
        icon: GetPlatform.isWeb ? BitmapDescriptor.defaultMarker : BitmapDescriptor.fromBytes(deliveryBoyImageData),
      )) : const SizedBox();
    }catch(_) {}
    setState(() {});
  }


  Future<void> zoomToFit(GoogleMapController? controller, LatLngBounds? bounds, LatLng centerBounds, {double padding = 0.5}) async {
    bool keepZoomingOut = true;

    while(keepZoomingOut) {
      final LatLngBounds screenBounds = await controller!.getVisibleRegion();
      if(fits(bounds!, screenBounds)){
        keepZoomingOut = false;
        final double zoomLevel = await controller.getZoomLevel() - 0.5;
        controller.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: centerBounds,
          zoom: zoomLevel,
        )));
        break;
      }
      else {
        // Zooming out by 0.1 zoom level per iteration
        final double zoomLevel = await controller.getZoomLevel() - 0.1;
        controller.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: centerBounds,
          zoom: zoomLevel,
        )));
      }
    }
  }

  bool fits(LatLngBounds fitBounds, LatLngBounds screenBounds) {
    final bool northEastLatitudeCheck = screenBounds.northeast.latitude >= fitBounds.northeast.latitude;
    final bool northEastLongitudeCheck = screenBounds.northeast.longitude >= fitBounds.northeast.longitude;

    final bool southWestLatitudeCheck = screenBounds.southwest.latitude <= fitBounds.southwest.latitude;
    final bool southWestLongitudeCheck = screenBounds.southwest.longitude <= fitBounds.southwest.longitude;

    return northEastLatitudeCheck && northEastLongitudeCheck && southWestLatitudeCheck && southWestLongitudeCheck;
  }

  Future<Uint8List> convertAssetToUnit8List(String imagePath, {int width = 50}) async {
    ByteData data = await rootBundle.load(imagePath);
    Codec codec = await instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ImageByteFormat.png))!.buffer.asUint8List();
  }
}
