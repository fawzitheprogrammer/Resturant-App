import 'package:stackfood_multivendor/common/models/product_model.dart';
import 'package:stackfood_multivendor/common/widgets/custom_snackbar_widget.dart';
import 'package:stackfood_multivendor/features/address/domain/models/address_model.dart';
import 'package:stackfood_multivendor/features/category/controllers/category_controller.dart';
import 'package:stackfood_multivendor/features/checkout/controllers/checkout_controller.dart';
import 'package:stackfood_multivendor/features/language/controllers/localization_controller.dart';
import 'package:stackfood_multivendor/features/location/controllers/location_controller.dart';
import 'package:stackfood_multivendor/features/location/domain/models/zone_response_model.dart';
import 'package:stackfood_multivendor/features/restaurant/domain/models/cart_suggested_item_model.dart';
import 'package:stackfood_multivendor/features/restaurant/domain/models/recommended_product_model.dart';
import 'package:stackfood_multivendor/common/models/restaurant_model.dart';
import 'package:stackfood_multivendor/features/category/domain/models/category_model.dart';
import 'package:stackfood_multivendor/features/restaurant/domain/services/restaurant_service_interface.dart';
import 'package:stackfood_multivendor/helper/address_helper.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RestaurantController extends GetxController implements GetxService {
  final RestaurantServiceInterface restaurantServiceInterface;

  RestaurantController({required this.restaurantServiceInterface});

  RestaurantModel? _restaurantModel;
  RestaurantModel? get restaurantModel => _restaurantModel;

  List<Restaurant>? _restaurantList;
  List<Restaurant>? get restaurantList => _restaurantList;

  List<Restaurant>? _popularRestaurantList;
  List<Restaurant>? get popularRestaurantList => _popularRestaurantList;

  List<Restaurant>? _latestRestaurantList;
  List<Restaurant>? get latestRestaurantList => _latestRestaurantList;

  List<Restaurant>? _recentlyViewedRestaurantList;
  List<Restaurant>? get recentlyViewedRestaurantList => _recentlyViewedRestaurantList;

  Restaurant? _restaurant;
  Restaurant? get restaurant => _restaurant;

  List<Product>? _restaurantProducts;
  List<Product>? get restaurantProducts => _restaurantProducts;

  ProductModel? _restaurantProductModel;
  ProductModel? get restaurantProductModel => _restaurantProductModel;

  ProductModel? _restaurantSearchProductModel;
  ProductModel? get restaurantSearchProductModel => _restaurantSearchProductModel;

  int _categoryIndex = 0;
  int get categoryIndex => _categoryIndex;

  List<CategoryModel>? _categoryList;
  List<CategoryModel>? get categoryList => _categoryList;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _restaurantType = 'all';
  String get restaurantType => _restaurantType;

  bool _foodPaginate = false;
  bool get foodPaginate => _foodPaginate;

  int? _foodPageSize;
  int? get foodPageSize => _foodPageSize;

  List<int> _foodOffsetList = [];

  int _foodOffset = 1;
  int get foodOffset => _foodOffset;

  String _type = 'all';
  String get type => _type;

  String _searchType = 'all';
  String get searchType => _searchType;

  String _searchText = '';
  String get searchText => _searchText;

  RecommendedProductModel? _recommendedProductModel;
  RecommendedProductModel? get recommendedProductModel => _recommendedProductModel;

  CartSuggestItemModel? _cartSuggestItemModel;
  CartSuggestItemModel? get cartSuggestItemModel => _cartSuggestItemModel;

  List<Product>? _suggestedItems;
  List<Product>? get suggestedItems => _suggestedItems;

  int? _foodPageOffset;
  int? get foodPageOffset => _foodPageOffset;

  bool _isSearching = false;
  bool get isSearching => _isSearching;

  List<Restaurant>? _orderAgainRestaurantList;
  List<Restaurant>? get orderAgainRestaurantList => _orderAgainRestaurantList;

  int _topRated = 0;
  int get topRated => _topRated;

  int _discount = 0;
  int get discount => _discount;

  int _veg = 0;
  int get veg => _veg;

  int _nonVeg = 0;
  int get nonVeg => _nonVeg;

  double getRestaurantDistance(LatLng restaurantLatLng){
    return restaurantServiceInterface.getRestaurantDistanceFromUser(restaurantLatLng);
  }

  String filteringUrl(String slug){
    return restaurantServiceInterface.filterRestaurantLinkUrl(slug, _restaurant?.id);
  }

  Future<void> getOrderAgainRestaurantList(bool reload) async {
    if(reload) {
      _orderAgainRestaurantList = null;
      update();
    }
    _orderAgainRestaurantList = await restaurantServiceInterface.getOrderAgainRestaurantList();
    update();
  }


  Future<void> getRecentlyViewedRestaurantList(bool reload, String type, bool notify) async {
    _type = type;
    if(reload){
      _recentlyViewedRestaurantList = null;
    }
    if(notify) {
      update();
    }
    if(_recentlyViewedRestaurantList == null || reload) {
      _recentlyViewedRestaurantList = await restaurantServiceInterface.getRecentlyViewedRestaurantList(type);
      update();
    }
  }

  Future<void> getRestaurantRecommendedItemList(int? restaurantId, bool reload) async {
    _recommendedProductModel = null;
    if(reload) {
      _restaurantModel = null;
      update();
    }
    _recommendedProductModel = await restaurantServiceInterface.getRestaurantRecommendedItemList(restaurantId);
    update();
  }

  Future<void> getRestaurantList(int offset, bool reload, {bool fromMap = false}) async {
    if(reload) {
      _restaurantModel = null;
      update();
    }
    RestaurantModel? restaurantModel = await restaurantServiceInterface.getRestaurantList(offset, _restaurantType, _topRated, _discount, _veg, _nonVeg, fromMap: fromMap);
    if (restaurantModel != null) {
      if (offset == 1) {
        _restaurantModel = restaurantModel;
      }else {
        _restaurantModel!.totalSize = restaurantModel.totalSize;
        _restaurantModel!.offset = restaurantModel.offset;
        _restaurantModel!.restaurants!.addAll(restaurantModel.restaurants!);
      }
      update();
    }
  }

  void setRestaurantType(String type) {
    _restaurantType = type;
    getRestaurantList(1, true);
  }

  void setTopRated() {
    _topRated = restaurantServiceInterface.setTopRated(_topRated);
    getRestaurantList(1, true);
  }

  void setDiscount() {
    _discount = restaurantServiceInterface.setDiscounted(_discount);
    getRestaurantList(1, true);
  }

  void setVeg() {
    _veg = restaurantServiceInterface.setVeg(_veg);
    getRestaurantList(1, true);
  }

  void setNonVeg() {
    _nonVeg = restaurantServiceInterface.setNonVeg(_nonVeg);
    getRestaurantList(1, true);
  }

  Future<void> getPopularRestaurantList(bool reload, String type, bool notify) async {
    _type = type;
    if(reload){
      _popularRestaurantList = null;
    }
    if(notify) {
      update();
    }
    if(_popularRestaurantList == null || reload) {
      _popularRestaurantList = await restaurantServiceInterface.getPopularRestaurantList(type);
      update();
    }
  }

  Future<void> getLatestRestaurantList(bool reload, String type, bool notify) async {
    _type = type;
    if(reload){
      _latestRestaurantList = null;
    }
    if(notify) {
      update();
    }
    if(_latestRestaurantList == null || reload) {
      _latestRestaurantList = await restaurantServiceInterface.getLatestRestaurantList(type);
      update();
    }
  }

  void setCategoryList() {
    if(Get.find<CategoryController>().categoryList != null && _restaurant != null) {
      _categoryList = restaurantServiceInterface.setCategories(Get.find<CategoryController>().categoryList!, _restaurant!);
    }
  }


  Future<Restaurant?> getRestaurantDetails(Restaurant restaurant, {bool fromCart = false, String slug = ''}) async {
    _categoryIndex = 0;
    if(restaurant.name != null) {
      _restaurant = restaurant;
    }else {
      _isLoading = true;
      _restaurant = null;
      _restaurant = await restaurantServiceInterface.getRestaurantDetails(restaurant.id.toString(), slug, Get.find<LocalizationController>().locale.languageCode);
      if(_restaurant != null && _restaurant!.latitude != null){
        await _setRequiredDataAfterRestaurantGet(slug, fromCart);
      }
      Get.find<CheckoutController>().setOrderType(
        (_restaurant != null && _restaurant!.delivery != null) ? _restaurant!.delivery! ? 'delivery' : 'take_away' : 'delivery', notify: false,
      );

      _isLoading = false;
      update();
    }
    return _restaurant;
  }

  Future<void> _setRequiredDataAfterRestaurantGet(String slug, bool fromCart) async {
    Get.find<CheckoutController>().initializeTimeSlot(_restaurant!);
    if(!fromCart && slug.isEmpty){
      Get.find<CheckoutController>().getDistanceInKM(
        LatLng(
          double.parse(AddressHelper.getAddressFromSharedPref()!.latitude!),
          double.parse(AddressHelper.getAddressFromSharedPref()!.longitude!),
        ),
        LatLng(double.parse(_restaurant!.latitude!), double.parse(_restaurant!.longitude!)),
      );
    }
    if(slug.isNotEmpty){
      await _setStoreAddressToUserAddress(LatLng(double.parse(_restaurant!.latitude!), double.parse(_restaurant!.longitude!)));
    }
  }

  Future<void> _setStoreAddressToUserAddress(LatLng restaurantAddress) async {
    Position storePosition = Position(
      latitude: restaurantAddress.latitude, longitude: restaurantAddress.longitude,
      timestamp: DateTime.now(), accuracy: 1, altitude: 1, heading: 1, speed: 1, speedAccuracy: 1, altitudeAccuracy: 1, headingAccuracy: 1,
    );
    String addressFromGeocode = await Get.find<LocationController>().getAddressFromGeocode(LatLng(restaurantAddress.latitude, restaurantAddress.longitude));
    ZoneResponseModel responseModel = await Get.find<LocationController>().getZone(storePosition.latitude.toString(), storePosition.longitude.toString(), true);
    AddressModel addressModel = restaurantServiceInterface.prepareAddressModel(storePosition, responseModel, addressFromGeocode);
    await AddressHelper.saveAddressInSharedPref(addressModel);
  }

  void makeEmptyRestaurant() {
    _restaurant = null;
    update();
  }

  Future<void> getCartRestaurantSuggestedItemList(int? restaurantID) async {
    _suggestedItems = await restaurantServiceInterface.getCartRestaurantSuggestedItemList(restaurantID);
    update();
  }

  Future<void> getRestaurantProductList(int? restaurantID, int offset, String type, bool notify) async {
    _foodOffset = offset;
    if(offset == 1 || _restaurantProducts == null) {
      _type = type;
      _foodOffsetList = [];
      _restaurantProducts = null;
      _foodOffset = 1;
      if(notify) {
        update();
      }
    }
    if (!_foodOffsetList.contains(offset)) {
      _foodOffsetList.add(offset);
      ProductModel? productModel = await restaurantServiceInterface.getRestaurantProductList(restaurantID, offset,
          (_restaurant != null && _restaurant!.categoryIds!.isNotEmpty && _categoryIndex != 0)
          ? _categoryList![_categoryIndex].id : 0, type);

      if (productModel != null) {
        if (offset == 1) {
          _restaurantProducts = [];
        }
        _restaurantProducts!.addAll(productModel.products!);
        _foodPageSize = productModel.totalSize;
        _foodPageOffset = productModel.offset;
        _foodPaginate = false;
        update();
      }
    } else {
      if(_foodPaginate) {
        _foodPaginate = false;
        update();
      }
    }
  }

  void showFoodBottomLoader() {
    _foodPaginate = true;
    update();
  }

  void setFoodOffset(int offset) {
    _foodOffset = offset;
  }

  void showBottomLoader() {
    _isLoading = true;
    update();
  }

  Future<void> getRestaurantSearchProductList(String searchText, String? storeID, int offset, String type) async {
    if(searchText.isEmpty) {
      showCustomSnackBar('write_item_name'.tr);
    }else {
      _isSearching = true;
      _searchText = searchText;
      if(offset == 1 || _restaurantSearchProductModel == null) {
        _searchType = type;
        _restaurantSearchProductModel = null;
        update();
      }
      ProductModel? productModel = await restaurantServiceInterface.getRestaurantSearchProductList(searchText, storeID, offset, type);
      if (productModel != null) {
        if (offset == 1) {
          _restaurantSearchProductModel = productModel;
        }else {
          _restaurantSearchProductModel!.products!.addAll(productModel.products!);
          _restaurantSearchProductModel!.totalSize = productModel.totalSize;
          _restaurantSearchProductModel!.offset = productModel.offset;
        }
      }
      update();
    }
  }

  void changeSearchStatus({bool isUpdate = true}) {
    _isSearching = !_isSearching;
    if(isUpdate) {
      update();
    }
  }

  void initSearchData() {
    _restaurantSearchProductModel = ProductModel(products: []);
    _searchText = '';
  }

  void setCategoryIndex(int index) {
    _categoryIndex = index;
    _restaurantProducts = null;
    getRestaurantProductList(_restaurant!.id, 1, Get.find<RestaurantController>().type, false);
    update();
  }

  bool isRestaurantClosed(DateTime dateTime, bool active, List<Schedules>? schedules, {int? customDateDuration}) {
    return restaurantServiceInterface.isRestaurantClosed(dateTime, active, schedules);
  }

  bool isRestaurantOpenNow(bool active, List<Schedules>? schedules) {
    return restaurantServiceInterface.isRestaurantOpenNow(active, schedules);
  }

  bool isOpenNow(Restaurant restaurant) => restaurant.open == 1 && restaurant.active!;

  double? getDiscount(Restaurant restaurant) => restaurant.discount != null ? restaurant.discount!.discount : 0;

  String? getDiscountType(Restaurant restaurant) => restaurant.discount != null ? restaurant.discount!.discountType : 'percent';


}