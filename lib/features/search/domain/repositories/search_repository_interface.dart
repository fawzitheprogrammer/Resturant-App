import 'package:stackfood_multivendor/common/models/product_model.dart';
import 'package:stackfood_multivendor/interface/repository_interface.dart';
import 'package:get/get_connect/http/src/response/response.dart';

abstract class SearchRepositoryInterface extends RepositoryInterface {
  Future<List<Product>?> getSuggestedFoods();
  Future<Response> getSearchData(String query, bool isRestaurant);
  Future<bool> saveSearchHistory(List<String> searchHistories);
  List<String> getSearchHistory();
  Future<bool> clearSearchHistory();
}