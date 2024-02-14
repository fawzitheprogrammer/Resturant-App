import 'package:stackfood_multivendor/common/models/product_model.dart';
import 'package:stackfood_multivendor/common/models/restaurant_model.dart';
import 'package:stackfood_multivendor/features/favourite/domain/services/favourite_service_interface.dart';
import 'package:stackfood_multivendor/common/widgets/custom_snackbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FavouriteController extends GetxController implements GetxService {
  final FavouriteServiceInterface favouriteServiceInterface;
  FavouriteController({required this.favouriteServiceInterface});

  List<Product?>? _wishProductList;
  List<Product?>? get wishProductList => _wishProductList;

  List<Restaurant?>? _wishRestList;
  List<Restaurant?>? get wishRestList => _wishRestList;

  List<int?> _wishProductIdList = [];
  List<int?> get wishProductIdList => _wishProductIdList;

  List<int?> _wishRestIdList = [];
  List<int?> get wishRestIdList => _wishRestIdList;

  void addToFavouriteList(Product? product, Restaurant? restaurant, bool isRestaurant) async {
    Response response = await favouriteServiceInterface.addFavouriteList(isRestaurant ? restaurant!.id : product!.id, isRestaurant);
    if (response.statusCode == 200) {
      if(isRestaurant) {
        _wishRestIdList.add(restaurant!.id);
        _wishRestList!.add(restaurant);
      }else {
        _wishProductList!.add(product);
        _wishProductIdList.add(product!.id);
      }
      showCustomSnackBar(response.body['message'], isError: false);
    }
    update();
  }

  void removeFromFavouriteList(int? id, bool isRestaurant) async {
    Response response = await favouriteServiceInterface.removeFavouriteList(id, isRestaurant);
    if (response.statusCode == 200) {
      int idIndex = -1;
      if(isRestaurant) {
        idIndex = _wishRestIdList.indexOf(id);
        _wishRestIdList.removeAt(idIndex);
        _wishRestList!.removeAt(idIndex);
      }else {
        idIndex = _wishProductIdList.indexOf(id);
        _wishProductIdList.removeAt(idIndex);
        _wishProductList!.removeAt(idIndex);
      }
      showCustomSnackBar(response.body['message'], isError: false);
    }
    update();
  }

  Future<void> getFavouriteList({bool fromFavScreen = false}) async {
    if(fromFavScreen){
      _wishProductList = null;
      _wishRestList = null;
      _wishRestIdList = [];
    }else {
      _wishProductList = [];
      _wishRestList = [];
      _wishRestIdList = [];
    }
    Response response = await favouriteServiceInterface.getFavouriteList();
    if (response.statusCode == 200) {
      if(fromFavScreen){
        _wishProductList = [];
        _wishRestList = [];
        _wishRestIdList = [];
      }
      update();
      // _wishProductList!.addAll(favouriteServiceInterface.prepareFoods(response) as Iterable<Product?>);
      // _wishProductIdList.addAll(favouriteServiceInterface.prepareFoodIds(_wishProductList));
      response.body['food'].forEach((food) async {
        Product product = Product.fromJson(food);
        _wishProductList!.add(product);
        _wishProductIdList.add(product.id);
      });
      // _wishRestList!.addAll(favouriteServiceInterface.prepareRestaurants(response) as Iterable<Restaurant?>);
      // _wishRestIdList.addAll(favouriteServiceInterface.prepareRestaurantsIds(_wishRestList));
      response.body['restaurant'].forEach((res) async {
        Restaurant? restaurant;
        try{
          restaurant = Restaurant.fromJson(res);
        }catch(e){
          debugPrint('exception create in restaurant list create : $e');
        }
        _wishRestList!.add(restaurant);
        _wishRestIdList.add(restaurant!.id);
      });
    }
    update();
  }

  void removeFavourites() {
    _wishProductIdList = [];
    _wishRestIdList = [];
  }
}
