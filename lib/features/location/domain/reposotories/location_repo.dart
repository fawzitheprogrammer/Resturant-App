import 'package:stackfood_multivendor/api/api_client.dart';
import 'package:stackfood_multivendor/features/location/domain/models/zone_response_model.dart';
import 'package:stackfood_multivendor/features/address/domain/models/zone_model.dart';
import 'package:stackfood_multivendor/features/location/domain/reposotories/location_repo_interface.dart';
import 'package:stackfood_multivendor/util/app_constants.dart';
import 'package:stackfood_multivendor/common/widgets/custom_snackbar_widget.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationRepo implements LocationRepoInterface {
  final ApiClient apiClient;
  LocationRepo({required this.apiClient});

  @override
  Future<ZoneResponseModel> getZone(String? lat, String? lng) async {
    Response response = await apiClient.getData('${AppConstants.zoneUri}?lat=$lat&lng=$lng', handleError: false);
    if(response.statusCode == 200) {
      ZoneResponseModel responseModel;
      List<int>? zoneIds = ZoneModel.fromJson(response.body).zoneIds;
      List<ZoneData>? zoneData = ZoneModel.fromJson(response.body).zoneData;
      responseModel = ZoneResponseModel(true, '' , zoneIds ?? [], zoneData??[]);
      return responseModel;
    } else {
      return ZoneResponseModel(false, response.statusText, [], []);
    }
  }

  @override
  Future<String> getAddressFromGeocode(LatLng latLng) async {
    Response response = await apiClient.getData('${AppConstants.geocodeUri}?lat=${latLng.latitude}&lng=${latLng.longitude}');
    String address = 'Unknown Location Found';
    if(response.statusCode == 200 && response.body['status'] == 'OK') {
      address = response.body['results'][0]['formatted_address'].toString();
    }else {
      showCustomSnackBar(response.body['error_message'] ?? response.bodyString);
    }
    return address;
  }

  // @override
  // Future<dynamic> get({LatLng? latLng, bool isZone = false}) {
  //   if(isZone) {
  //     _getZone(latLng!.latitude.toString(), latLng.longitude.toString());
  //   } else {
  //     _getAddressFromGeocode(latLng!);
  //   }
  // }


  @override
  Future<Response> searchLocation(String text) async {
    return await apiClient.getData('${AppConstants.searchLocationUri}?search_text=$text');
  }

  Future<Response> getById(int id) async {
    Response response = await apiClient.getData('${AppConstants.placeDetailsUri}?placeid=$id');
    return response;
  }

  @override
  Future<Response> updateZone() async {
    return await apiClient.getData(AppConstants.updateZoneUri);
  }

  @override
  Future getList({int? offset}) {
    throw UnimplementedError();
  }

  @override
  Future add(value) {
    throw UnimplementedError();
  }

  @override
  Future delete(int? id) {
    throw UnimplementedError();
  }

  @override
  Future<Response> get(String? id) async {
    Response response = await apiClient.getData('${AppConstants.placeDetailsUri}?placeid=$id');
    return response;
  }

  @override
  Future update(Map<String, dynamic> body, int? id) {
    throw UnimplementedError();
  }

}
