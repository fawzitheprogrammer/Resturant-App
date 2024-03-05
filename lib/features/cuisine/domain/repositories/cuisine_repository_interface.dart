import 'package:swift_tech_resto/features/cuisine/domain/models/cuisine_restaurants_model.dart';
import 'package:swift_tech_resto/interface/repository_interface.dart';

abstract class CuisineRepositoryInterface extends RepositoryInterface {
  Future<CuisineRestaurantModel?> getRestaurantList(int offset, int cuisineId);
}
