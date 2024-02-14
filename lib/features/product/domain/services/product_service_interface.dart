
import 'package:stackfood_multivendor/common/models/product_model.dart';
import 'package:stackfood_multivendor/features/cart/domain/models/cart_model.dart';

abstract class ProductServiceInterface {
  Future<List<Product>?> getPopularProductList({required String type});
  List<bool> initializeCartAddonActiveList(Product? product, List<AddOn>? addOnIds);
  List<int?> initializeCartAddonQuantityList(Product? product, List<AddOn>? addOnIds);
  List<bool> initializeCollapseVariation(List<Variation>? variations);
  List<List<bool?>> initializeSelectedVariation(List<Variation>? variations);
  List<bool> initializeAddonActiveList(List<AddOns>? addOns);
  List<int?> initializeAddonQuantityList(List<AddOns>? addOns);
  int setAddonQuantity(int addOnQty, bool isIncrement);
  int setQuantity(bool isIncrement, int? quantityLimit, int quantity);
  List<List<bool?>> setCartVariationIndex(int index, int i, List<Variation>? variations, bool isMultiSelect, List<List<bool?>> selectedVariations);
  int selectedVariationLength(List<List<bool?>> selectedVariations, int index);
  int isExistInCartForBottomSheet(List<CartModel> cartList, int? productID, int? cartIndex, List<List<bool?>>? variations);
}