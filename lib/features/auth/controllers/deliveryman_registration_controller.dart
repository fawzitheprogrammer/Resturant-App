import 'package:stackfood_multivendor/features/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor/api/api_client.dart';
import 'package:stackfood_multivendor/features/splash/domain/models/config_model.dart';
import 'package:stackfood_multivendor/features/auth/domain/models/zone_model.dart';
import 'package:stackfood_multivendor/features/location/controllers/location_controller.dart';
import 'package:stackfood_multivendor/features/location/domain/models/zone_response_model.dart';
import 'package:stackfood_multivendor/features/auth/domain/models/vehicle_model.dart';
import 'package:stackfood_multivendor/features/auth/domain/services/deliveryman_registration_service_interface.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';

class DeliverymanRegistrationController extends GetxController implements GetxService {
  final DeliverymanRegistrationServiceInterface deliverymanRegistrationServiceInterface;

  DeliverymanRegistrationController({required this.deliverymanRegistrationServiceInterface});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _showPassView = false;
  bool get showPassView => _showPassView;

  XFile? _pickedImage;
  XFile? get pickedImage => _pickedImage;

  List<XFile> _pickedIdentities = [];
  List<XFile> get pickedIdentities => _pickedIdentities;

  double _dmStatus = 0.4;
  double get dmStatus => _dmStatus;

  bool _lengthCheck = false;
  bool get lengthCheck => _lengthCheck;

  bool _numberCheck = false;
  bool get numberCheck => _numberCheck;

  bool _uppercaseCheck = false;
  bool get uppercaseCheck => _uppercaseCheck;

  bool _lowercaseCheck = false;
  bool get lowercaseCheck => _lowercaseCheck;

  bool _spatialCheck = false;
  bool get spatialCheck => _spatialCheck;

  final List<String> _identityTypeList = ['select_identity_type', 'passport', 'driving_license', 'nid'];
  List<String> get identityTypeList => _identityTypeList;

  int _identityTypeIndex = 0;
  int get identityTypeIndex => _identityTypeIndex;

  int _dmTypeIndex = 0;
  int get dmTypeIndex => _dmTypeIndex;

  int? _vehicleIndex = 0;
  int? get vehicleIndex => _vehicleIndex;

  List<VehicleModel>? _vehicles;
  List<VehicleModel>? get vehicles => _vehicles;

  List<int?>? _vehicleIds;
  List<int?>? get vehicleIds => _vehicleIds;

  int? _selectedZoneIndex = 0;
  int? get selectedZoneIndex => _selectedZoneIndex;

  final List<String?> _dmTypeList = ['select_dm_type', 'freelancer', 'salary_based'];
  List<String?> get dmTypeList => _dmTypeList;

  List<int>? _zoneIds;
  List<int>? get zoneIds => _zoneIds;

  List<ZoneModel>? _zoneList;
  List<ZoneModel>? get zoneList => _zoneList;

  List<DataModel>? _dataList;
  List<DataModel>? get dataList => _dataList;

  List<dynamic>? _additionalList;
  List<dynamic>? get additionalList => _additionalList;

  LatLng? _restaurantLocation;
  LatLng? get restaurantLocation => _restaurantLocation;

  String? _restaurantAddress;
  String? get restaurantAddress => _restaurantAddress;

  void showHidePassView({bool isUpdate = true}){
    _showPassView = ! _showPassView;
    if(isUpdate) {
      update();
    }
  }

  void pickDmImage(bool isImage, bool isRemove) async {
    if(isRemove) {
      _pickedImage = null;
      _pickedIdentities = [];
    }else {
      if (isImage) {
        _pickedImage = await deliverymanRegistrationServiceInterface.picImageFromGallery();
      } else {
        XFile? xFile = await deliverymanRegistrationServiceInterface.picImageFromGallery();
        if(xFile != null) {
          _pickedIdentities.add(xFile);
        }
      }
      update();
    }
  }

  void dmStatusChange(double value, {bool isUpdate = true}){
    _dmStatus = value;
    if(isUpdate) {
      update();
    }
  }

  void validPassCheck(String pass, {bool isUpdate = true}) {
    _lengthCheck = false;
    _numberCheck = false;
    _uppercaseCheck = false;
    _lowercaseCheck = false;
    _spatialCheck = false;

    if(pass.length > 7){
      _lengthCheck = true;
    }
    if(pass.contains(RegExp(r'[a-z]'))){
      _lowercaseCheck = true;
    }
    if(pass.contains(RegExp(r'[A-Z]'))){
      _uppercaseCheck = true;
    }
    if(pass.contains(RegExp(r'[ .!@#$&*~^%]'))){
      _spatialCheck = true;
    }
    if(pass.contains(RegExp(r'[\d+]'))){
      _numberCheck = true;
    }
    if(isUpdate) {
      update();
    }
  }

  void setIdentityTypeIndex(String? identityType, bool notify) {
    _identityTypeIndex = deliverymanRegistrationServiceInterface.setIdentityTypeIndex(_identityTypeList, identityType);
    if(notify) {
      update();
    }
  }

  void initIdentityTypeIndex() {
    _identityTypeIndex = 0;
  }

  void setDMTypeIndex(int dmType, bool notify) {
    _dmTypeIndex = dmType;
    if(notify) {
      update();
    }
  }

  void setVehicleIndex(int? index, bool notify) {
    _vehicleIndex = index;
    if(notify) {
      update();
    }
  }

  Future<void> getVehicleList() async {
    _vehicles = await deliverymanRegistrationServiceInterface.getVehicleList();
    _vehicleIds = deliverymanRegistrationServiceInterface.setVehicleIdList(_vehicles);
    update();
  }

  Future<List<ZoneModel>?> getZoneList({bool forDeliveryRegistration = true}) async {
    _selectedZoneIndex = 0;
    _restaurantLocation = null;
    _zoneIds = null;
    _zoneList = await deliverymanRegistrationServiceInterface.getZoneList();
    if (_zoneList != null && forDeliveryRegistration) {
      setLocation(LatLng(
        double.parse(Get.find<SplashController>().configModel!.defaultLocation!.lat ?? '0'),
        double.parse(Get.find<SplashController>().configModel!.defaultLocation!.lng ?? '0'),
      ));
    }
    update();
    return _zoneList;
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

  void setDeliverymanAdditionalJoinUsPageData({bool isUpdate = true}){
    _dataList = [];
    _additionalList = [];
    if(Get.find<SplashController>().configModel!.deliverymanAdditionalJoinUsPageData != null) {
      for (var data in Get.find<SplashController>().configModel!.deliverymanAdditionalJoinUsPageData!.data!) {
        int index = Get.find<SplashController>().configModel!.deliverymanAdditionalJoinUsPageData!.data!.indexOf(data);
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

  void removeAdditionalFile(int index, int subIndex) {
    _additionalList![index].removeAt(subIndex);
    update();
  }

  void removeDmImage(){
    _pickedImage = null;
    update();
  }

  void setZoneIndex(int? index) {
    _selectedZoneIndex = index;
    update();
  }

  void removeIdentityImage(int index) {
    _pickedIdentities.removeAt(index);
    update();
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
    FilePickerResult? result = await deliverymanRegistrationServiceInterface.picFile(mediaData);
    if(result != null) {
      _additionalList![index].add(result);
    }
    update();
  }

  void resetDeliveryRegistration(){
    _identityTypeIndex = 0;
    _dmTypeIndex = 0;
    _selectedZoneIndex = 0;
    _pickedImage = null;
    _pickedIdentities = [];
    update();
  }

  Future<void> registerDeliveryMan(Map<String, String> data, List<FilePickerResult> additionalDocuments, List<String> inputTypeList) async {
    _isLoading = true;
    update();
    List<MultipartBody> multiParts = deliverymanRegistrationServiceInterface.prepareIdentityImage(_pickedImage, _pickedIdentities);
    List<MultipartDocument> multiPartsDocuments = deliverymanRegistrationServiceInterface.prepareMultipartDocuments(inputTypeList, additionalDocuments);
    await deliverymanRegistrationServiceInterface.registerDeliveryMan(data, multiParts, multiPartsDocuments);
    _isLoading = false;
    update();
  }

}