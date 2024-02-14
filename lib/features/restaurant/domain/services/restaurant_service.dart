import 'package:stackfood_multivendor/common/models/product_model.dart';
import 'package:stackfood_multivendor/common/models/restaurant_model.dart';
import 'package:stackfood_multivendor/features/address/domain/models/address_model.dart';
import 'package:stackfood_multivendor/features/category/domain/models/category_model.dart';
import 'package:stackfood_multivendor/features/location/domain/models/zone_response_model.dart';
import 'package:stackfood_multivendor/features/restaurant/domain/models/recommended_product_model.dart';
import 'package:stackfood_multivendor/features/restaurant/domain/repositories/restaurant_repository_interface.dart';
import 'package:stackfood_multivendor/features/restaurant/domain/services/restaurant_service_interface.dart';
import 'package:stackfood_multivendor/helper/address_helper.dart';
import 'package:stackfood_multivendor/helper/date_converter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RestaurantService implements RestaurantServiceInterface {
  final RestaurantRepositoryInterface restaurantRepositoryInterface;
  RestaurantService({required this.restaurantRepositoryInterface});

  @override
  double getRestaurantDistanceFromUser(LatLng restaurantLatLng){
    double distance = 0;
    distance = Geolocator.distanceBetween(
        restaurantLatLng.latitude, restaurantLatLng.longitude,
        double.parse(AddressHelper.getAddressFromSharedPref()!.latitude!), double.parse(AddressHelper.getAddressFromSharedPref()!.longitude!)
    ) / 1000;

    return distance;
  }

  @override
  String filterRestaurantLinkUrl(String slug, int? restaurantId){
    List<String> routes = Get.currentRoute.split('?');
    String replace = '';
    if(slug.isNotEmpty){
      replace = '${routes[0]}?slug=$slug';
    }else {
      replace = '${routes[0]}?slug=$restaurantId';
    }
    return replace;
  }

  @override
  Future<RestaurantModel?> getRestaurantList(int offset, String filterBy, int topRated, int discount, int veg, int nonVeg, {bool fromMap = false}) async {
    return await restaurantRepositoryInterface.getList(offset: offset, filterBy: filterBy, topRated: topRated, discount: discount, veg: veg, nonVeg: nonVeg, fromMap: fromMap);
  }

  @override
  Future<List<Restaurant>?> getOrderAgainRestaurantList() async {
    return await restaurantRepositoryInterface.getRestaurantList(isOrderAgain: true);
  }

  @override
  Future<List<Restaurant>?> getRecentlyViewedRestaurantList(String type) async {
    return await restaurantRepositoryInterface.getRestaurantList(type: type, isRecentlyViewed: true);
  }

  @override
  Future<List<Restaurant>?> getPopularRestaurantList(String type) async {
    return await restaurantRepositoryInterface.getRestaurantList(type: type, isPopular: true);
  }

  @override
  Future<List<Restaurant>?> getLatestRestaurantList(String type) async {
    return await restaurantRepositoryInterface.getRestaurantList(type: type, isLatest: true);
  }

  @override
  Future<RecommendedProductModel?> getRestaurantRecommendedItemList(int? restaurantId) async {
    return await restaurantRepositoryInterface.getRestaurantRecommendedItemList(restaurantId);
  }

  @override
  Future<Restaurant?> getRestaurantDetails(String restaurantID, String slug, String? languageCode) async {
    return await restaurantRepositoryInterface.get(restaurantID, slug: slug, languageCode: languageCode);
  }

  @override
  Future<List<Product>?> getCartRestaurantSuggestedItemList(int? restaurantID) async {
    return await restaurantRepositoryInterface.getCartRestaurantSuggestedItemList(restaurantID);
  }

  @override
  Future<ProductModel?> getRestaurantProductList(int? restaurantID, int offset, int? categoryID, String type) async {
    return await restaurantRepositoryInterface.getRestaurantProductList(restaurantID, offset, categoryID, type);
  }

  @override
  Future<ProductModel?> getRestaurantSearchProductList(String searchText, String? storeID, int offset, String type) async {
    return await restaurantRepositoryInterface.getRestaurantSearchProductList(searchText, storeID, offset, type);
  }

  @override
  int setTopRated(int rated) {
    int topRated = 0;
    if(rated == 0) {
      topRated = 1;
    }else {
      topRated = 0;
    }
    return topRated;
  }

  @override
  int setDiscounted(int discounted) {
    int haveDiscount = 0;
    if(discounted == 0) {
      haveDiscount = 1;
    }else {
      haveDiscount = 0;
    }
    return haveDiscount;
  }

  @override
  int setVeg(int isVeg) {
    int veg = 0;
    if(isVeg == 0) {
      veg = 1;
    }else {
      veg = 0;
    }
    return veg;
  }

  @override
  int setNonVeg(int isNonVeg) {
    int nonVeg = 0;
    if (isNonVeg == 0) {
      nonVeg = 1;
    } else {
      nonVeg = 0;
    }
    return nonVeg;
  }

  @override
  List<CategoryModel>? setCategories(List<CategoryModel> categoryList, Restaurant restaurant) {
    List<CategoryModel>? preparedCategoryList = [];
    preparedCategoryList.add(CategoryModel(id: 0, name: 'all'.tr));
    for (var category in categoryList) {
      if(restaurant.categoryIds!.contains(category.id)) {
        preparedCategoryList.add(category);
      }
    }
    return preparedCategoryList;
  }

  @override
  AddressModel prepareAddressModel(Position storePosition, ZoneResponseModel responseModel, String addressFromGeocode) {
    return AddressModel(
      latitude: storePosition.latitude.toString(), longitude: storePosition.longitude.toString(), addressType: 'others',
      zoneId: responseModel.isSuccess ? responseModel.zoneIds[0] : 0, zoneIds: responseModel.zoneIds,
      address: addressFromGeocode, zoneData: responseModel.zoneData,
    );
  }

  @override
  bool isRestaurantClosed(DateTime dateTime, bool active, List<Schedules>? schedules) {
    if(!active) {
      return true;
    }
    DateTime date = dateTime;
    int weekday = date.weekday;
    if(weekday == 7) {
      weekday = 0;
    }
    for(int index=0; index<schedules!.length; index++) {
      if(weekday == schedules[index].day) {
        return false;
      }
    }
    return true;
  }

  @override
  bool isRestaurantOpenNow(bool active, List<Schedules>? schedules) {
    if(isRestaurantClosed(DateTime.now(), active, schedules)) {
      return false;
    }
    int weekday = DateTime.now().weekday;
    if(weekday == 7) {
      weekday = 0;
    }
    for(int index=0; index<schedules!.length; index++) {
      if(weekday == schedules[index].day
          && DateConverter.isAvailable(schedules[index].openingTime, schedules[index].closingTime)) {
        return true;
      }
    }
    return false;
  }

}