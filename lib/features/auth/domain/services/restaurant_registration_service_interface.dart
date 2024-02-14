import 'package:stackfood_multivendor/api/api_client.dart';
import 'package:stackfood_multivendor/features/splash/domain/models/config_model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:image_picker/image_picker.dart';

abstract class RestaurantRegistrationServiceInterface{
  Future<XFile?> picLogoFromGallery();
  Future<FilePickerResult?> picFile(MediaData mediaData);
  List<MultipartDocument> prepareMultipartDocuments(List<String> inputTypeList, List<FilePickerResult> additionalDocuments);
  Future<Response> registerRestaurant(Map<String, String> data, XFile? logo, XFile? cover, List<MultipartDocument> additionalDocument);
}