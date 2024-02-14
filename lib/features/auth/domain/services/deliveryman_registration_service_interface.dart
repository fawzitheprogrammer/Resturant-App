
import 'package:stackfood_multivendor/api/api_client.dart';
import 'package:stackfood_multivendor/features/splash/domain/models/config_model.dart';
import 'package:stackfood_multivendor/features/auth/domain/models/vehicle_model.dart';
import 'package:stackfood_multivendor/features/auth/domain/models/zone_model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';

abstract class DeliverymanRegistrationServiceInterface{

  Future<List<ZoneModel>?> getZoneList();
  Future<XFile?> picImageFromGallery();
  Future<List<VehicleModel>?> getVehicleList();
  List<int?>? setVehicleIdList(List<VehicleModel>? vehicles);
  int setIdentityTypeIndex(List<String> identityTypeList, String? identityType);
  Future<FilePickerResult?> picFile(MediaData mediaData);
  List<MultipartBody> prepareIdentityImage(XFile? pickedImage, List<XFile> pickedIdentities);
  List<MultipartDocument> prepareMultipartDocuments(List<String> inputTypeList, List<FilePickerResult> additionalDocuments);
  Future<void> registerDeliveryMan(Map<String, String> data, List<MultipartBody> multiParts, List<MultipartDocument> additionalDocument);
}