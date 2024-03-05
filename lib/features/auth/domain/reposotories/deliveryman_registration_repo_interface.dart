import 'package:swift_tech_resto/api/api_client.dart';
import 'package:swift_tech_resto/features/auth/domain/models/vehicle_model.dart';
import 'package:swift_tech_resto/interface/repository_interface.dart';
import 'package:get/get_connect/http/src/response/response.dart';

abstract class DeliverymanRegistrationRepoInterface
    extends RepositoryInterface {
  Future<List<VehicleModel>?> getVehicleList();
  Future<Response> registerDeliveryMan(
      Map<String, String> data,
      List<MultipartBody> multiParts,
      List<MultipartDocument> additionalDocument);
}
