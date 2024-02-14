import 'package:stackfood_multivendor/common/widgets/product_widget.dart';
import 'package:stackfood_multivendor/features/splash/controllers/theme_controller.dart';
import 'package:stackfood_multivendor/common/models/product_model.dart';
import 'package:stackfood_multivendor/features/cart/domain/models/cart_model.dart';
import 'package:stackfood_multivendor/features/restaurant/controllers/restaurant_controller.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CartSuggestedItemViewWidget extends StatelessWidget {
  final List<CartModel> cartList;
  const CartSuggestedItemViewWidget({super.key, required this.cartList});

  @override
  Widget build(BuildContext context) {
    bool isDesktop = ResponsiveHelper.isDesktop(context);
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor.withOpacity(Get.find<ThemeController>().darkTheme ? 0 : 1),
        borderRadius: BorderRadius.circular(isDesktop ? Dimensions.radiusDefault : 0),
        boxShadow: isDesktop ? const [BoxShadow(color: Colors.black12, blurRadius: 5, spreadRadius: 1)] : [],
      ),
      width: double.infinity,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

        GetBuilder<RestaurantController>(builder: (restaurantController) {
          List<Product>? suggestedItems;
          if(restaurantController.suggestedItems != null){
            suggestedItems = [];
            List<int> cartIds = [];
            for (CartModel cartItem in cartList) {
              cartIds.add(cartItem.product!.id!);
            }
            for (Product item in restaurantController.suggestedItems!) {
              if(!cartIds.contains(item.id)){
                suggestedItems.add(item);
              }
            }
          }
          return restaurantController.suggestedItems != null && suggestedItems!.isNotEmpty ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: Dimensions.paddingSizeSmall),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeExtraSmall),
                child: Text('you_may_also_like'.tr, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault)),
              ),

              SizedBox(
                height: isDesktop ? 165 : 155,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: suggestedItems.length,
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.only(left: isDesktop ? Dimensions.paddingSizeExtraSmall : Dimensions.paddingSizeDefault),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: isDesktop ? const EdgeInsets.symmetric(vertical: 20) : const EdgeInsets.symmetric(vertical: 10) ,
                      child: Container(
                        width: isDesktop ? 350 : 300,
                        padding: const EdgeInsets.only(right: Dimensions.paddingSizeSmall, left: Dimensions.paddingSizeExtraSmall),
                        margin: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
                        child: ProductWidget(
                          isRestaurant: false,
                          product: suggestedItems![index],
                          fromCartSuggestion: true,
                          restaurant: null, index: index, length: null, isCampaign: false,
                          inRestaurant: false,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ) : const SizedBox();
        }),
      ]),
    );
  }
}
