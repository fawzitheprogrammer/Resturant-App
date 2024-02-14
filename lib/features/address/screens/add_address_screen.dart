import 'package:country_code_picker/country_code_picker.dart';
import 'package:stackfood_multivendor/common/widgets/custom_button_widget.dart';
import 'package:stackfood_multivendor/common/widgets/custom_text_field_widget.dart';
import 'package:stackfood_multivendor/common/widgets/footer_view_widget.dart';
import 'package:stackfood_multivendor/features/language/controllers/localization_controller.dart';
import 'package:stackfood_multivendor/features/address/controllers/address_controller.dart';
import 'package:stackfood_multivendor/features/auth/controllers/auth_controller.dart';
import 'package:stackfood_multivendor/features/location/controllers/location_controller.dart';
import 'package:stackfood_multivendor/features/address/domain/models/address_model.dart';
import 'package:stackfood_multivendor/features/location/screens/pick_map_screen.dart';
import 'package:stackfood_multivendor/features/location/widgets/location_search_dialog.dart';
import 'package:stackfood_multivendor/features/location/widgets/permission_dialog.dart';
import 'package:stackfood_multivendor/features/profile/controllers/profile_controller.dart';
import 'package:stackfood_multivendor/features/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor/helper/custom_validator.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/helper/route_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/images.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:stackfood_multivendor/common/widgets/custom_app_bar_widget.dart';
import 'package:stackfood_multivendor/common/widgets/custom_snackbar_widget.dart';
import 'package:stackfood_multivendor/common/widgets/menu_drawer_widget.dart';
import 'package:stackfood_multivendor/common/widgets/web_page_title_widget.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';
import 'package:phone_number/phone_number.dart';

class AddAddressScreen extends StatefulWidget {
  final bool fromCheckout;
  final int? zoneId;
  final AddressModel? address;
  final bool forGuest;

  const AddAddressScreen({super.key, required this.fromCheckout, this.zoneId, this.address, this.forGuest = false});

  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  final ScrollController scrollController = ScrollController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _contactPersonNameController = TextEditingController();
  final TextEditingController _contactPersonNumberController = TextEditingController();
  final TextEditingController _streetNumberController = TextEditingController();
  final TextEditingController _houseController = TextEditingController();
  final TextEditingController _floorController = TextEditingController();
  final TextEditingController _levelController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final FocusNode _addressNode = FocusNode();
  final FocusNode _nameNode = FocusNode();
  final FocusNode _numberNode = FocusNode();
  final FocusNode _streetNode = FocusNode();
  final FocusNode _houseNode = FocusNode();
  final FocusNode _floorNode = FocusNode();
  final FocusNode _levelNode = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  CameraPosition? _cameraPosition;
  late LatLng _initialPosition;
  bool _otherSelect = false;
  String? _countryDialCode = Get.find<AuthController>().getUserCountryCode().isNotEmpty
      ? Get.find<AuthController>().getUserCountryCode()
      : CountryCode.fromCountryCode(Get.find<SplashController>().configModel!.country!).dialCode;

  @override
  void initState() {
    super.initState();

    _initCall();
  }

  void _initCall() {
    Get.find<LocationController>().setAddressTypeIndex(0, notify: false);
    if (Get.find<AuthController>().isLoggedIn() && Get.find<ProfileController>().userInfoModel == null) {
      Get.find<ProfileController>().getUserInfo();
    }
    if (widget.address == null) {
      _initialPosition = LatLng(
        double.parse(Get.find<SplashController>().configModel?.defaultLocation?.lat ?? '0'),
        double.parse(Get.find<SplashController>().configModel?.defaultLocation?.lng ?? '0'),
      );
    } else {
      Get.find<LocationController>().updateAddress(widget.address!);
      _initialPosition = LatLng(
        double.parse(widget.address?.latitude ?? '0'),
        double.parse(widget.address?.longitude ?? '0'),
      );

      if (widget.address?.addressType == 'home') {
        Get.find<LocationController>().setAddressTypeIndex(0, notify: false);
      } else if (widget.address?.addressType == 'office') {
        Get.find<LocationController>().setAddressTypeIndex(1, notify: false);
      } else {
        Get.find<LocationController>().setAddressTypeIndex(2, notify: false);
        _levelController.text = widget.address?.addressType ?? '';
        _otherSelect = true;
      }

      _splitPhoneNumber(widget.address!.contactPersonNumber!);
      _contactPersonNameController.text = widget.address!.contactPersonName ?? '';
      _emailController.text = widget.address!.email ?? '';
      _streetNumberController.text = widget.address!.road ?? '';
      _houseController.text = widget.address!.house ?? '';
      _floorController.text = widget.address!.floor ?? '';
    }
  }

  void _splitPhoneNumber(String number) async {
    if (GetPlatform.isAndroid || GetPlatform.isIOS) {
      try {
        PhoneNumber phoneNumber = await PhoneNumberUtil().parse(number);
        _countryDialCode = '+${phoneNumber.countryCode}';
        _contactPersonNumberController.text = phoneNumber.nationalNumber;
      } catch (_) {}
    } else if (GetPlatform.isWeb) {
      if (number.contains(_countryDialCode!)) {
        _contactPersonNumberController.text = number.replaceAll(_countryDialCode!, '');
      } else {
        _contactPersonNumberController.text = number;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDesktop = ResponsiveHelper.isDesktop(context);
    return Scaffold(
      appBar: CustomAppBarWidget(
        title: widget.forGuest ? 'delivery_address'.tr
            : widget.address == null ? 'add_new_address'.tr
            : 'update_address'.tr,
      ),
      endDrawer: const MenuDrawerWidget(),
      endDrawerEnableOpenDragGesture: false,
      body: SafeArea(
        child: GetBuilder<ProfileController>(builder: (profileController) {
          if (profileController.userInfoModel != null && _contactPersonNameController.text.isEmpty) {
            _contactPersonNameController.text = '${profileController.userInfoModel!.fName} ${profileController.userInfoModel!.lName}';
            _splitPhoneNumber(profileController.userInfoModel!.phone!);
          }

          return GetBuilder<LocationController>(builder: (locationController) {
            _addressController.text = locationController.address ?? '';

            return Column(children: [
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController, 
                  physics: const BouncingScrollPhysics(), 
                  padding: EdgeInsets.all(isDesktop ? 0 : Dimensions.paddingSizeSmall),
                  child: Column(children: [
                    WebScreenTitleWidget(title: widget.address == null ? 'add_new_address'.tr : 'update_address'.tr),
                    const SizedBox(height: Dimensions.paddingSizeLarge),
                    
                    FooterViewWidget(
                      child: Center(
                        child: SizedBox(
                          width: Dimensions.webMaxWidth,
                          child: isDesktop ? Row(crossAxisAlignment: CrossAxisAlignment.start, children: [

                            Expanded(flex: 6, child: addressSectionWidget(locationController, isDesktop)),
                            const SizedBox(width: Dimensions.paddingSizeLarge),

                            Expanded(flex: 4, child: informationSectionWidget(locationController, isDesktop)),

                          ]) : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            addressSectionWidget(locationController, isDesktop),
                            
                            informationSectionWidget(locationController, isDesktop),
                          ]),
                        ),
                      ),
                    ),
                  ]),
                ),
              ), 
              !isDesktop ? GetBuilder<AddressController>(
                builder: (addressController) {
                  return CustomButtonWidget(
                    radius: Dimensions.paddingSizeSmall,
                    width: Dimensions.webMaxWidth,
                    margin: EdgeInsets.all(isDesktop ? 0 : Dimensions.paddingSizeSmall),
                    buttonText: widget.forGuest ? 'continue'.tr
                        : widget.address == null ? 'save_location'.tr
                        : 'update_address'.tr,
                    isLoading: addressController.isLoading,
                    onPressed: locationController.loading ? null : () => _onSaveButtonPressed(locationController),
                  );
                }
              ) : const SizedBox(),
            ]);
          });
        }),
      ),
    );
  }

  Widget addressSectionWidget(LocationController locationController, bool isDesktop) {
    return Container(
      decoration: isDesktop ? BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10)],
      ) : const BoxDecoration(),
      padding: EdgeInsets.all(isDesktop ? Dimensions.paddingSizeLarge : 0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          height: isDesktop ? 260 : 145,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
            border: Border.all(width: 2, color: Theme.of(context).primaryColor),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
            child: Stack(clipBehavior: Clip.none, children: [
              
              GoogleMap(
                initialCameraPosition: CameraPosition(target: _initialPosition, zoom: 17),
                minMaxZoomPreference: const MinMaxZoomPreference(0, 16),
                onTap: isDesktop ? null : (latLng) {
                  Get.toNamed(
                    RouteHelper.getPickMapRoute('add-address', false),
                    arguments: PickMapScreen(
                      fromAddAddress: true,
                      fromSignUp: false,
                      googleMapController: locationController.mapController,
                      route: null,
                      canRoute: false,
                    ),
                  );
                  },
                zoomControlsEnabled: false,
                compassEnabled: false,
                indoorViewEnabled: true,
                mapToolbarEnabled: false,
                onCameraIdle: () {
                  locationController.updatePosition(_cameraPosition, true);
                },
                onCameraMove: ((position) => _cameraPosition = position),
                onMapCreated: (GoogleMapController controller) {
                  locationController.setMapController(controller);
                  if (widget.address == null) {
                    locationController.getCurrentLocation(true, mapController: controller);
                  }
                },
              ),
              
              locationController.loading ? const Center(child: CircularProgressIndicator()) : const SizedBox(),
              
              Center(
                child: !locationController.loading 
                    ? Image.asset(Images.pickMarker, height: 50, width: 50) 
                    : const CircularProgressIndicator(),
              ),
              
              Positioned(
                bottom: 10, right: 0,
                child: InkWell(
                  onTap: () => _checkPermission(() {
                    locationController.getCurrentLocation(true, mapController: locationController.mapController);
                  }),
                  child: Container(
                    width: 30, height: 30,
                    margin: const EdgeInsets.only(right: Dimensions.paddingSizeLarge),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.radiusSmall), color: Colors.white),
                    child: Icon(Icons.my_location, color: Theme.of(context).primaryColor, size: 20),
                  ),
                ),
              ),
              
              Positioned(
                top: 10, right: 0,
                child: InkWell(
                  onTap: () {
                    Get.toNamed(
                      RouteHelper.getPickMapRoute('add-address', false),
                      arguments: PickMapScreen(
                        fromAddAddress: true, fromSignUp: false,
                        googleMapController: locationController.mapController,
                        route: null, canRoute: false,
                      ),
                    );
                  },
                  child: Container(
                    width: 30, height: 30,
                    margin: const EdgeInsets.only(right: Dimensions.paddingSizeLarge),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.radiusSmall), color: Colors.white),
                    child: Icon(Icons.fullscreen, color: Theme.of(context).primaryColor, size: 20),
                  ),
                ),
              ),
              
              Positioned(
                top: 10,
                left: 10,
                child: InkWell(
                  onTap: () async {
                    var p = await Get.dialog(LocationSearchDialog(mapController: locationController.mapController));
                    Position? position = p;
                    if (position != null) {
                      _cameraPosition = CameraPosition(target: LatLng(position.latitude, position.longitude), zoom: 16);
                      locationController.mapController!.moveCamera(CameraUpdate.newCameraPosition(_cameraPosition!));
                      locationController.updatePosition(_cameraPosition, true);
                    }
                  },
                  child: Container(
                    height: 30,
                    width: 200,
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
              ),
            ]),
          ),
        ),
        const SizedBox(height: Dimensions.paddingSizeSmall),
        
        Center(child: Text(
          'add_the_location_correctly'.tr,
          style: robotoRegular.copyWith(color: Theme.of(context).disabledColor, fontSize: Dimensions.fontSizeExtraSmall),
        )),
        const SizedBox(height: Dimensions.paddingSizeLarge),
        
        Text(
          'label_as'.tr,
          style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
        ),
        const SizedBox(height: Dimensions.paddingSizeSmall),
        
        SizedBox(
          height: 50,
          child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: locationController.addressTypeList.length,
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
              child: InkWell(
                onTap: () {
                  _otherSelect = index == 2;
                  locationController.setAddressTypeIndex(index);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical: Dimensions.paddingSizeSmall),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                    color: locationController.addressTypeIndex == index ? Theme.of(context).primaryColor : Theme.of(context).cardColor,
                    boxShadow: const [BoxShadow(color: Colors.black12, spreadRadius: 1, blurRadius: 5)],
                  ),
                  child: Row(children: [
                    SizedBox(
                      height: 24, width: 24,
                      child: Image.asset(
                        index == 0 ? Images.homeIcon
                            : index == 1 ? Images.workIcon
                            : Images.otherIcon,
                        color: locationController.addressTypeIndex == index
                            ? Theme.of(context).cardColor
                            : Theme.of(context).disabledColor,
                      ),
                    ),
                    const SizedBox(width: Dimensions.paddingSizeSmall),
                    
                    Text(
                      index == 0 ? 'home'.tr 
                          : index == 1 ? 'office'.tr
                          : 'others'.tr,
                      style: robotoRegular.copyWith(color: locationController.addressTypeIndex == index
                          ? Theme.of(context).cardColor
                          : Theme.of(context).disabledColor,
                      ),
                    ),
                  ]),
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: _otherSelect ? Dimensions.paddingSizeLarge : 0),
        
        _otherSelect ? CustomTextFieldWidget(
          titleText: '${'level_name'.tr}(${'optional'.tr})',
          inputType: TextInputType.text,
          controller: _levelController,
          focusNode: _levelNode,
          nextFocus: _addressNode,
          capitalization: TextCapitalization.words,
          showBorder: true,
          showTitle: isDesktop,
        ) : const SizedBox(),
        const SizedBox(height: Dimensions.paddingSizeLarge),
        
        CustomTextFieldWidget(
          titleText: 'delivery_address'.tr,
          inputType: TextInputType.streetAddress,
          focusNode: _addressNode,
          nextFocus: _nameNode,
          controller: _addressController,
          onChanged: (text) => locationController.setPlaceMark(text),
          showBorder: true,
          showTitle: isDesktop,
        ),
        const SizedBox(height: Dimensions.paddingSizeLarge),
        
      ]),
    );
  }

  Widget informationSectionWidget(LocationController locationController, bool isDesktop) {
    return Container(
      decoration: isDesktop ? BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10)],
      ) : const BoxDecoration(),
      padding: EdgeInsets.all(isDesktop ? Dimensions.paddingSizeLarge : 0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        CustomTextFieldWidget(
          titleText: 'contact_person_name'.tr,
          showTitle: isDesktop,
          inputType: TextInputType.name,
          controller: _contactPersonNameController,
          focusNode: _nameNode,
          nextFocus: _numberNode,
          capitalization: TextCapitalization.words,
          showBorder: true,
        ),
        const SizedBox(height: Dimensions.paddingSizeLarge),
        
        CustomTextFieldWidget(
          titleText: 'contact_person_number'.tr,
          controller: _contactPersonNumberController,
          focusNode: _numberNode,
          showTitle: isDesktop,
          nextFocus: widget.forGuest ? _emailFocus : _streetNode,
          inputType: TextInputType.phone,
          isPhone: true,
          onCountryChanged: (CountryCode countryCode) {
            _countryDialCode = countryCode.dialCode;
          },
          countryDialCode: _countryDialCode ?? Get.find<LocalizationController>().locale.countryCode,
        ),
        const SizedBox(height: Dimensions.paddingSizeLarge),
        
        widget.forGuest ? CustomTextFieldWidget(
          showTitle: isDesktop,
          titleText: '${'email'.tr} (${'optional'.tr})',
          controller: _emailController,
          focusNode: _emailFocus,
          nextFocus: _streetNode,
          inputType: TextInputType.emailAddress,
        ) : const SizedBox(),
        SizedBox(height: widget.forGuest ? Dimensions.paddingSizeLarge : 0),
        
        CustomTextFieldWidget(
          titleText: 'street_number'.tr,
          showTitle: isDesktop,
          inputType: TextInputType.streetAddress,
          focusNode: _streetNode,
          nextFocus: _houseNode,
          controller: _streetNumberController,
        ),
        const SizedBox(height: Dimensions.paddingSizeLarge),
        
        Row(children: [
          Expanded(
            child: CustomTextFieldWidget(
              titleText: 'house'.tr,
              showTitle: isDesktop,
              inputType: TextInputType.text,
              focusNode: _houseNode,
              nextFocus: _floorNode,
              controller: _houseController,
            ),
          ),
          const SizedBox(width: Dimensions.paddingSizeSmall),
          
          Expanded(
            child: CustomTextFieldWidget(
              titleText: 'floor'.tr,
              showTitle: isDesktop,
              inputType: TextInputType.text,
              focusNode: _floorNode,
              inputAction: TextInputAction.done,
              controller: _floorController,
            ),
          ),
        ]),
        const SizedBox(height: Dimensions.paddingSizeOverLarge),
        
        isDesktop ? GetBuilder<AddressController>(
          builder: (addressController) {
            return CustomButtonWidget(
              radius: Dimensions.paddingSizeSmall,
              width: Dimensions.webMaxWidth,
              margin: EdgeInsets.all(isDesktop ? 0 : Dimensions.paddingSizeSmall),
              buttonText: widget.forGuest ? 'continue'.tr
                  : widget.address == null ? 'save_location'.tr
                  : 'update_address'.tr,
              isLoading: addressController.isLoading,
              onPressed: locationController.loading ? null : () => _onSaveButtonPressed(locationController),
            );
          }
        ) : const SizedBox(),
        const SizedBox(height: Dimensions.paddingSizeLarge),
        
      ]),
    );
  }

  void _onSaveButtonPressed(LocationController locationController) async {
    String numberWithCountryCode = _countryDialCode! + _contactPersonNumberController.text;
    PhoneValid phoneValid = await CustomValidator.isPhoneValid(numberWithCountryCode);
    numberWithCountryCode = phoneValid.phone;

    AddressModel? addressModel = _prepareAddressModel(locationController, phoneValid.isValid, numberWithCountryCode);
    if (addressModel == null) {
      return;
    }

    if (widget.forGuest) {
      addressModel.email = _emailController.text;
      Get.back(result: addressModel);
    } else {
      if (widget.address == null) {
        _addAddress(addressModel);
      } else {
        _updateAddress(addressModel);
      }
    }
  }

  void _checkPermission(Function onTap) async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied) {
      showCustomSnackBar('you_have_to_allow'.tr);
    } else if (permission == LocationPermission.deniedForever) {
      Get.dialog(const PermissionDialog());
    } else {
      onTap();
    }
  }

  AddressModel? _prepareAddressModel(LocationController locationController, bool isValid, String numberWithCountryCode) {
    if (_contactPersonNameController.text.isEmpty) {
      showCustomSnackBar('please_provide_contact_person_name'.tr);
    } else if (!isValid) {
      showCustomSnackBar('invalid_phone_number'.tr);
    } else {
      AddressModel addressModel = AddressModel(
        id: widget.address?.id,
        addressType: (locationController.addressTypeIndex == 2 && _levelController.text != 'null')
            ? _levelController.text
            : locationController.addressTypeList[locationController.addressTypeIndex],
        contactPersonName: _contactPersonNameController.text,
        contactPersonNumber: numberWithCountryCode,
        address: _addressController.text,
        latitude: locationController.position.latitude.toString(),
        longitude: locationController.position.longitude.toString(),
        zoneId: locationController.zoneID,
        road: _streetNumberController.text.trim(),
        house: _houseController.text.trim(),
        floor: _floorController.text.trim(),
      );

      return addressModel;
    }
    return null;
  }

  void _addAddress(AddressModel addressModel) {
    Get.find<AddressController>().addAddress(addressModel, widget.fromCheckout, widget.zoneId).then((response) {
      if (response.isSuccess) {
        Get.back(result: addressModel);
        //Get.offAllNamed(RouteHelper.getAddressRoute());
        showCustomSnackBar('new_address_added_successfully'.tr, isError: false);
      } else {
        showCustomSnackBar(response.message);
      }
    });
  }

  void _updateAddress(AddressModel addressModel) {
    Get.find<AddressController>().updateAddress(addressModel, widget.address!.id).then((response) {
      if (response.isSuccess) {
        Get.back();
        showCustomSnackBar(response.message, isError: false);
      } else {
        showCustomSnackBar(response.message);
      }
    });
  }
}
