
import 'package:get/get_connect/http/src/response/response.dart';

abstract class FavouriteServiceInterface {
  Future<Response> addFavouriteList(int? id, bool isRestaurant);
  Future<Response> removeFavouriteList(int? id, bool isRestaurant);
  Future<Response> getFavouriteList();
}