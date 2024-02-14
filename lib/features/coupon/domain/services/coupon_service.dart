import 'package:stackfood_multivendor/features/coupon/domain/models/coupon_model.dart';
import 'package:stackfood_multivendor/features/coupon/domain/reposotories/coupon_repository_interface.dart';
import 'package:stackfood_multivendor/features/coupon/domain/services/coupon_service_interface.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';

class CouponService implements CouponServiceInterface{
  final CouponRepositoryInterface couponRepositoryInterface;
  CouponService({required this.couponRepositoryInterface});

  @override
  Future<List<CouponModel>?> getList({int? customerId, int? restaurantId}) async {
    return await couponRepositoryInterface.getList(customerId: customerId, restaurantId: restaurantId);
  }

  @override
  Future<List<CouponModel>?> getRestaurantCouponList({required int restaurantId}) async {
    return await couponRepositoryInterface.getList(restaurantId: restaurantId, fromRestaurant: true);
  }

  @override
  List<JustTheController>? generateToolTipControllerList(List<CouponModel>? couponList) {
    List<JustTheController>? toolTipController;
    if(couponList != null) {
      toolTipController = [];
      for(int i=0; i< couponList.length; i++) {
        toolTipController.add(JustTheController());
      }
    }
    return toolTipController;
  }

  @override
  Future<Response> applyCoupon(String couponCode, int? restaurantID) async {
    return await couponRepositoryInterface.applyCoupon(couponCode, restaurantID);
  }

}