import 'package:stackfood_multivendor/features/location/domain/models/zone_response_model.dart';
import 'package:stackfood_multivendor/interface/repository_interface.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class LocationRepoInterface extends RepositoryInterface {
  Future<ZoneResponseModel> getZone(String? lat, String? lng);
  Future<String> getAddressFromGeocode(LatLng latLng);
  Future<Response> searchLocation(String text);
  Future<Response> updateZone();
}