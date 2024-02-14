import 'package:stackfood_multivendor/features/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor/api/api_client.dart';
import 'package:stackfood_multivendor/features/splash/domain/models/config_model.dart';
import 'package:stackfood_multivendor/features/auth/domain/models/zone_model.dart';
import 'package:stackfood_multivendor/features/location/controllers/location_controller.dart';
import 'package:stackfood_multivendor/features/location/domain/models/zone_response_model.dart';
import 'package:stackfood_multivendor/features/auth/controllers/deliveryman_registration_controller.dart';
import 'package:stackfood_multivendor/features/auth/domain/services/restaurant_registration_service_interface.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';

class RestaurantRegistrationController extends GetxController implements GetxService {
  final RestaurantRegistrationServiceInterface restaurantRegistrationServiceInterface;

  RestaurantRegistrationController({required this.restaurantRegistrationServiceInterface});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<DataModel>? _dataList;
  List<DataModel>? get dataList => _dataList;

  List<dynamic>? _additionalList;
  List<dynamic>? get additionalList => _additionalList;

  double _storeStatus = 0.4;
  double get storeStatus => _storeStatus;

  LatLng? _restaurantLocation;
  LatLng? get restaurantLocation => _restaurantLocation;

  String? _restaurantAddress;
  String? get restaurantAddress => _restaurantAddress;

  List<ZoneModel>? _zoneList;
  List<ZoneModel>? get zoneList => _zoneList;

  String _storeMinTime = '--';
  String get storeMinTime => _storeMinTime;

  String _storeMaxTime = '--';
  String get storeMaxTime => _storeMaxTime;

  String _storeTimeUnit = 'minute';
  String get storeTimeUnit => _storeTimeUnit;

  // bool _showPassView = false;
  // bool get showPassView => _showPassView;

  XFile? _pickedLogo;
  XFile? get pickedLogo => _pickedLogo;

  XFile? _pickedCover;
  XFile? get pickedCover => _pickedCover;

  int? _selectedZoneIndex = 0;
  int? get selectedZoneIndex => _selectedZoneIndex;

  List<int>? _zoneIds;
  List<int>? get zoneIds => _zoneIds;


  void setRestaurantAdditionalJoinUsPageData({bool isUpdate = true}){
    _dataList = [];
    _additionalList = [];
    if(Get.find<SplashController>().configModel!.restaurantAdditionalJoinUsPageData != null) {
      for (var data in Get.find<SplashController>().configModel!.restaurantAdditionalJoinUsPageData!.data!) {
        int index = Get.find<SplashController>().configModel!.restaurantAdditionalJoinUsPageData!.data!.indexOf(data);
        _dataList!.add(data);
        if(data.fieldType == 'text' || data.fieldType == 'number' || data.fieldType == 'email' || data.fieldType == 'phone'){
          _additionalList!.add(TextEditingController());
        } else if(data.fieldType == 'date') {
          _additionalList!.add(null);
        } else if(data.fieldType == 'check_box') {
          _additionalList!.add([]);
          if(data.checkData != null) {
            for (var element in data.checkData!) {
              debugPrint(element);
              _additionalList![index].add(0);
            }
          }
        } else if(data.fieldType == 'file') {
          _additionalList!.add([]);
        }

      }
    }

    if(isUpdate) {
      update();
    }
  }

  void setAdditionalDate(int index, String date) {
    _additionalList![index] = date;
    update();
  }

  void setAdditionalCheckData(int index, int i, String date) {
    if(_additionalList![index][i] == date){
      _additionalList![index][i] = 0;
    } else {
      _additionalList![index][i] = date;
    }
    update();
  }

  Future<void> pickFile(int index, MediaData mediaData) async {
    FilePickerResult? result = await restaurantRegistrationServiceInterface.picFile(mediaData);
    if(result != null) {
      _additionalList![index].add(result);
    }
    update();
  }

  void removeAdditionalFile(int index, int subIndex) {
    _additionalList![index].removeAt(subIndex);
    update();
  }

  void storeStatusChange(double value, {bool isUpdate = true}){
    _storeStatus = value;
    if(isUpdate) {
      update();
    }
  }

  Future<void> getZoneList() async {
    _pickedLogo = null;
    _pickedCover = null;
    _selectedZoneIndex = 0;
    _restaurantLocation = null;
    _zoneIds = null;
    _zoneList = await Get.find<DeliverymanRegistrationController>().getZoneList();
    if (_zoneList != null) {
      setLocation(LatLng(
        double.parse(Get.find<SplashController>().configModel!.defaultLocation!.lat ?? '0'),
        double.parse(Get.find<SplashController>().configModel!.defaultLocation!.lng ?? '0'),
      ));
    }
    update();
  }

  void setLocation(LatLng location) async {
    ZoneResponseModel response = await Get.find<LocationController>().getZone(
      location.latitude.toString(), location.longitude.toString(), false,
    );
    _restaurantAddress = await Get.find<LocationController>().getAddressFromGeocode(LatLng(location.latitude, location.longitude));
    if(response.isSuccess && response.zoneIds.isNotEmpty) {
      _restaurantLocation = location;
      _zoneIds = response.zoneIds;
      for(int index=0; index<_zoneList!.length; index++) {
        if(_zoneIds!.contains(_zoneList![index].id)) {
          _selectedZoneIndex = 0;
          break;
        }
      }
    }else {
      _restaurantLocation = null;
      _zoneIds = null;
    }
    update();
  }


  void minTimeChange(String time){
    _storeMinTime = time;
    update();
  }

  void maxTimeChange(String time){
    _storeMaxTime = time;
    update();
  }

  void timeUnitChange(String unit){
    _storeTimeUnit = unit;
    update();
  }

  void pickImage(bool isLogo, bool isRemove) async {
    if(isRemove) {
      _pickedLogo = null;
      _pickedCover = null;
    }else {
      if (isLogo) {
        _pickedLogo = await restaurantRegistrationServiceInterface.picLogoFromGallery();
      } else {
        _pickedCover = await restaurantRegistrationServiceInterface.picLogoFromGallery();
      }
      update();
    }
  }

  void resetRestaurantRegistration() {
    _pickedLogo = null;
    _pickedCover = null;
    _storeMinTime = '--';
    _storeMaxTime = '--';
    _storeTimeUnit = 'minute';
    update();
  }

  Future<void> registerRestaurant(Map<String, String> data, List<FilePickerResult> additionalDocuments, List<String> inputTypeList) async {
    _isLoading = true;
    update();
    List<MultipartDocument> multiPartsDocuments = restaurantRegistrationServiceInterface.prepareMultipartDocuments(inputTypeList, additionalDocuments);
    await restaurantRegistrationServiceInterface.registerRestaurant(data, _pickedLogo, _pickedCover, multiPartsDocuments);
    _isLoading = false;
    update();

  }

  void setZoneIndex(int? index) {
    _selectedZoneIndex = index;
    update();
  }

}