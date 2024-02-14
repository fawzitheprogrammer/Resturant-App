import 'package:stackfood_multivendor/common/models/product_model.dart';
import 'package:stackfood_multivendor/common/models/restaurant_model.dart';
import 'package:stackfood_multivendor/features/cart/controllers/cart_controller.dart';
import 'package:stackfood_multivendor/features/checkout/controllers/checkout_controller.dart';
import 'package:stackfood_multivendor/features/checkout/widgets/bottom_section_widget.dart';
import 'package:stackfood_multivendor/features/checkout/widgets/checkout_screen_shimmer_view.dart';
import 'package:stackfood_multivendor/features/checkout/widgets/order_place_button.dart';
import 'package:stackfood_multivendor/features/checkout/widgets/top_section_widget.dart';
import 'package:stackfood_multivendor/features/coupon/controllers/coupon_controller.dart';
import 'package:stackfood_multivendor/features/location/domain/models/zone_response_model.dart';
import 'package:stackfood_multivendor/features/profile/controllers/profile_controller.dart';
import 'package:stackfood_multivendor/features/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor/features/address/controllers/address_controller.dart';
import 'package:stackfood_multivendor/features/address/domain/models/address_model.dart';
import 'package:stackfood_multivendor/features/cart/domain/models/cart_model.dart';
import 'package:stackfood_multivendor/features/auth/controllers/auth_controller.dart';
import 'package:stackfood_multivendor/features/location/controllers/location_controller.dart';
import 'package:stackfood_multivendor/helper/address_helper.dart';
import 'package:stackfood_multivendor/helper/auth_helper.dart';
import 'package:stackfood_multivendor/helper/date_converter.dart';
import 'package:stackfood_multivendor/helper/price_converter.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/util/app_constants.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:stackfood_multivendor/common/widgets/custom_app_bar_widget.dart';
import 'package:stackfood_multivendor/common/widgets/footer_view_widget.dart';
import 'package:stackfood_multivendor/common/widgets/menu_drawer_widget.dart';
import 'package:stackfood_multivendor/common/widgets/not_logged_in_screen.dart';
import 'package:stackfood_multivendor/common/widgets/web_page_title_widget.dart';
import 'package:get/get.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';
import 'package:flutter/material.dart';

class CheckoutScreen extends StatefulWidget {
  final List<CartModel>? cartList;
  final bool fromCart;
  const CheckoutScreen({super.key, required this.fromCart, required this.cartList});

  @override
  CheckoutScreenState createState() => CheckoutScreenState();
}

class CheckoutScreenState extends State<CheckoutScreen> {
  double? taxPercent = 0;
  bool? _isCashOnDeliveryActive = false;
  bool? _isDigitalPaymentActive = false;
  bool _isOfflinePaymentActive = false;
  bool _isWalletActive = false;
  List<CartModel>? _cartList;

  List<AddressModel> address = [];
  bool firstTime = true;
  final tooltipController1 = JustTheController();
  final tooltipController2 = JustTheController();
  final tooltipController3 = JustTheController();

  final TextEditingController guestContactPersonNameController = TextEditingController();
  final TextEditingController guestContactPersonNumberController = TextEditingController();
  final TextEditingController guestEmailController = TextEditingController();
  final FocusNode guestNumberNode = FocusNode();
  final FocusNode guestEmailNode = FocusNode();

  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    initCall();
  }

  Future<void> initCall() async {
    bool isLoggedIn = AuthHelper.isLoggedIn();

    Get.find<CheckoutController>().streetNumberController.text = AddressHelper.getAddressFromSharedPref()!.road ?? '';
    Get.find<CheckoutController>().houseController.text = AddressHelper.getAddressFromSharedPref()!.house ?? '';
    Get.find<CheckoutController>().floorController.text = AddressHelper.getAddressFromSharedPref()!.floor ?? '';
    Get.find<CheckoutController>().couponController.text = '';

    Get.find<CheckoutController>().getDmTipMostTapped();
    Get.find<CheckoutController>().setPreferenceTimeForView('', false, isUpdate: false);
    Get.find<CheckoutController>().setCustomDate(null, false, canUpdate: false);

    Get.find<CheckoutController>().getOfflineMethodList();

    if(Get.find<CheckoutController>().isPartialPay){
      Get.find<CheckoutController>().changePartialPayment(isUpdate: false);
    }

    Get.find<LocationController>().getZone(
      AddressHelper.getAddressFromSharedPref()!.latitude,
      AddressHelper.getAddressFromSharedPref()!.longitude, false, updateInAddress: true,
    );

    if(isLoggedIn){
      if(Get.find<ProfileController>().userInfoModel == null) {
        Get.find<ProfileController>().getUserInfo();
      }

      Get.find<CouponController>().getCouponList(/*restaurantId: _cartList![0].product!.restaurantId*/);

      if(Get.find<AddressController>().addressList == null) {
        Get.find<AddressController>().getAddressList(canInsertAddress: true);
      }
    }

    _cartList = [];
    widget.fromCart ? _cartList!.addAll(Get.find<CartController>().cartList) : _cartList!.addAll(widget.cartList!);
    Get.find<CheckoutController>().setRestaurantDetails(restaurantId: _cartList![0].product!.restaurantId);

    Get.find<CheckoutController>().initCheckoutData(_cartList![0].product!.restaurantId);


    Get.find<CouponController>().setCoupon('', isUpdate: false);

    Get.find<CheckoutController>().stopLoader(isUpdate: false);
    Get.find<CheckoutController>().updateTimeSlot(0, false, notify: false);

    _isCashOnDeliveryActive = Get.find<SplashController>().configModel!.cashOnDelivery;
    _isDigitalPaymentActive = Get.find<SplashController>().configModel!.digitalPayment;
    _isOfflinePaymentActive = Get.find<SplashController>().configModel!.offlinePaymentStatus!;
    _isWalletActive = Get.find<SplashController>().configModel!.customerWalletStatus == 1;

    Get.find<CheckoutController>().updateTips(
      Get.find<AuthController>().getDmTipIndex().isNotEmpty ? int.parse(Get.find<AuthController>().getDmTipIndex()) : 0, notify: false,
    );
    Get.find<CheckoutController>().tipController.text = Get.find<CheckoutController>().selectedTips != -1 ? AppConstants.tips[Get.find<CheckoutController>().selectedTips] : '';

  }


  @override
  void dispose() {
    super.dispose();
    // _streetNumberController.dispose();
    // _houseController.dispose();
    // _floorController.dispose();
  }

  @override
  Widget build(BuildContext context) {

    bool guestCheckoutPermission = AuthHelper.isGuestLoggedIn() && Get.find<SplashController>().configModel!.guestCheckoutStatus!;

    return Scaffold(
      appBar: CustomAppBarWidget(title: 'checkout'.tr),
      endDrawer: const MenuDrawerWidget(), endDrawerEnableOpenDragGesture: false,
      body: guestCheckoutPermission || AuthHelper.isLoggedIn() ? GetBuilder<LocationController>(builder: (locationController) {
        return GetBuilder<CheckoutController>(
          builder: (checkoutController) {

            bool todayClosed = false;
            bool tomorrowClosed = false;

            if(checkoutController.restaurant != null) {
              todayClosed = checkoutController.isRestaurantClosed(DateTime.now(), checkoutController.restaurant!.active!, checkoutController.restaurant!.schedules);
              tomorrowClosed = checkoutController.isRestaurantClosed(DateTime.now().add(const Duration(days: 1)), checkoutController.restaurant!.active!, checkoutController.restaurant!.schedules);
              taxPercent = checkoutController.restaurant!.tax;
            }
            return GetBuilder<CouponController>(builder: (couponController) {
              bool showTips = checkoutController.orderType != 'take_away' && Get.find<SplashController>().configModel!.dmTipsStatus == 1 && !checkoutController.subscriptionOrder;
              double deliveryCharge = -1;
              double charge = -1;
              double? maxCodOrderAmount;
              if(checkoutController.restaurant != null && checkoutController.distance != null && checkoutController.distance != -1 ) {

                deliveryCharge = _getDeliveryCharge(restaurant: checkoutController.restaurant, checkoutController: checkoutController, returnDeliveryCharge: true)!;
                charge = _getDeliveryCharge(restaurant: checkoutController.restaurant, checkoutController: checkoutController, returnDeliveryCharge: false)!;
                maxCodOrderAmount = _getDeliveryCharge(restaurant: checkoutController.restaurant, checkoutController: checkoutController, returnMaxCodOrderAmount: true);

              }

              double price = _calculatePrice(_cartList);
              double addOnsPrice = _calculateAddonsPrice(_cartList);
              double? discount = _calculateDiscountPrice(_cartList, checkoutController.restaurant, price, addOnsPrice);
              double? couponDiscount = PriceConverter.toFixed(couponController.discount!);
              double subTotal = _calculateSubTotal(price, addOnsPrice);
              double orderAmount = _calculateOrderAmount(price, addOnsPrice, discount, couponDiscount);
              bool taxIncluded = Get.find<SplashController>().configModel!.taxIncluded == 1;
              double tax = _calculateTax(taxIncluded, orderAmount, taxPercent);
              bool restaurantSubscriptionActive = false;
              int subscriptionQty = checkoutController.subscriptionOrder ? 0 : 1;
              double additionalCharge =  Get.find<SplashController>().configModel!.additionalChargeStatus! ? Get.find<SplashController>().configModel!.additionCharge! : 0;

              if(checkoutController.restaurant != null) {

                restaurantSubscriptionActive =  checkoutController.restaurant!.orderSubscriptionActive! && widget.fromCart;

                subscriptionQty = _getSubscriptionQty(checkoutController: checkoutController, restaurantSubscriptionActive: restaurantSubscriptionActive);

                if (checkoutController.orderType == 'take_away' || checkoutController.restaurant!.freeDelivery!
                    || (Get.find<SplashController>().configModel!.freeDeliveryOver != null && orderAmount
                        >= Get.find<SplashController>().configModel!.freeDeliveryOver!) || couponController.freeDelivery) {
                  deliveryCharge = 0;
                }
              }

              deliveryCharge = PriceConverter.toFixed(deliveryCharge);
              double total = _calculateTotal(subTotal, deliveryCharge, discount, couponDiscount, taxIncluded, tax, showTips, checkoutController.tips, additionalCharge);

              checkoutController.setTotalAmount(total - (checkoutController.isPartialPay ? Get.find<ProfileController>().userInfoModel?.walletBalance ?? 0 : 0));

              debugPrint('=====check : ${checkoutController.distance != null} && ${checkoutController.restaurant != null}');
              return (checkoutController.distance != null && checkoutController.restaurant != null) ? Column(
                children: [
                  WebScreenTitleWidget(title: 'checkout'.tr),

                  Expanded(child: SingleChildScrollView(
                    controller: scrollController,
                    physics: const BouncingScrollPhysics(),
                    child: FooterViewWidget(
                      child: Center(
                        child: SizedBox(
                          width: Dimensions.webMaxWidth,
                          child: ResponsiveHelper.isDesktop(context) ? Padding(
                            padding: const EdgeInsets.only(top: Dimensions.paddingSizeLarge),
                            child: Row(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [

                              Expanded(flex: 6, child: TopSectionWidget(
                                charge: charge, deliveryCharge: deliveryCharge,
                                locationController: locationController, tomorrowClosed: tomorrowClosed, todayClosed: todayClosed,
                                price: price, discount: discount, addOns: addOnsPrice, restaurantSubscriptionActive: restaurantSubscriptionActive,
                                showTips: showTips, isCashOnDeliveryActive: _isCashOnDeliveryActive!, isDigitalPaymentActive: _isDigitalPaymentActive!,
                                isWalletActive: _isWalletActive, fromCart: widget.fromCart, total: total, tooltipController3: tooltipController3, tooltipController2: tooltipController2,
                                guestNameTextEditingController: guestContactPersonNameController, guestNumberTextEditingController: guestContactPersonNumberController,
                                guestEmailController: guestEmailController, guestEmailNode: guestEmailNode,
                                guestNumberNode: guestNumberNode, isOfflinePaymentActive: _isOfflinePaymentActive,
                              )),
                              const SizedBox(width: Dimensions.paddingSizeLarge),

                              Expanded(
                                flex: 4,
                                child: BottomSectionWidget(
                                  isCashOnDeliveryActive: _isCashOnDeliveryActive!, isDigitalPaymentActive: _isDigitalPaymentActive!, isWalletActive: _isWalletActive,
                                  total: total, subTotal: subTotal, discount: discount, couponController: couponController,
                                  taxIncluded: taxIncluded, tax: tax, deliveryCharge: deliveryCharge, checkoutController: checkoutController, locationController: locationController,
                                  todayClosed: todayClosed, tomorrowClosed: tomorrowClosed, orderAmount: orderAmount, maxCodOrderAmount: maxCodOrderAmount,
                                  subscriptionQty: subscriptionQty, taxPercent: taxPercent!, fromCart: widget.fromCart, cartList: _cartList!,
                                  price: price, addOns: addOnsPrice, charge: charge,
                                  guestNumberTextEditingController: guestContactPersonNumberController, guestNumberNode: guestNumberNode,
                                  guestEmailController: guestEmailController, guestEmailNode: guestEmailNode,
                                  guestNameTextEditingController: guestContactPersonNameController, isOfflinePaymentActive: _isOfflinePaymentActive,
                                ),
                              )
                            ]),
                          ) : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                            TopSectionWidget(
                              charge: charge, deliveryCharge: deliveryCharge,
                              locationController: locationController, tomorrowClosed: tomorrowClosed, todayClosed: todayClosed,
                              price: price, discount: discount, addOns: addOnsPrice, restaurantSubscriptionActive: restaurantSubscriptionActive,
                              showTips: showTips, isCashOnDeliveryActive: _isCashOnDeliveryActive!, isDigitalPaymentActive: _isDigitalPaymentActive!,
                              isWalletActive: _isWalletActive, fromCart: widget.fromCart, total: total, tooltipController3: tooltipController3, tooltipController2: tooltipController2,
                              guestNameTextEditingController: guestContactPersonNameController, guestNumberTextEditingController: guestContactPersonNumberController,
                              guestEmailController: guestEmailController, guestEmailNode: guestEmailNode,
                              guestNumberNode: guestNumberNode, isOfflinePaymentActive: _isOfflinePaymentActive,
                            ),

                            BottomSectionWidget(
                              isCashOnDeliveryActive: _isCashOnDeliveryActive!, isDigitalPaymentActive: _isDigitalPaymentActive!, isWalletActive: _isWalletActive,
                              total: total, subTotal: subTotal, discount: discount, couponController: couponController,
                              taxIncluded: taxIncluded, tax: tax, deliveryCharge: deliveryCharge, checkoutController: checkoutController, locationController: locationController,
                              todayClosed: todayClosed, tomorrowClosed: tomorrowClosed, orderAmount: orderAmount, maxCodOrderAmount: maxCodOrderAmount,
                              subscriptionQty: subscriptionQty, taxPercent: taxPercent!, fromCart: widget.fromCart, cartList: _cartList!,
                              price: price, addOns: addOnsPrice, charge: charge,
                              guestNumberTextEditingController: guestContactPersonNumberController, guestNumberNode: guestNumberNode,
                              guestEmailController: guestEmailController, guestEmailNode: guestEmailNode,
                              guestNameTextEditingController: guestContactPersonNameController, isOfflinePaymentActive: _isOfflinePaymentActive,
                            ),
                          ]),
                        ),
                      ),
                    ),
                  )),

                  ResponsiveHelper.isDesktop(context) ? const SizedBox() : Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      boxShadow: [BoxShadow(color: Theme.of(context).primaryColor.withOpacity(0.1), blurRadius: 10)],
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical: Dimensions.paddingSizeExtraSmall),
                          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                            Text(
                              'total_amount'.tr,
                              style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).primaryColor),
                            ),
                            PriceConverter.convertAnimationPrice(
                              total * (checkoutController.subscriptionOrder ? (subscriptionQty == 0 ? 1 : subscriptionQty) : 1),
                              textStyle: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).primaryColor),
                            ),
                          ]),
                        ),

                        OrderPlaceButton(
                          checkoutController: checkoutController, locationController: locationController,
                          todayClosed: todayClosed, tomorrowClosed: tomorrowClosed, orderAmount: orderAmount, deliveryCharge: deliveryCharge,
                          tax: tax, discount: discount, total: total, maxCodOrderAmount: maxCodOrderAmount, subscriptionQty: subscriptionQty,
                          cartList: _cartList!, isCashOnDeliveryActive: _isCashOnDeliveryActive!, isDigitalPaymentActive: _isDigitalPaymentActive!,
                          isWalletActive: _isWalletActive, fromCart: widget.fromCart, guestNumberTextEditingController: guestContactPersonNumberController,
                          guestNumberNode: guestNumberNode, guestNameTextEditingController: guestContactPersonNameController,
                          guestEmailController: guestEmailController, guestEmailNode: guestEmailNode,
                          isOfflinePaymentActive: _isOfflinePaymentActive, subTotal: subTotal, couponController: couponController,
                          taxIncluded: taxIncluded, taxPercent: taxPercent!,
                        ),
                      ],
                    ),
                  ),

                ],
              ) : const CheckoutScreenShimmerView();
            });
          }
        );
      }) : NotLoggedInScreen(callBack: (value) {
        initCall();
        setState(() {});
      }),
    );
  }

  double? _getDeliveryCharge({required Restaurant? restaurant, required CheckoutController checkoutController, bool returnDeliveryCharge = true, bool returnMaxCodOrderAmount = false}) {

    ZoneData zoneData = AddressHelper.getAddressFromSharedPref()!.zoneData!.firstWhere((data) => data.id == restaurant!.zoneId);
    double perKmCharge = restaurant!.selfDeliverySystem == 1 ? restaurant.perKmShippingCharge!
        : zoneData.perKmShippingCharge ?? 0;

    double minimumCharge = restaurant.selfDeliverySystem == 1 ? restaurant.minimumShippingCharge!
        :  zoneData.minimumShippingCharge ?? 0;

    double? maximumCharge = restaurant.selfDeliverySystem == 1 ? restaurant.maximumShippingCharge
        : zoneData.maximumShippingCharge;

    double deliveryCharge = checkoutController.distance! * perKmCharge;
    double charge = checkoutController.distance! * perKmCharge;

    if(deliveryCharge < minimumCharge) {
      deliveryCharge = minimumCharge;
      charge = minimumCharge;
    }

    if(restaurant.selfDeliverySystem == 0 && checkoutController.extraCharge != null){
      deliveryCharge = deliveryCharge + checkoutController.extraCharge!;
      charge = charge + checkoutController.extraCharge!;
    }

    if(maximumCharge != null && deliveryCharge > maximumCharge){
      deliveryCharge = maximumCharge;
      charge = maximumCharge;
    }

    if(restaurant.selfDeliverySystem == 0 && zoneData.increasedDeliveryFeeStatus == 1){
      deliveryCharge = deliveryCharge + (deliveryCharge * (zoneData.increasedDeliveryFee!/100));
      charge = charge + charge * (zoneData.increasedDeliveryFee!/100);
    }

    if(restaurant.selfDeliverySystem == 0 && Get.find<SplashController>().configModel!.freeDeliveryDistance != null && Get.find<SplashController>().configModel!.freeDeliveryDistance! >= checkoutController.distance!){
      deliveryCharge = 0;
      charge = 0;
    }

    if(restaurant.selfDeliverySystem == 1 && restaurant.freeDeliveryDistanceStatus! && restaurant.freeDeliveryDistanceValue! >= checkoutController.distance!){
      deliveryCharge = 0;
      charge = 0;
    }

    double? maxCodOrderAmount;
    if(zoneData.maxCodOrderAmount != null) {
      maxCodOrderAmount = zoneData.maxCodOrderAmount;
    }

    if(returnMaxCodOrderAmount) {
      return maxCodOrderAmount;
    } else {
      if(returnDeliveryCharge) {
        return deliveryCharge;
      }else {
        return charge;
      }
    }

  }

  double _calculatePrice(List<CartModel>? cartList) {
    double price = 0;
    double variationPrice = 0;
    for (var cartModel in cartList!) {

      price = price + (cartModel.product!.price! * cartModel.quantity!);

      for(int index = 0; index< cartModel.product!.variations!.length; index++) {
        for(int i=0; i<cartModel.product!.variations![index].variationValues!.length; i++) {
          if(cartModel.variations![index][i]!) {
            variationPrice += (cartModel.product!.variations![index].variationValues![i].optionPrice! * cartModel.quantity!);
          }
        }
      }
    }
    return PriceConverter.toFixed(price + variationPrice);
  }

  double _calculateAddonsPrice(List<CartModel>? cartList) {
    double addonPrice = 0;
    for (var cartModel in cartList!) {
      List<AddOns> addOnList = [];
      for (var addOnId in cartModel.addOnIds!) {
        for (AddOns addOns in cartModel.product!.addOns!) {
          if (addOns.id == addOnId.id) {
            addOnList.add(addOns);
            break;
          }
        }
      }
      for (int index = 0; index < addOnList.length; index++) {
        addonPrice = addonPrice + (addOnList[index].price! * cartModel.addOnIds![index].quantity!);
      }
    }
    return PriceConverter.toFixed(addonPrice);
  }

  double _calculateDiscountPrice(List<CartModel>? cartList, Restaurant? restaurant, double price, double addOns) {
    double? discount = 0;
    if(restaurant != null) {
      for (var cartModel in cartList!) {
        double? dis = (restaurant.discount != null
            && DateConverter.isAvailable(restaurant.discount!.startTime, restaurant.discount!.endTime))
            ? restaurant.discount!.discount : cartModel.product!.discount;
        String? disType = (restaurant.discount != null
            && DateConverter.isAvailable(restaurant.discount!.startTime, restaurant.discount!.endTime))
            ? 'percent' : cartModel.product!.discountType;

        double d = ((cartModel.product!.price! - PriceConverter.convertWithDiscount(cartModel.product!.price!, dis, disType)!) * cartModel.quantity!);
        discount = discount! + d;
        discount = discount + _calculateVariationPrice(restaurant: restaurant, cartModel: cartModel);


      }

      if (restaurant.discount != null) {
        if (restaurant.discount!.maxDiscount != 0 && restaurant.discount!.maxDiscount! < discount!) {
          discount = restaurant.discount!.maxDiscount;
        }
        if (restaurant.discount!.minPurchase != 0 && restaurant.discount!.minPurchase! > (price + addOns)) {
          discount = 0;
        }
      }

    }
    return PriceConverter.toFixed(discount!);
  }

  double _calculateVariationPrice({required Restaurant? restaurant, required CartModel? cartModel}) {
    double variationPrice = 0;
    double variationDiscount = 0;
    if(restaurant != null && cartModel != null) {

      double? discount = (restaurant.discount != null
          && DateConverter.isAvailable(restaurant.discount!.startTime, restaurant.discount!.endTime))
          ? restaurant.discount!.discount : cartModel.product!.discount;
      String? discountType = (restaurant.discount != null
          && DateConverter.isAvailable(restaurant.discount!.startTime, restaurant.discount!.endTime))
          ? 'percent' : cartModel.product!.discountType;

      for(int index = 0; index< cartModel.product!.variations!.length; index++) {
        for(int i=0; i<cartModel.product!.variations![index].variationValues!.length; i++) {
          if(cartModel.variations![index][i]!) {
            variationPrice += (PriceConverter.convertWithDiscount(cartModel.product!.variations![index].variationValues![i].optionPrice!, discount, discountType, isVariation: true)! * cartModel.quantity!);
            variationDiscount += (cartModel.product!.variations![index].variationValues![i].optionPrice! * cartModel.quantity!);
          }
        }
      }
    }

    return variationDiscount - variationPrice;
  }

  double _calculateSubTotal(double price, double addOnsPrice) {
    double subTotal = price + addOnsPrice;
    return PriceConverter.toFixed(subTotal);
  }

  double _calculateOrderAmount(double price, double addOnsPrice, double discount, double couponDiscount) {
    double orderAmount = (price - discount) + addOnsPrice - couponDiscount;
    return PriceConverter.toFixed(orderAmount);
  }

  double _calculateTax(bool taxIncluded, double orderAmount, double? taxPercent) {
    double tax = 0;
    if(taxIncluded){
      tax = orderAmount * taxPercent! /(100 + taxPercent);
    }else {
      tax = PriceConverter.calculation(orderAmount, taxPercent, 'percent', 1);
    }
    return PriceConverter.toFixed(tax);
  }

  int _getSubscriptionQty({required CheckoutController checkoutController, required bool restaurantSubscriptionActive}) {
    int subscriptionQty = checkoutController.subscriptionOrder ? 0 : 1;
    if(restaurantSubscriptionActive){
      if(checkoutController.subscriptionOrder && checkoutController.subscriptionRange != null) {
        if(checkoutController.subscriptionType == 'weekly') {
          List<int> weekDays = [];
          for(int index=0; index<checkoutController.selectedDays.length; index++) {
            if(checkoutController.selectedDays[index] != null) {
              weekDays.add(index + 1);
            }
          }
          subscriptionQty = DateConverter.getWeekDaysCount(checkoutController.subscriptionRange!, weekDays);
        }else if(checkoutController.subscriptionType == 'monthly') {
          List<int> days = [];
          for(int index=0; index<checkoutController.selectedDays.length; index++) {
            if(checkoutController.selectedDays[index] != null) {
              days.add(index + 1);
            }
          }
          subscriptionQty = DateConverter.getMonthDaysCount(checkoutController.subscriptionRange!, days);
        }else {
          subscriptionQty = checkoutController.subscriptionRange!.duration.inDays + 1;
        }
      }
    }
    return subscriptionQty;
  }

  double _calculateTotal(
      double subTotal, double deliveryCharge, double discount, double couponDiscount,
      bool taxIncluded, double tax, bool showTips, double tips, double additionalCharge) {

    double total = subTotal + deliveryCharge - discount - couponDiscount + (taxIncluded ? 0 : tax)
        + (showTips ? tips : 0) + additionalCharge;

    return PriceConverter.toFixed(total);
  }
}