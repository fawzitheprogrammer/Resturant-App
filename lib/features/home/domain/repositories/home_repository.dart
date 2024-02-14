import 'package:stackfood_multivendor/api/api_client.dart';
import 'package:stackfood_multivendor/features/home/domain/models/banner_model.dart';
import 'package:stackfood_multivendor/features/home/domain/repositories/home_repository_interface.dart';
import 'package:stackfood_multivendor/util/app_constants.dart';
import 'package:get/get_connect.dart';

class HomeRepository implements HomeRepositoryInterface {
  final ApiClient apiClient;
  HomeRepository({required this.apiClient});

  @override
  Future add(value) {
    // TODO: implement add
    throw UnimplementedError();
  }

  @override
  Future delete(int? id) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future get(String? id) {
    // TODO: implement get
    throw UnimplementedError();
  }

  @override
  Future<BannerModel?> getList({int? offset}) async {
    return await _getBannerList();
  }

  Future<BannerModel?> _getBannerList() async {
    BannerModel? bannerModel;
    Response response = await apiClient.getData(AppConstants.bannerUri);
    if(response.statusCode == 200) {
      bannerModel = BannerModel.fromJson(response.body);
    }
    return bannerModel;
  }

  @override
  Future update(Map<String, dynamic> body, int? id) {
    // TODO: implement update
    throw UnimplementedError();
  }

  
}