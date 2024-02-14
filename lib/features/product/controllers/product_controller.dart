import 'package:stackfood_multivendor/features/cart/controllers/cart_controller.dart';
import 'package:stackfood_multivendor/features/checkout/domain/models/place_order_body_model.dart';
import 'package:stackfood_multivendor/features/cart/domain/models/cart_model.dart';
import 'package:stackfood_multivendor/common/models/product_model.dart';
import 'package:stackfood_multivendor/features/product/domain/services/product_service_interface.dart';
import 'package:stackfood_multivendor/helper/price_converter.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/util/images.dart';
import 'package:stackfood_multivendor/common/widgets/cart_snackbar_widget.dart';
import 'package:stackfood_multivendor/common/widgets/confirmation_dialog_widget.dart';
import 'package:stackfood_multivendor/common/widgets/product_bottom_sheet_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductController extends GetxController implements GetxService {
  final ProductServiceInterface productServiceInterface;
  ProductController({required this.productServiceInterface});

  List<Product>? _popularProductList;
  List<Product>? get popularProductList => _popularProductList;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<List<bool?>> _selectedVariations = [];
  List<List<bool?>> get selectedVariations => _selectedVariations;

  int? _quantity = 1;
  int? get quantity => _quantity;

  List<bool> _addOnActiveList = [];
  List<bool> get addOnActiveList => _addOnActiveList;

  List<int?> _addOnQtyList = [];
  List<int?> get addOnQtyList => _addOnQtyList;

  String _popularType = 'all';
  String get popularType => _popularType;

  static final List<String> _productTypeList = ['all', 'veg', 'non_veg'];
  List<String> get productTypeList => _productTypeList;

  int _cartIndex = -1;
  int get cartIndex => _cartIndex;

  int _imageIndex = 0;
  int get imageIndex => _imageIndex;

  List<bool> _collapseVariation = [];
  List<bool> get collapseVariation => _collapseVariation;

  bool _canAddToCartProduct = true;
  bool get canAddToCartProduct => _canAddToCartProduct;

  void changeCanAddToCartProduct(bool status) {
    _canAddToCartProduct = status;
  }

  Future<void> getPopularProductList(bool reload, String type, bool notify) async {
    _popularType = type;
    if(reload) {
      _popularProductList = null;
    }
    if(notify) {
      update();
    }
    if(_popularProductList == null || reload) {
      _popularProductList = await productServiceInterface.getPopularProductList(type: type);
      update();
    }
  }

  void showBottomLoader() {
    _isLoading = true;
    update();
  }

  void setImageIndex(int index, bool notify) {
    _imageIndex = index;
    if(notify) {
      update();
    }
  }

  void initData(Product? product, CartModel? cart) {
    _canAddToCartProduct = true;
    _selectedVariations = [];
    _addOnQtyList = [];
    _addOnActiveList = [];
    _collapseVariation = [];
    if(cart != null) {
      _quantity = cart.quantity;
      _selectedVariations.addAll(cart.variations!);
      _addOnActiveList = productServiceInterface.initializeCartAddonActiveList(product, cart.addOnIds);
      _addOnQtyList = productServiceInterface.initializeCartAddonQuantityList(product, cart.addOnIds);
      _collapseVariation = productServiceInterface.initializeCollapseVariation(product!.variations);

    }else {
      _quantity = 1;
      _selectedVariations = productServiceInterface.initializeSelectedVariation(product!.variations);
      _collapseVariation = productServiceInterface.initializeCollapseVariation(product.variations);
      _addOnActiveList = productServiceInterface.initializeAddonActiveList(product.addOns);
      _addOnQtyList = productServiceInterface.initializeAddonQuantityList(product.addOns);

    }
    setExistInCartForBottomSheet(product, selectedVariations);
  }

  int selectedVariationLength(List<List<bool?>> selectedVariations, int index) {
    return productServiceInterface.selectedVariationLength(selectedVariations, index);
  }

  int setExistInCart(Product product, {bool notify = true}) {
    _cartIndex = Get.find<CartController>().isExistInCart(product.id, null);
    if(_cartIndex != -1) {
      _quantity = Get.find<CartController>().cartList[_cartIndex].quantity;
      _addOnActiveList = productServiceInterface.initializeCartAddonActiveList(product, Get.find<CartController>().cartList[_cartIndex].addOnIds!);
      _addOnQtyList = productServiceInterface.initializeCartAddonQuantityList(product, Get.find<CartController>().cartList[_cartIndex].addOnIds!);
    }
    return _cartIndex;
  }

  int setExistInCartForBottomSheet(Product product, List<List<bool?>>? selectedVariations, {bool notify = true}) {

    _cartIndex = productServiceInterface.isExistInCartForBottomSheet(Get.find<CartController>().cartList, product.id, null, selectedVariations);
    if(_cartIndex != -1) {
      _quantity = Get.find<CartController>().cartList[_cartIndex].quantity;
      _addOnActiveList = productServiceInterface.initializeCartAddonActiveList(product, Get.find<CartController>().cartList[_cartIndex].addOnIds!);
      _addOnQtyList = productServiceInterface.initializeCartAddonQuantityList(product, Get.find<CartController>().cartList[_cartIndex].addOnIds!);
    } else {
      _quantity = 1;
    }
    return _cartIndex;
  }

  void setAddOnQuantity(bool isIncrement, int index) {
    _addOnQtyList[index] = productServiceInterface.setAddonQuantity(_addOnQtyList[index]!, isIncrement);
    update();
  }

  void setQuantity(bool isIncrement, int? quantityLimit) {
    _quantity = productServiceInterface.setQuantity(isIncrement, quantityLimit, _quantity!);
    update();
  }

  void setCartVariationIndex(int index, int i, Product? product, bool isMultiSelect) {
    _selectedVariations = productServiceInterface.setCartVariationIndex(index, i, product!.variations, isMultiSelect, _selectedVariations);
    update();
  }

  void addAddOn(bool isAdd, int index) {
    _addOnActiveList[index] = isAdd;
    update();
  }

  void showMoreSpecificSection(int index){
    _collapseVariation[index] = !_collapseVariation[index];
    update();
  }

  void productDirectlyAddToCart(Product? product, BuildContext context, {bool inStore = false, bool isCampaign = false}) {

    if (product!.variations == null || (product.variations != null && product.variations!.isEmpty)) {
      double price = product.price!;
      double discount = product.discount!;
      double discountPrice = PriceConverter.convertWithDiscount(price, discount, product.discountType)!;

      CartModel cartModel = CartModel(
        null, price, discountPrice, (price - discountPrice),
        1, [], [], false, product, [], product.quantityLimit,
      );

      OnlineCart onlineCart = OnlineCart(
        null, isCampaign ? null : product.id, isCampaign ? product.id : null,
        discountPrice.toString(), [], 1, [], [], [], 'Food',
      );

      setExistInCart(product);

      if (Get.find<CartController>().existAnotherRestaurantProduct(cartModel.product!.restaurantId)) {
        Get.dialog(ConfirmationDialogWidget(
          icon: Images.warning,
          title: 'are_you_sure_to_reset'.tr,
          description: 'if_you_continue'.tr,
          onYesPressed: () {
            Get.find<CartController>().clearCartOnline().then((success) async {
              if (success) {
                await Get.find<CartController>().addToCartOnline(onlineCart);
                Get.back();
                showCartSnackBarWidget();
              }
            });
          },
        ), barrierDismissible: false);
      } else {
        Get.find<CartController>().addToCartOnline(onlineCart);
        showCartSnackBarWidget();
      }
    } else {
      ResponsiveHelper.isMobile(context) ? Get.bottomSheet(
        ProductBottomSheetWidget(product: product, isCampaign: false),
        backgroundColor: Colors.transparent, isScrollControlled: true,
      ) : Get.dialog(
        Dialog(child: ProductBottomSheetWidget(product: product, isCampaign: false)),
      );
    }
  }

}
