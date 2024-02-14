import 'package:stackfood_multivendor/common/models/product_model.dart';
import 'package:stackfood_multivendor/api/api_client.dart';
import 'package:stackfood_multivendor/features/search/domain/repositories/search_repository_interface.dart';
import 'package:stackfood_multivendor/util/app_constants.dart';
import 'package:get/get_connect.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchRepository implements SearchRepositoryInterface {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;
  SearchRepository({required this.apiClient, required this.sharedPreferences});

  @override
  Future<List<Product>?> getSuggestedFoods() async {
    List<Product>? suggestedFoodList = [];
    Response response = await apiClient.getData(AppConstants.suggestedFoodUri);
    if(response.statusCode == 200) {
      suggestedFoodList = [];
      response.body.forEach((suggestedFood) => suggestedFoodList!.add(Product.fromJson(suggestedFood)));
    }
    return suggestedFoodList;
  }

  @override
  Future<Response> getSearchData(String query, bool isRestaurant) async {
    return await apiClient.getData('${AppConstants.searchUri}${isRestaurant ? 'restaurants' : 'products'}/search?name=$query&offset=1&limit=50');
  }

  @override
  Future<bool> saveSearchHistory(List<String> searchHistories) async {
    return await sharedPreferences.setStringList(AppConstants.searchHistory, searchHistories);
  }

  @override
  List<String> getSearchHistory() {
    return sharedPreferences.getStringList(AppConstants.searchHistory) ?? [];
  }

  @override
  Future<bool> clearSearchHistory() async {
    return sharedPreferences.setStringList(AppConstants.searchHistory, []);
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
  Future get(String? id) {
    throw UnimplementedError();
  }

  @override
  Future getList({int? offset}) {
    throw UnimplementedError();
  }

  @override
  Future update(Map<String, dynamic> body, int? id) {
    throw UnimplementedError();
  }

  
}