import 'package:stackfood_multivendor/api/api_client.dart';
import 'package:stackfood_multivendor/features/splash/domain/models/config_model.dart';
import 'package:stackfood_multivendor/features/auth/domain/reposotories/restaurant_registration_repo_interface.dart';
import 'package:stackfood_multivendor/features/auth/domain/services/restaurant_registration_service_interface.dart';
import 'package:stackfood_multivendor/helper/route_helper.dart';
import 'package:stackfood_multivendor/common/widgets/custom_snackbar_widget.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class RestaurantRegistrationService implements RestaurantRegistrationServiceInterface {
  final RestaurantRegistrationRepoInterface restaurantRegistrationRepoInterface;

  RestaurantRegistrationService({required this.restaurantRegistrationRepoInterface});

  @override
  Future<XFile?> picLogoFromGallery() async {
    XFile? pickLogo = await ImagePicker().pickImage(source: ImageSource.gallery);
    if(pickLogo != null) {
      pickLogo.length().then((value) {
        if (value > 2000000) {
          showCustomSnackBar('please_upload_lower_size_file'.tr);
        } else {
          return pickLogo;
        }
      });
    }
    return pickLogo;
  }

  @override
  Future<FilePickerResult?> picFile(MediaData mediaData) async {
    List<String> permission = [];
    if(mediaData.image == 1) {
      permission.add('jpg');
    }
    if(mediaData.pdf == 1) {
      permission.add('pdf');
    }
    if(mediaData.docs == 1) {
      permission.add('doc');
    }

    FilePickerResult? result;

    if(GetPlatform.isWeb){
      result = await FilePicker.platform.pickFiles(
        withReadStream: true,
      );
    }else{
      result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: permission,
        allowMultiple: false,
      );
    }
    if(result != null && result.files.isNotEmpty) {
      if(result.files.single.size > 2000000) {
        result = null;
        showCustomSnackBar('please_upload_lower_size_file'.tr);
      } else {
        return result;
      }
    }
    return result;
  }

  @override
  List<MultipartDocument> prepareMultipartDocuments(List<String> inputTypeList, List<FilePickerResult> additionalDocuments) {
    List<MultipartDocument> multiPartsDocuments = [];
    List<String> dataName = [];
    for(String data in inputTypeList) {
      dataName.add('additional_documents[$data]');
    }
    for(FilePickerResult file in additionalDocuments) {
      int index = additionalDocuments.indexOf(file);
      multiPartsDocuments.add(MultipartDocument('${dataName[index]}[]', file));
    }
    return multiPartsDocuments;
  }

  @override
  Future<Response> registerRestaurant(Map<String, String> data, XFile? logo, XFile? cover, List<MultipartDocument> additionalDocument) async {
    Response response = await restaurantRegistrationRepoInterface.registerRestaurant(data, logo, cover, additionalDocument);
    if(response.statusCode == 200) {
      int? restaurantId = response.body['restaurant_id'];
      Get.offAllNamed(RouteHelper.getBusinessPlanRoute(restaurantId));
    }
    return response;
  }

}