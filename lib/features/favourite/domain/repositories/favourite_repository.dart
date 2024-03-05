import 'package:swift_tech_resto/api/api_client.dart';
import 'package:swift_tech_resto/features/favourite/domain/repositories/favourite_repository_interface.dart';
import 'package:swift_tech_resto/util/app_constants.dart';
import 'package:get/get_connect/connect.dart';

class FavouriteRepository implements FavouriteRepositoryInterface<Response> {
  final ApiClient apiClient;
  FavouriteRepository({required this.apiClient});

  @override
  Future<Response> add(dynamic a, {bool isRestaurant = false, int? id}) async {
    return await apiClient.postData(
        '${AppConstants.addWishListUri}${isRestaurant ? 'restaurant_id=' : 'food_id='}$id',
        null);
  }

  @override
  Future<Response> delete(int? id, {bool isRestaurant = false}) async {
    return await apiClient.postData(
        '${AppConstants.removeWishListUri}${isRestaurant ? 'restaurant_id=' : 'food_id='}$id',
        {"_method": "delete"});
  }

  @override
  Future<Response> getList({int? offset}) async {
    return await apiClient.getData(AppConstants.wishListGetUri);
  }

  @override
  Future get(String? id) {
    throw UnimplementedError();
  }

  @override
  Future update(Map<String, dynamic> body, int? id) {
    throw UnimplementedError();
  }
}
