import 'dart:collection';
import 'package:stackfood_multivendor/features/auth/widgets/zone_selection_widget.dart';
import 'package:stackfood_multivendor/features/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor/features/auth/controllers/restaurant_registration_controller.dart';
import 'package:stackfood_multivendor/features/auth/domain/models/zone_model.dart';
import 'package:stackfood_multivendor/features/cuisine/controllers/cuisine_controller.dart';
import 'package:stackfood_multivendor/features/location/widgets/location_search_dialog.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/images.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:stackfood_multivendor/common/widgets/custom_app_bar_widget.dart';
import 'package:stackfood_multivendor/common/widgets/custom_button_widget.dart';
import 'package:stackfood_multivendor/common/widgets/custom_dropdown_widget.dart';
import 'package:stackfood_multivendor/common/widgets/custom_snackbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SelectLocationViewWidget extends StatefulWidget {
  final bool fromView;
  final GoogleMapController? mapController;
  final bool zoneCuisinesView;
  const SelectLocationViewWidget({super.key, required this.fromView, this.mapController, this.zoneCuisinesView = false});

  @override
  State<SelectLocationViewWidget> createState() => _SelectLocationViewWidgetState();
}

class _SelectLocationViewWidgetState extends State<SelectLocationViewWidget> {
  late CameraPosition _cameraPosition;
  final Set<Polygon> _polygons = HashSet<Polygon>();
  GoogleMapController? _mapController;
  GoogleMapController? _screenMapController;
  TextEditingController _c = TextEditingController();

  List<DropdownItem<int>> _generateDropDownZoneList(List<ZoneModel>? zoneList, List<int>? zoneIds) {
    List<DropdownItem<int>> dropDownZoneList = [];
    if(zoneList != null && zoneIds != null) {
      for(int index=0; index<zoneList.length; index++) {
        if(zoneIds.contains(zoneList[index].id)) {
          dropDownZoneList.add(DropdownItem<int>(value: index, child: SizedBox(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('${zoneList[index].name}'.tr),
            ),
          )));
        }
      }
    }
    return dropDownZoneList;
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RestaurantRegistrationController>(builder: (restaurantRegController) {
      List<DropdownItem<int>> zoneList = _generateDropDownZoneList(restaurantRegController.zoneList, restaurantRegController.zoneIds);

      return Card(
        elevation: 0,
        child: Center(
          child: SizedBox(width: Dimensions.webMaxWidth, child: Padding(
            padding: EdgeInsets.all(widget.fromView ? 0 : Dimensions.paddingSizeSmall),
            child: SingleChildScrollView (
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                !ResponsiveHelper.isDesktop(context) ? Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Expanded(child: ZoneSelectionWidget(restaurantRegController: restaurantRegController, zoneList: zoneList)),
                  SizedBox(width: widget.fromView ? Dimensions.paddingSizeSmall : 0),

                  widget.fromView ? Expanded(child: cuisineView()) : const SizedBox(),
                ]) : const SizedBox(),
                !ResponsiveHelper.isDesktop(context) ? const SizedBox(height: Dimensions.paddingSizeExtraLarge) : const SizedBox(),


                !ResponsiveHelper.isDesktop(context) ? mapView(restaurantRegController) : const SizedBox(),
                !ResponsiveHelper.isDesktop(context) ? SizedBox(height: !widget.fromView ? Dimensions.paddingSizeSmall : 0) : const SizedBox(),

                (widget.zoneCuisinesView && ResponsiveHelper.isDesktop(context)) ? Row(children: [
                    Expanded(child: ZoneSelectionWidget(restaurantRegController: restaurantRegController, zoneList: zoneList)),
                    SizedBox(width: widget.fromView ? Dimensions.paddingSizeSmall : 0),

                    widget.fromView ?  Expanded(child: cuisineView()) : const SizedBox(),
                  ],
                ): const SizedBox(),

                (!widget.zoneCuisinesView && ResponsiveHelper.isDesktop(context)) ?
                 Row(
                   children: [
                     widget.zoneCuisinesView ? Expanded(child: Column( mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                       ZoneSelectionWidget(restaurantRegController: restaurantRegController, zoneList: zoneList),
                       SizedBox(height: widget.fromView ? Dimensions.paddingSizeOverLarge : 0),
                       SizedBox(height: widget.fromView ? Dimensions.paddingSizeSmall : 0),

                       widget.fromView ? cuisineView() : const SizedBox(),
                     ])) : const SizedBox(),

                     SizedBox(width: widget.fromView ? Dimensions.paddingSizeSmall : 0),
                     Expanded(child: mapView(restaurantRegController)),
                   ],
                 ): const SizedBox(),

                !widget.fromView ? CustomButtonWidget(
                  buttonText: 'set_location'.tr,
                  onPressed: () {
                    try{
                      widget.mapController!.moveCamera(CameraUpdate.newCameraPosition(_cameraPosition));
                      Get.back();
                    }catch(e){
                      showCustomSnackBar('please_setup_the_marker_in_your_required_location'.tr);
                    }
                  },
                ) : const SizedBox()

              ]),
            ),
          )),
        ),
      );
    });
  }

  Widget mapView(RestaurantRegistrationController restaurantRegController) {
    return restaurantRegController.zoneList!.isNotEmpty ? Container(
      height: ResponsiveHelper.isDesktop(context) ? widget.fromView ? 180: MediaQuery.of(context).size.height * 0.5 : widget.fromView ? 125 : (context.height * 0.55),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
        border: Border.all(width: 1, color: Theme.of(context).primaryColor),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
        child: Stack(clipBehavior: Clip.none, children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(
                double.parse(Get.find<SplashController>().configModel!.defaultLocation!.lat ?? '0'),
                double.parse(Get.find<SplashController>().configModel!.defaultLocation!.lng ?? '0'),
              ), zoom: 16,
            ),
            minMaxZoomPreference: const MinMaxZoomPreference(0, 16),
            zoomControlsEnabled: false,
            compassEnabled: false,
            indoorViewEnabled: true,
            mapToolbarEnabled: false,
            myLocationEnabled: false,
            zoomGesturesEnabled: true,
            polygons: _polygons,
            onCameraIdle: () {
              restaurantRegController.setLocation(_cameraPosition.target);
              if(!widget.fromView) {
                widget.mapController!.moveCamera(CameraUpdate.newCameraPosition(_cameraPosition));
              }
            },
            onCameraMove: ((position) => _cameraPosition = position),
            onMapCreated: (GoogleMapController controller) {
              if(widget.fromView) {
                _mapController = controller;
              }else {
                _screenMapController = controller;
              }
            },
          ),
          Center(child: Image.asset(Images.pickMarker, height: 50, width: 50)),

          widget.fromView ? Positioned(top: 10, left: 10,
            child: InkWell(
              onTap: () async {
                var p = await Get.dialog(LocationSearchDialog(mapController: widget.fromView ? _mapController : _screenMapController));
                Position? position = p;
                if(position != null) {
                  _cameraPosition = CameraPosition(target: LatLng(position.latitude, position.longitude), zoom: 16);
                  if(!widget.fromView) {
                    widget.mapController!.moveCamera(CameraUpdate.newCameraPosition(_cameraPosition));
                    restaurantRegController.setLocation(_cameraPosition.target);
                  }
                }
              },
              child: Container(
                height: 30, width: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                  color: Theme.of(context).cardColor,
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 2)],
                ),
                padding: const EdgeInsets.only(left: 10),
                alignment: Alignment.centerLeft,
                child: Text('search'.tr, style: robotoRegular.copyWith(color: Theme.of(context).hintColor)),
              ),
            ),
          ) : const SizedBox(),

          widget.fromView ? Positioned(
            top: 10, right: 0,
            child: InkWell(
              onTap: () {
                Get.to(Scaffold(
                    appBar: CustomAppBarWidget(title: 'set_your_store_location'.tr),
                    body: SelectLocationViewWidget(fromView: false, mapController: _mapController)),
                );
              },
              child: Container(
                width: 30, height: 30,
                margin: const EdgeInsets.only(right: Dimensions.paddingSizeLarge),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.radiusSmall), color: Colors.white),
                child: Icon(Icons.fullscreen, color: Theme.of(context).primaryColor, size: 20),
              ),
            ),
          ) : const SizedBox(),
        ]),
      ),
    ) : const SizedBox();
  }

  Widget cuisineView() {
    return GetBuilder<CuisineController>(
      builder: (cuisineController) {
        List<int> cuisines = [];
        if(cuisineController.cuisineModel != null) {
          for(int index=0; index<cuisineController.cuisineModel!.cuisines!.length; index++) {
            if(cuisineController.cuisineModel!.cuisines![index].status == 1 && !cuisineController.selectedCuisines!.contains(index)) {
              cuisines.add(index);
            }
          }
        }
        return Column(children: [

          Autocomplete<int>(
            optionsBuilder: (TextEditingValue value) {
              if(value.text.isEmpty) {
                return const Iterable<int>.empty();
              }else {
                return cuisines.where((cuisine) => cuisineController.cuisineModel!.cuisines![cuisine].name!.toLowerCase().contains(value.text.toLowerCase()));
              }
            },
            fieldViewBuilder: (context, controller, node, onComplete) {
              _c = controller;
              return Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                  // boxShadow: [BoxShadow(color: Colors.grey[Get.isDarkMode ? 800 : 200], spreadRadius: 2, blurRadius: 5, offset: Offset(0, 5))],
                ),
                child: TextField(
                  controller: controller,
                  focusNode: node,
                  textInputAction: TextInputAction.done,
                  onEditingComplete: () {
                    onComplete();
                    controller.text = '';
                  },
                  decoration: InputDecoration(
                    hintText: 'cuisines'.tr,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                      borderSide: BorderSide(style: BorderStyle.solid, width: 0.3, color: Theme.of(context).primaryColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                      borderSide: BorderSide(style: BorderStyle.solid, width: 1, color: Theme.of(context).primaryColor),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                      borderSide: BorderSide(style: BorderStyle.solid, width: 0.3, color: Theme.of(context).primaryColor),
                    ),
                  ),
                ),
              );
            },
            optionsViewBuilder: (context, Function(int i) onSelected, data) {
              return Align(
                alignment: Alignment.topLeft,
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: ResponsiveHelper.isDesktop(context) ? context.width*0.3 : context.width *0.4),
                  child: ListView.builder(
                    itemCount: data.length,
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemBuilder: (context, index) => InkWell(
                      onTap: () => onSelected(data.elementAt(index)),
                      child: Container(
                        decoration: BoxDecoration(color: Theme.of(context).cardColor),
                        padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall, horizontal: Dimensions.paddingSizeExtraSmall),
                        child: Text(cuisineController.cuisineModel!.cuisines![data.elementAt(index)].name ?? ''),
                      ),
                    ),
                  ),
                ),
              );
            },
            displayStringForOption: (value) => cuisineController.cuisineModel!.cuisines![value].name!,
            onSelected: (int value) {
              _c.text = '';
              cuisineController.setSelectedCuisineIndex(value, true);
            },
          ),
          SizedBox(height: cuisineController.selectedCuisines!.isNotEmpty ? Dimensions.paddingSizeSmall : 0),

          SizedBox(
            height: cuisineController.selectedCuisines!.isNotEmpty ? 40 : 0,
            child: ListView.builder(
              itemCount: cuisineController.selectedCuisines!.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
                  margin: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                  ),
                  child: Row(children: [
                    Text(
                      cuisineController.cuisineModel!.cuisines![cuisineController.selectedCuisines![index]].name!,
                      style: robotoRegular.copyWith(color: Theme.of(context).cardColor),
                    ),
                    InkWell(
                      onTap: () => cuisineController.removeCuisine(index),
                      child: Padding(
                        padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                        child: Icon(Icons.close, size: 15, color: Theme.of(context).cardColor),
                      ),
                    ),
                  ]),
                );
              },
            ),
          ),
        ]);
      }
    );
  }

}



