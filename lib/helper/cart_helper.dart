import 'package:stackfood_multivendor/common/models/online_cart_model.dart';
import 'package:stackfood_multivendor/features/checkout/domain/models/place_order_body_model.dart';
import 'package:stackfood_multivendor/features/cart/domain/models/cart_model.dart';
import 'package:stackfood_multivendor/common/models/product_model.dart';
import 'package:stackfood_multivendor/common/models/product_model.dart' as pv;
import 'package:stackfood_multivendor/helper/price_converter.dart';

class CartHelper {

  static List<OrderVariation> getSelectedVariations ({required List<pv.Variation>? productVariations, required List<List<bool?>> selectedVariations}) {
    List<OrderVariation> variations = [];
    for(int i=0; i<productVariations!.length; i++) {
      if(selectedVariations[i].contains(true)) {
        variations.add(OrderVariation(name: productVariations[i].name, values: OrderVariationValue(label: [])));
        for(int j=0; j<productVariations[i].variationValues!.length; j++) {
          if(selectedVariations[i][j]!) {
            variations[variations.length-1].values!.label!.add(productVariations[i].variationValues![j].level);
          }
        }
      }
    }

    return variations;
  }

  static getSelectedAddonIds({required List<AddOn> addOnIdList }) {
    List<int?> listOfAddOnId = [];
    for (var addOn in addOnIdList) {
      listOfAddOnId.add(addOn.id);
    }
    return listOfAddOnId;
  }

  static getSelectedAddonQtnList({required List<AddOn> addOnIdList }) {
    List<int?> listOfAddOnQty = [];
    for (var addOn in addOnIdList) {
      listOfAddOnQty.add(addOn.quantity);
    }
    return listOfAddOnQty;
  }

  static List<CartModel> formatOnlineCartToLocalCart({required List<OnlineCartModel> onlineCartModel}) {

    List<CartModel> cartList = [];
    for (OnlineCartModel cart in onlineCartModel) {
      double price = cart.price!;
      double? discount = cart.product!.restaurantDiscount == 0 ? cart.product!.discount! : cart.product!.restaurantDiscount!;
      String? discountType = (cart.product!.restaurantDiscount == 0) ? cart.product!.discountType : 'percent';
      double discountedPrice = PriceConverter.convertWithDiscount(price, discount, discountType)!;

      double? discountAmount = price - discountedPrice;
      int? quantity = cart.quantity;

      List<List<bool?>> selectedFoodVariations = [];
      List<bool> collapsVariation = [];

      for(int index=0; index<cart.product!.variations!.length; index++) {
        selectedFoodVariations.add([]);
        collapsVariation.add(true);
        for(int i=0; i < cart.product!.variations![index].variationValues!.length; i++) {
          if(cart.product!.variations![index].variationValues![i].isSelected ?? false){
            selectedFoodVariations[index].add(true);
          } else {
            selectedFoodVariations[index].add(false);
          }
        }
      }

      List<AddOn> addOnIdList = [];
      List<AddOns> addOnsList = [];
      for (int index = 0; index < cart.addOnIds!.length; index++) {
        addOnIdList.add(AddOn(id: cart.addOnIds![index], quantity: cart.addOnQtys![index]));
        for (int i=0; i< cart.product!.addOns!.length; i++) {
          if(cart.addOnIds![index] == cart.product!.addOns![i].id) {
            addOnsList.add(AddOns(id: cart.product!.addOns![i].id, name: cart.product!.addOns![i].name, price: cart.product!.addOns![i].price));
          }
        }
      }

      int? quantityLimit = cart.product!.quantityLimit;

      cartList.add(
        CartModel(
          cart.id, price, discountedPrice, discountAmount, quantity,
          addOnIdList, addOnsList, false, cart.product, selectedFoodVariations, quantityLimit,
        ),
      );

    }


    return cartList;
  }

  static String setupVariationText({required CartModel cart}) {
    String variationText = '';

    if(cart.variations!.isNotEmpty) {
      for(int index=0; index<cart.variations!.length; index++) {
        if(cart.variations![index].isNotEmpty && cart.variations![index].contains(true)) {
          variationText = '$variationText${variationText.isNotEmpty ? ', ' : ''}${cart.product!.variations![index].name} (';

          for(int i=0; i<cart.variations![index].length; i++) {
            if(cart.variations![index][i]!) {
              variationText = '$variationText${variationText.endsWith('(') ? '' : ', '}${cart.product!.variations![index].variationValues![i].level}';
            }
          }
          variationText = '$variationText)';
        }
      }
    }

    return variationText;
  }

  static String? setupAddonsText({required CartModel cart}) {
    String addOnText = '';
    int index0 = 0;
    List<int?> ids = [];
    List<int?> qtys = [];
    for (var addOn in cart.addOnIds!) {
      ids.add(addOn.id);
      qtys.add(addOn.quantity);
    }
    for (var addOn in cart.product!.addOns!) {
      if (ids.contains(addOn.id)) {
        addOnText = '$addOnText${(index0 == 0) ? '' : ',  '}${addOn.name} (${qtys[index0]})';
        index0 = index0 + 1;
      }
    }
    return addOnText;
  }
}