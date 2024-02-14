import 'package:stackfood_multivendor/api/api_client.dart';
import 'package:stackfood_multivendor/features/splash/domain/models/config_model.dart';
import 'package:stackfood_multivendor/features/auth/domain/models/vehicle_model.dart';
import 'package:stackfood_multivendor/features/auth/domain/models/zone_model.dart';
import 'package:stackfood_multivendor/features/auth/domain/reposotories/deliveryman_registration_repo_interface.dart';
import 'package:stackfood_multivendor/features/auth/domain/services/deliveryman_registration_service_interface.dart';
import 'package:stackfood_multivendor/helper/route_helper.dart';
import 'package:stackfood_multivendor/common/widgets/custom_snackbar_widget.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class DeliverymanRegistrationService implements DeliverymanRegistrationServiceInterface{
  final DeliverymanRegistrationRepoInterface deliverymanRegistrationRepoInterface;
  DeliverymanRegistrationService({required this.deliverymanRegistrationRepoInterface});

  @override
  Future<List<ZoneModel>?> getZoneList() async{
    return await deliverymanRegistrationRepoInterface.getList();
  }

  @override
  Future<XFile?> picImageFromGallery() async {
    XFile? pickLogo;
    pickLogo = await ImagePicker().pickImage(source: ImageSource.gallery);
    if(pickLogo != null) {
      pickLogo.length().then((value) {
        if(value > 2000000) {
          showCustomSnackBar('please_upload_lower_size_file'.tr);
        }else {
          return pickLogo;
        }
      });
    }
    return pickLogo;

  }

  @override
  Future<List<VehicleModel>?> getVehicleList() async {
    return await deliverymanRegistrationRepoInterface.getVehicleList();
  }

  @override
  List<int?>? setVehicleIdList(List<VehicleModel>? vehicles) {
    List<int?>? vehicleIds;
    if(vehicles != null) {
      vehicleIds = [];
      for (var vehicle in vehicles) {
        vehicleIds.add(vehicle.id);
      }
    }
    return vehicleIds;
  }

  @override
  int setIdentityTypeIndex(List<String> identityTypeList, String? identityType) {
    int index = 0;
    for(int i=0; i<identityTypeList.length; i++) {
      if(identityTypeList[i] == identityType) {
        index = i;
        break;
      }
    }
    return index;
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
        showCustomSnackBar('please_upload_lower_size_file'.tr);
        result = null;
      } else {
        return result;
      }
    }
    return result;
  }

  @override
  List<MultipartBody> prepareIdentityImage(XFile? pickedImage, List<XFile> pickedIdentities) {
    List<MultipartBody> multiParts = [];
    multiParts.add(MultipartBody('image', pickedImage));
    for(XFile file in pickedIdentities) {
      multiParts.add(MultipartBody('identity_image[]', file));
    }
    return multiParts;
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
  Future<void> registerDeliveryMan(Map<String, String> data, List<MultipartBody> multiParts, List<MultipartDocument> additionalDocument) async {
    Response response = await deliverymanRegistrationRepoInterface.registerDeliveryMan(data, multiParts, additionalDocument);
    if (response.statusCode == 200) {
      Get.offAllNamed(RouteHelper.getInitialRoute());
      showCustomSnackBar('delivery_man_registration_successful'.tr, isError: false);
    }
  }

}