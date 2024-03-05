import 'package:swift_tech_resto/common/models/product_model.dart';
import 'package:swift_tech_resto/common/models/restaurant_model.dart';
import 'package:swift_tech_resto/features/restaurant/domain/models/recommended_product_model.dart';
import 'package:swift_tech_resto/interface/repository_interface.dart';

abstract class RestaurantRepositoryInterface extends RepositoryInterface {
  @override
  Future<Restaurant?> get(String? id, {String slug = '', String? languageCode});
  @override
  Future<RestaurantModel?> getList(
      {int? offset,
      String? filterBy,
      int? topRated,
      int? discount,
      int? veg,
      int? nonVeg,
      bool fromMap = false});
  Future<List<Restaurant>?> getRestaurantList(
      {String? type,
      bool isRecentlyViewed = false,
      bool isOrderAgain = false,
      bool isPopular = false,
      bool isLatest = false});
  Future<RecommendedProductModel?> getRestaurantRecommendedItemList(
      int? restaurantId);
  Future<List<Product>?> getCartRestaurantSuggestedItemList(int? restaurantID);
  Future<ProductModel?> getRestaurantProductList(
      int? restaurantID, int offset, int? categoryID, String type);
  Future<ProductModel?> getRestaurantSearchProductList(
      String searchText, String? storeID, int offset, String type);
}
