
import 'package:stackfood_multivendor/common/models/product_model.dart';
import 'package:stackfood_multivendor/common/models/restaurant_model.dart';
import 'package:get/get_connect/http/src/response/response.dart';

abstract class SearchServiceInterface {
  Future<List<Product>?> getSuggestedFoods();
  Future<Response> getSearchData(String query, bool isRestaurant);
  Future<bool> saveSearchHistory(List<String> searchHistories);
  List<String> getSearchHistory();
  Future<bool> clearSearchHistory();
  List<Restaurant>? sortRestaurantSearchList(List<Restaurant>? searchRestList, int rating, bool veg, bool nonVeg, bool isAvailableFoods, bool isDiscountedFoods, int sortIndex);
  List<Product>? sortFoodSearchList( List<Product>? allProductList, double upperValue, double lowerValue, int rating, bool veg, bool nonVeg, bool isAvailableFoods, bool isDiscountedFoods, int sortIndex);
}