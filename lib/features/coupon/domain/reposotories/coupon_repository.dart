import 'package:stackfood_multivendor/api/api_client.dart';
import 'package:stackfood_multivendor/features/coupon/domain/models/coupon_model.dart';
import 'package:stackfood_multivendor/features/coupon/domain/reposotories/coupon_repository_interface.dart';
import 'package:stackfood_multivendor/util/app_constants.dart';
import 'package:get/get_connect/connect.dart';

class CouponRepository implements CouponRepositoryInterface {
  final ApiClient apiClient;
  CouponRepository({required this.apiClient});

  @override
  Future<List<CouponModel>?> getList({int? offset, int? customerId, int? restaurantId, bool fromRestaurant = false}) async {
    if(fromRestaurant) {
      return _getRestaurantCouponList(restaurantId!);
    } else {
      return _getCouponList(customerId, restaurantId);
    }
  }

  @override
  Future<Response> applyCoupon(String couponCode, int? restaurantID) async {
    return await apiClient.getData('${AppConstants.couponApplyUri}$couponCode&restaurant_id=$restaurantID', handleError: true);
  }

  Future<List<CouponModel>?> _getCouponList(int? customerId, int? restaurantId) async {
    List<CouponModel>? couponList;
    Response response = await apiClient.getData('${AppConstants.couponUri}?${restaurantId != null ? 'restaurant_id' : 'customer_id'}=${restaurantId ?? customerId}');
    if(response.statusCode == 200) {
      couponList = [];
      response.body.forEach((category) {
        couponList!.add(CouponModel.fromJson(category));
      });
    }
    return couponList;
  }

  Future<List<CouponModel>?> _getRestaurantCouponList(int restaurantId) async {
    List<CouponModel>? couponList;
    Response response =  await apiClient.getData('${AppConstants.restaurantWiseCouponUri}?restaurant_id=$restaurantId');
    if(response.statusCode == 200) {
      couponList = [];
      response.body.forEach((category) {
        couponList!.add(CouponModel.fromJson(category));
      });
    }
    return couponList;
  }

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
  Future update(Map<String, dynamic> body, int? id) {
    throw UnimplementedError();
  }

}