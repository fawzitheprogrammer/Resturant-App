import 'package:stackfood_multivendor/common/models/product_model.dart';
import 'package:stackfood_multivendor/common/models/restaurant_model.dart';
import 'package:stackfood_multivendor/features/search/domain/repositories/search_repository_interface.dart';
import 'package:stackfood_multivendor/features/search/domain/services/search_service_interface.dart';
import 'package:stackfood_multivendor/helper/date_converter.dart';
import 'package:get/get_connect/http/src/response/response.dart';

class SearchService implements SearchServiceInterface {
  final SearchRepositoryInterface searchRepositoryInterface;
  SearchService({required this.searchRepositoryInterface});

  @override
  Future<List<Product>?> getSuggestedFoods() async {
    return await searchRepositoryInterface.getSuggestedFoods();
  }

  @override
  Future<Response> getSearchData(String query, bool isRestaurant) async {
    return await searchRepositoryInterface.getSearchData(query, isRestaurant);
  }

  @override
  Future<bool> saveSearchHistory(List<String> searchHistories) async {
    return await searchRepositoryInterface.saveSearchHistory(searchHistories);
  }

  @override
  List<String> getSearchHistory() {
    return searchRepositoryInterface.getSearchHistory();
  }

  @override
  Future<bool> clearSearchHistory() async {
    return searchRepositoryInterface.clearSearchHistory();
  }

  @override
  List<Product>? sortFoodSearchList( List<Product>? allProductList, double upperValue, double lowerValue, int rating, bool veg, bool nonVeg, bool isAvailableFoods, bool isDiscountedFoods, int sortIndex) {
    List<Product>? searchProductList = [];
    searchProductList.addAll(allProductList!);
    if(upperValue > 0) {
      searchProductList.removeWhere((product) => product.price! <= lowerValue || product.price! > upperValue);
    }
    if(rating != -1) {
      searchProductList.removeWhere((product) => product.avgRating! < rating);
    }
    if(!veg && nonVeg) {
      searchProductList.removeWhere((product) => product.veg == 1);
    }
    if(!nonVeg && veg) {
      searchProductList.removeWhere((product) => product.veg == 0);
    }
    if(isAvailableFoods || isDiscountedFoods) {
      if(isAvailableFoods) {
        searchProductList.removeWhere((product) => !DateConverter.isAvailable(product.availableTimeStarts, product.availableTimeEnds));
      }
      if(isDiscountedFoods) {
        searchProductList.removeWhere((product) => product.discount == 0);
      }
    }
    if(sortIndex != -1) {
      if(sortIndex == 0) {
        searchProductList.sort((a, b) => a.name!.toLowerCase().compareTo(b.name!.toLowerCase()));
      }else {
        searchProductList.sort((a, b) => a.name!.toLowerCase().compareTo(b.name!.toLowerCase()));
        Iterable iterable = searchProductList.reversed;
        searchProductList = iterable.toList() as List<Product>?;
      }
    }
    return searchProductList;
  }

    @override
  List<Restaurant>? sortRestaurantSearchList(List<Restaurant>? allRestaurantList, int rating, bool veg, bool nonVeg, bool isAvailableRestaurants, bool isDiscountedRestaurants, int sortIndex) {
    List<Restaurant>? searchRestaurantList = [];
    searchRestaurantList.addAll(allRestaurantList!);
    if(rating != -1) {
      searchRestaurantList.removeWhere((restaurant) => restaurant.avgRating! < rating);
    }
    if(!veg && nonVeg) {
      searchRestaurantList.removeWhere((product) => product.nonVeg == 0);
    }
    if(!nonVeg && veg) {
      searchRestaurantList.removeWhere((product) => product.veg == 0);
    }
    if(isAvailableRestaurants || isDiscountedRestaurants) {
      if(isAvailableRestaurants) {
        searchRestaurantList.removeWhere((restaurant) => (restaurant.open == 0 || !restaurant.active!));
      }
      if(isDiscountedRestaurants) {
        searchRestaurantList.removeWhere((restaurant) => restaurant.discount == null);
      }
    }
    if(sortIndex != -1) {
      if(sortIndex == 0) {
        searchRestaurantList.sort((a, b) => a.name!.toLowerCase().compareTo(b.name!.toLowerCase()));
      }else {
        searchRestaurantList.sort((a, b) => a.name!.toLowerCase().compareTo(b.name!.toLowerCase()));
        Iterable iterable = searchRestaurantList.reversed;
        searchRestaurantList = iterable.toList() as List<Restaurant>?;
      }
    }
    return searchRestaurantList;
  }


}