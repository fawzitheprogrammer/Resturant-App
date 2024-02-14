import 'package:stackfood_multivendor/api/api_client.dart';
import 'package:stackfood_multivendor/interface/repository_interface.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:image_picker/image_picker.dart';

abstract class RestaurantRegistrationRepoInterface extends RepositoryInterface{

  Future<Response> registerRestaurant(Map<String, String> data, XFile? logo, XFile? cover, List<MultipartDocument> additionalDocument);
}