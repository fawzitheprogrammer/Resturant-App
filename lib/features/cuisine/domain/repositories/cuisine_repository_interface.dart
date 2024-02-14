import 'package:stackfood_multivendor/features/cuisine/domain/models/cuisine_restaurants_model.dart';
import 'package:stackfood_multivendor/interface/repository_interface.dart';

abstract class CuisineRepositoryInterface extends RepositoryInterface{
  Future<CuisineRestaurantModel?> getRestaurantList(int offset, int cuisineId);
}