import 'package:stackfood_multivendor/common/models/product_model.dart';
import 'package:stackfood_multivendor/common/models/restaurant_model.dart';
import 'package:stackfood_multivendor/api/api_client.dart';
import 'package:stackfood_multivendor/features/category/domain/models/category_model.dart';
import 'package:stackfood_multivendor/features/category/domain/reposotories/category_repository_interface.dart';
import 'package:stackfood_multivendor/util/app_constants.dart';
import 'package:get/get.dart';

class CategoryRepository implements CategoryRepositoryInterface {
  final ApiClient apiClient;

  CategoryRepository({required this.apiClient});

  @override
  Future add(value) {
    throw UnimplementedError();
  }

  @override
  Future delete(int? id) {
    throw UnimplementedError();
  }

  @override
  Future get(String? id) {
    throw UnimplementedError();
  }

  @override
  Future<List<CategoryModel>?> getList({int? offset}) async {
    List<CategoryModel>? categoryList;
    Response response = await apiClient.getData(AppConstants.categoryUri);
    if (response.statusCode == 200) {
      categoryList = [];
      response.body.forEach((category) {
        categoryList!.add(CategoryModel.fromJson(category));
      });
    }
    return categoryList;
  }

  @override
  Future<List<CategoryModel>?> getSubCategoryList(String? parentID) async {
    List<CategoryModel>? subCategoryList;
    Response response = await apiClient.getData('${AppConstants.subCategoryUri}$parentID');
    if (response.statusCode == 200) {
      subCategoryList= [];
      subCategoryList.add(CategoryModel(id: int.parse(parentID!), name: 'all'.tr));
      response.body.forEach((category) => subCategoryList!.add(CategoryModel.fromJson(category)));
    }
    return subCategoryList;
  }

  @override
  Future<ProductModel?> getCategoryProductList(String? categoryID, int offset, String type) async {
    ProductModel? productModel;
    Response response = await apiClient.getData('${AppConstants.categoryProductUri}$categoryID?limit=10&offset=$offset&type=$type');
    if (response.statusCode == 200) {
      productModel = ProductModel.fromJson(response.body);
    }
    return productModel;
  }

  @override
  Future<RestaurantModel?> getCategoryRestaurantList(String? categoryID, int offset, String type) async {
    RestaurantModel? restaurantModel;
    Response response = await apiClient.getData('${AppConstants.categoryRestaurantUri}$categoryID?limit=10&offset=$offset&type=$type');
    if (response.statusCode == 200) {
      restaurantModel = RestaurantModel.fromJson(response.body);
    }
    return restaurantModel;
  }

  // @override
  // Future<dynamic> getSearchData(String? query, String? categoryID, bool isRestaurant, String type) async {
  //   RestaurantModel? searchRestaurantModel;
  //   ProductModel? searchProductModel;
  //   Response response = await apiClient.getData(
  //     '${AppConstants.searchUri}${isRestaurant ? 'restaurants' : 'products'}/search?name=$query&category_id=$categoryID&type=$type&offset=1&limit=50',
  //   );
  //   if (response.statusCode == 200) {
  //       if (isRestaurant) {
  //         searchRestaurantModel = RestaurantModel.fromJson(response.body);
  //       } else {
  //         searchProductModel = ProductModel.fromJson(response.body);
  //       }
  //   }
  //   return isRestaurant ? searchRestaurantModel : searchProductModel;
  // }

  @override
  Future<Response> getSearchData(String? query, String? categoryID, bool isRestaurant, String type) async {
    return await apiClient.getData(
      '${AppConstants.searchUri}${isRestaurant ? 'restaurants' : 'products'}/search?name=$query&category_id=$categoryID&type=$type&offset=1&limit=50',
    );
  }

  @override
  Future update(Map<String, dynamic> body, int? id) {
    throw UnimplementedError();
  }
}