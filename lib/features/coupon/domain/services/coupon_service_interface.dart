import 'package:stackfood_multivendor/features/coupon/domain/models/coupon_model.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';

abstract class CouponServiceInterface{
  Future<List<CouponModel>?> getList({int? customerId, int? restaurantId});
  List<JustTheController>? generateToolTipControllerList(List<CouponModel>? couponList);
  Future<List<CouponModel>?> getRestaurantCouponList({required int restaurantId});
  Future<Response> applyCoupon(String couponCode, int? restaurantID);
}