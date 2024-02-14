import 'package:stackfood_multivendor/features/cart/controllers/cart_controller.dart';
import 'package:stackfood_multivendor/features/cart/widgets/cart_product_widget.dart';
import 'package:stackfood_multivendor/features/cart/widgets/cart_suggested_item_view_widget.dart';
import 'package:stackfood_multivendor/features/cart/widgets/checkout_button_widget.dart';
import 'package:stackfood_multivendor/features/cart/widgets/pricing_view_widget.dart';
import 'package:stackfood_multivendor/features/restaurant/controllers/restaurant_controller.dart';
import 'package:stackfood_multivendor/common/models/restaurant_model.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/helper/route_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:stackfood_multivendor/common/widgets/custom_app_bar_widget.dart';
import 'package:stackfood_multivendor/common/widgets/footer_view_widget.dart';
import 'package:stackfood_multivendor/common/widgets/menu_drawer_widget.dart';
import 'package:stackfood_multivendor/common/widgets/no_data_screen_widget.dart';
import 'package:stackfood_multivendor/common/widgets/web_constrained_box.dart';
import 'package:stackfood_multivendor/common/widgets/web_page_title_widget.dart';
import 'package:stackfood_multivendor/features/restaurant/screens/restaurant_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CartScreen extends StatefulWidget {
  final bool fromNav;
  final bool fromReorder;
  const CartScreen({super.key, required this.fromNav, this.fromReorder = false});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {

  final ScrollController scrollController = ScrollController();
  @override
  void initState() {
    super.initState();

    initCall();
  }

  Future<void> initCall() async {
    await Get.find<CartController>().getCartDataOnline();
    if(Get.find<CartController>().cartList.isNotEmpty){
      await Get.find<RestaurantController>().getRestaurantDetails(Restaurant(id: Get.find<CartController>().cartList[0].product!.restaurantId, name: null), fromCart: true);
      Get.find<CartController>().calculationCart();
      if(Get.find<CartController>().addCutlery){
        Get.find<CartController>().updateCutlery(isUpdate: false);
      }
      Get.find<CartController>().setAvailableIndex(-1, isUpdate: false);
      Get.find<RestaurantController>().getCartRestaurantSuggestedItemList(Get.find<CartController>().cartList[0].product!.restaurantId);
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDesktop = ResponsiveHelper.isDesktop(context);
    return Scaffold(
      appBar: CustomAppBarWidget(title: 'my_cart'.tr, isBackButtonExist: (isDesktop || !widget.fromNav)),
      endDrawer: const MenuDrawerWidget(), endDrawerEnableOpenDragGesture: false,
      body: GetBuilder<RestaurantController>(builder: (restaurantController) {
        return GetBuilder<CartController>(builder: (cartController) {

          bool suggestionEmpty = (restaurantController.suggestedItems != null && restaurantController.suggestedItems!.isEmpty);
          return (cartController.isLoading && widget.fromReorder) ? const Center(
            child: SizedBox(height: 30, width: 30, child: CircularProgressIndicator()),
          ) : cartController.cartList.isNotEmpty ? Column(
            children: [
              WebScreenTitleWidget(title: 'my_cart'.tr),

              Expanded(
                child: Scrollbar(
                  controller: scrollController,
                  child: SingleChildScrollView(
                    controller: scrollController,
                    padding: isDesktop ? const EdgeInsets.only(top: Dimensions.paddingSizeSmall) : EdgeInsets.zero,
                    child: FooterViewWidget(
                      child: Center(
                        child: SizedBox(
                          width: Dimensions.webMaxWidth,
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Expanded(
                                flex: 6,
                                child: Column(children: [
                                  Container(
                                    decoration: isDesktop ? BoxDecoration(
                                      borderRadius: const  BorderRadius.all(Radius.circular(Dimensions.radiusDefault)),
                                      color: Theme.of(context).cardColor,
                                      boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5, spreadRadius: 1)],
                                    ) : const BoxDecoration(),
                                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                      WebConstrainedBox(
                                        dataLength: cartController.cartList.length, minLength: 5, minHeight: suggestionEmpty ? 0.6 : 0.4,
                                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                          ConstrainedBox(
                                            constraints: BoxConstraints(maxHeight: isDesktop ? MediaQuery.of(context).size.height * 0.4 : double.infinity),
                                            child: ListView.builder(
                                              physics: isDesktop ? const AlwaysScrollableScrollPhysics() : const NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                                              itemCount: cartController.cartList.length,
                                              itemBuilder: (context, index) {
                                                return CartProductWidget(
                                                  cart: cartController.cartList[index], cartIndex: index, addOns: cartController.addOnsList[index],
                                                  isAvailable: cartController.availableList[index],
                                                );
                                              },
                                            ),
                                          ),

                                          !isDesktop ? const Divider(thickness: 0.5, height: 5) : const SizedBox(),

                                          Center(
                                            child: TextButton.icon(
                                              onPressed: (){
                                                Get.toNamed(
                                                  RouteHelper.getRestaurantRoute(cartController.cartList[0].product!.restaurantId),
                                                  arguments: RestaurantScreen(restaurant: Restaurant(id: cartController.cartList[0].product!.restaurantId)),
                                                );
                                              },
                                              icon: Icon(Icons.add_circle_outline_sharp, color: Theme.of(context).primaryColor),
                                              label: Text('add_more_items'.tr, style: robotoMedium.copyWith(color: Theme.of(context).primaryColor, fontSize: Dimensions.fontSizeDefault)),
                                            ),
                                          ),

                                          !isDesktop ? CartSuggestedItemViewWidget(cartList: cartController.cartList) : const SizedBox(),
                                        ]),
                                      ),
                                      const SizedBox(height: Dimensions.paddingSizeSmall),

                                      !isDesktop ? PricingViewWidget(cartController: cartController) : const SizedBox(),
                                    ]),
                                  ),
                                  const SizedBox(height: Dimensions.paddingSizeSmall),

                                  isDesktop ? CartSuggestedItemViewWidget(cartList: cartController.cartList) : const SizedBox(),
                                ]),
                              ),
                              SizedBox(width: isDesktop ? Dimensions.paddingSizeLarge : 0),

                              isDesktop ? Expanded(flex: 4, child: PricingViewWidget(cartController: cartController)) : const SizedBox(),

                            ]),

                          ]),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              isDesktop ? const SizedBox.shrink() : CheckoutButtonWidget(cartController: cartController, availableList: cartController.availableList),

            ],
          ) : const SingleChildScrollView(child: FooterViewWidget(child: NoDataScreen(isCart: true, title: '')));
        },
        );
      }),
    );
  }

}




