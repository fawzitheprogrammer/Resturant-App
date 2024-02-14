import 'package:stackfood_multivendor/features/favourite/domain/repositories/favourite_repository_interface.dart';
import 'package:stackfood_multivendor/features/favourite/domain/services/favourite_service_interface.dart';
import 'package:get/get_connect/http/src/response/response.dart';

class FavouriteService implements FavouriteServiceInterface {
  final FavouriteRepositoryInterface favouriteRepositoryInterface;
  FavouriteService({required this.favouriteRepositoryInterface});

  @override
  Future<Response> addFavouriteList(int? id, bool isRestaurant) async {
    return await favouriteRepositoryInterface.add(null, isRestaurant: isRestaurant, id: id);
  }

  @override
  Future<Response> removeFavouriteList(int? id, bool isRestaurant) async {
    return await favouriteRepositoryInterface.delete(id, isRestaurant: isRestaurant);
  }

  @override
  Future<Response> getFavouriteList() async {
    return await favouriteRepositoryInterface.getList();
  }

  // @override
  // List<Product?>? prepareFoods(Response response) {
  //   List<Product?>? wishProductList = [];
  //   response.body['food'].forEach((food) async {
  //     Product product = Product.fromJson(food);
  //     wishProductList.add(product);
  //   });
  //   return wishProductList;
  // }
  //
  // @override
  // List<int?> prepareFoodIds(List<Product?>? productList) {
  //   List<int?> productIdList = [];
  //   for (var product in productList!) {
  //     productIdList.add(product!.id);
  //   }
  //   return productIdList;
  // }
  //
  // @override
  // List<Restaurant?>? prepareRestaurants(Response response) {
  //   List<Restaurant?>? wishRestaurantList = [];
  //   response.body['restaurant'].forEach((res) async {
  //     Restaurant? restaurant = Restaurant.fromJson(res);
  //     // try{
  //     //   restaurant = Restaurant.fromJson(res);
  //     // }catch(e){
  //     //   debugPrint('exception create in restaurant list create : $e');
  //     // }
  //     wishRestaurantList.add(restaurant);
  //   });
  //   return wishRestaurantList;
  // }
  //
  // @override
  // List<int?> prepareRestaurantsIds(List<Restaurant?>? restaurantList) {
  //   List<int?> restaurantIdList = [];
  //   for (var restaurant in restaurantList!) {
  //     restaurantIdList.add(restaurant!.id);
  //   }
  //   return restaurantIdList;
  // }
}