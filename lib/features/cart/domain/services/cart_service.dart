import 'package:stackfood_multivendor/common/models/online_cart_model.dart';
import 'package:stackfood_multivendor/common/models/product_model.dart';
import 'package:stackfood_multivendor/common/widgets/custom_snackbar_widget.dart';
import 'package:stackfood_multivendor/features/checkout/domain/models/place_order_body_model.dart';
import 'package:stackfood_multivendor/features/cart/domain/models/cart_model.dart';
import 'package:stackfood_multivendor/features/cart/domain/repositories/cart_repository_interface.dart';
import 'package:stackfood_multivendor/features/cart/domain/services/cart_service_interface.dart';
import 'package:stackfood_multivendor/helper/price_converter.dart';
import 'package:get/get_utils/get_utils.dart';

class CartService implements CartServiceInterface {
  final CartRepositoryInterface cartRepositoryInterface;
  CartService({required this.cartRepositoryInterface});

  @override
  Future<List<OnlineCartModel>> addMultipleCartItemOnline(List<OnlineCart> carts) async {
    return cartRepositoryInterface.addMultipleCartItemOnline(carts);
  }

  @override
  List<CartModel> formatOnlineCartToLocalCart({required List<OnlineCartModel> onlineCartModel}) {

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

  @override
  void addToSharedPrefCartList(List<CartModel> cartProductList) {
    cartRepositoryInterface.addToSharedPrefCartList(cartProductList);
  }

  @override
  Future<bool> clearCartOnline(String? guestId) async {
    return await cartRepositoryInterface.clearCartOnline(guestId);
  }

  @override
  int decideProductQuantity(List<CartModel> cartList, bool isIncrement, int index) {
    int quantity = cartList[index].quantity!;
    if (isIncrement) {
      int? quantityLimit = cartList[index].product!.quantityLimit;
      if(quantityLimit != null) {
        if(quantity >= quantityLimit && quantityLimit != 0) {
          showCustomSnackBar('${'maximum_quantity_limit'.tr} $quantityLimit', showToaster: true);
        } else {
          quantity = quantity + 1;
        }
      }else {
        quantity = quantity + 1;
      }
    } else {
      quantity = quantity - 1;
    }
    return quantity;
  }

  @override
  Future<bool> updateCartQuantityOnline(int cartId, double price, int quantity, String? guestId) async {
    return await cartRepositoryInterface.updateCartQuantityOnline(cartId, price, quantity, guestId);
  }

  @override
  int isExistInCart(int? productID, int? cartIndex, List<CartModel> cartList) {
    for(int index=0; index<cartList.length; index++) {
      if(cartList[index].product!.id == productID) {
        if((index == cartIndex)) {
          return -1;
        }else {
          return index;
        }
      }
    }
    return -1;
  }

  @override
  bool existAnotherRestaurantProduct(int? restaurantID, List<CartModel> cartList) {
    for(CartModel cartModel in cartList) {
      if(cartModel.product!.restaurantId != restaurantID) {
        return true;
      }
    }
    return false;
  }

  @override
  int setAvailableIndex(int index, int notAvailableIndex) {
    int finalIndex = notAvailableIndex;
    if (notAvailableIndex == index) {
      finalIndex = -1;
    } else {
      finalIndex = index;
    }
    return finalIndex;
  }

  @override
  int cartQuantity(int productID, List<CartModel> cartList) {
    int quantity = 0;
    for(CartModel cart in cartList) {
      if(cart.product!.id == productID) {
        quantity += cart.quantity!;
      }
    }
    return quantity;
  }

  @override
  Future<List<OnlineCartModel>> addToCartOnline(OnlineCart cart, String? guestId) async {
    return await cartRepositoryInterface.addToCartOnline(cart, guestId);
  }

  @override
  Future<List<OnlineCartModel>> updateCartOnline(OnlineCart cart, int? guestId) async {
    return await cartRepositoryInterface.update(cart.toJson(), guestId);
  }

  @override
  Future<List<OnlineCartModel>> getCartDataOnline(String? id) async {
    return await cartRepositoryInterface.get(id);
  }

  @override
  Future<bool> removeCartItemOnline(int? cartId, String? guestId) async {
    return await cartRepositoryInterface.delete(cartId, guestId: guestId);
  }

  @override
  List<AddOns> prepareAddonList(CartModel cartModel) {
    List<AddOns> addOnList = [];
    for (var addOnId in cartModel.addOnIds!) {
      for(AddOns addOns in cartModel.product!.addOns!) {
        if(addOns.id == addOnId.id) {
          addOnList.add(addOns);
          break;
        }
      }
    }
    return addOnList;
  }

  @override
  double calculateAddonsPrice(List<AddOns> addOnList, double price, CartModel cartModel) {
    double addOnsPrice = price;
    for(int index=0; index<addOnList.length; index++) {
      addOnsPrice = addOnsPrice + (addOnList[index].price! * cartModel.addOnIds![index].quantity!);
    }
    return addOnsPrice;
  }

  @override
  double calculateVariationWithoutDiscountPrice(CartModel cartModel, double price, double? discount, String? discountType) {
    double variationWithoutDiscountPrice = price;
    if(cartModel.product!.variations!.isNotEmpty) {
      for(int index = 0; index< cartModel.product!.variations!.length; index++) {
        for(int i=0; i<cartModel.product!.variations![index].variationValues!.length; i++) {
          if(cartModel.variations![index][i]!) {
            variationWithoutDiscountPrice += (PriceConverter.convertWithDiscount(cartModel.product!.variations![index].variationValues![i].optionPrice!, discount, discountType, isVariation: true)! * cartModel.quantity!);
          }
        }
      }
    } else {
      variationWithoutDiscountPrice = 0;
    }
    return variationWithoutDiscountPrice;
  }

  @override
  double calculateVariationPrice(CartModel cartModel, double price) {
    double variationPrice = price;
    if(cartModel.product!.variations!.isNotEmpty) {
      for(int index = 0; index< cartModel.product!.variations!.length; index++) {
        for(int i=0; i<cartModel.product!.variations![index].variationValues!.length; i++) {
          if(cartModel.variations![index][i]!) {
            variationPrice += (cartModel.product!.variations![index].variationValues![i].optionPrice! * cartModel.quantity!);
          }
        }
      }
    } else {
      variationPrice = 0;
    }
    return variationPrice;
  }

}