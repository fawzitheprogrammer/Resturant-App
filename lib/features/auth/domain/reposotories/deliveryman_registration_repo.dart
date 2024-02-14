import 'package:stackfood_multivendor/api/api_client.dart';
import 'package:stackfood_multivendor/features/auth/domain/models/vehicle_model.dart';
import 'package:stackfood_multivendor/features/auth/domain/models/zone_model.dart';
import 'package:stackfood_multivendor/features/auth/domain/reposotories/deliveryman_registration_repo_interface.dart';
import 'package:stackfood_multivendor/util/app_constants.dart';
import 'package:get/get_connect/http/src/response/response.dart';

class DeliverymanRegistrationRepo implements DeliverymanRegistrationRepoInterface{
  final ApiClient apiClient;
  DeliverymanRegistrationRepo({required this.apiClient});

  @override
  Future add(value) {
    throw UnimplementedError();
  }

  @override
  Future delete(int? id) {
    throw UnimplementedError();
  }

  @override
  Future get(String? id) {
    throw UnimplementedError();
  }

  ///Get all the zone in list
  @override
  Future<List<ZoneModel>?> getList({int? offset}) async{
    List<ZoneModel>? zoneList ;
    Response response = await apiClient.getData(AppConstants.zoneListUri);
    if(response.statusCode == 200) {
      zoneList = [];
      zoneList.add(ZoneModel(id: 0, name: 'select_zone'));
      response.body.forEach((zone) => zoneList!.add(ZoneModel.fromJson(zone)));
    }
    return zoneList;
  }

  @override
  Future<List<VehicleModel>?> getVehicleList() async {
    List<VehicleModel>? vehicles;
    Response response = await apiClient.getData(AppConstants.vehiclesUri);
    if (response.statusCode == 200) {
      vehicles = [];
      vehicles.add(VehicleModel(id: 0, type: 'select_vehicle_type'));
      response.body.forEach((vehicle) => vehicles!.add(VehicleModel.fromJson(vehicle)));
    }
    return vehicles;
  }

  @override
  Future<Response> registerDeliveryMan(Map<String, String> data, List<MultipartBody> multiParts, List<MultipartDocument> additionalDocument) async {
    return await apiClient.postMultipartData(AppConstants.dmRegisterUri, data, multiParts, additionalDocument);
  }

  @override
  Future update(Map<String, dynamic> body, int? id) {
    throw UnimplementedError();
  }

}