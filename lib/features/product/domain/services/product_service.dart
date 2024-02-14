import 'package:stackfood_multivendor/common/models/product_model.dart';
import 'package:stackfood_multivendor/features/cart/domain/models/cart_model.dart';
import 'package:stackfood_multivendor/features/product/domain/repositories/product_repository_interface.dart';
import 'package:stackfood_multivendor/features/product/domain/services/product_service_interface.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/common/widgets/custom_snackbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductService implements ProductServiceInterface {
  final ProductRepositoryInterface productRepositoryInterface;

  ProductService({required this.productRepositoryInterface});

  @override
  Future<List<Product>?> getPopularProductList({required String type}) async {
    return await productRepositoryInterface.getList(type: type);
  }

  @override
  List<bool> initializeCartAddonActiveList(Product? product, List<AddOn>? addOnIds) {
    List<int?> addOnIdList = [];
    List<bool> addOnActiveList = [];
    if(addOnIds != null) {
      for (var addOnId in addOnIds) {
        addOnIdList.add(addOnId.id);
      }
      for (var addOn in product!.addOns!) {
        if(addOnIdList.contains(addOn.id)) {
          addOnActiveList.add(true);
        }else {
          addOnActiveList.add(false);
        }
      }
    }
    return addOnActiveList;
  }

  @override
  List<int?> initializeCartAddonQuantityList(Product? product, List<AddOn>? addOnIds) {
    List<int?> addOnIdList = [];
    List<int?> addOnQtyList = [];
    if(addOnIds != null) {
      for (var addOnId in addOnIds) {
        addOnIdList.add(addOnId.id);
      }
      for (var addOn in product!.addOns!) {
        if(addOnIdList.contains(addOn.id)) {
          addOnQtyList.add(addOnIds[addOnIdList.indexOf(addOn.id)].quantity);
        }else {
          addOnQtyList.add(1);
        }
      }
    }
    return addOnQtyList;
  }

  @override
  List<bool> initializeCollapseVariation(List<Variation>? variations) {
    List<bool> collapseVariation = [];
    if(variations != null){
      for(int index=0; index<variations.length; index++){
        collapseVariation.add(true);
      }
    }
    return collapseVariation;
  }

  @override
  List<List<bool?>> initializeSelectedVariation(List<Variation>? variations) {
    List<List<bool?>> selectedVariations = [];
    if(variations != null){
      for(int index=0; index<variations.length; index++){
        selectedVariations.add([]);
        for(int i=0; i < variations[index].variationValues!.length; i++) {
          selectedVariations[index].add(false);
        }
      }
    }
    return selectedVariations;
  }

  @override
  List<bool> initializeAddonActiveList(List<AddOns>? addOns) {
    List<bool> addOnActiveList = [];
    for (var addOn in addOns!) {
      debugPrint('$addOn');
      addOnActiveList.add(false);
    }
    return addOnActiveList;
  }

  @override
  List<int?> initializeAddonQuantityList(List<AddOns>? addOns) {
    List<int?> addOnQtyList = [];
    for (var addOn in addOns!) {
      debugPrint('$addOn');
      addOnQtyList.add(1);
    }
    return addOnQtyList;
  }

  @override
  int setAddonQuantity(int addOnQty, bool isIncrement) {
    int qty = addOnQty;
    if (isIncrement) {
      qty = qty + 1;
    } else {
      qty = qty - 1;
    }
    return qty;
  }

  @override
  int setQuantity(bool isIncrement, int? quantityLimit, int quantity) {
    int qty = quantity;
    if (isIncrement) {
      if(quantityLimit != null ){
        if(qty >= quantityLimit && quantityLimit != 0) {
          showCustomSnackBar('${'maximum_quantity_limit'.tr} $quantityLimit', showToaster: true);
        } else {
          qty = qty + 1;
        }
      }else {
        qty = qty + 1;
      }
    } else {
      qty = qty - 1;
    }
    return qty;
  }

  @override
  List<List<bool?>> setCartVariationIndex(int index, int i, List<Variation>? variations, bool isMultiSelect, List<List<bool?>> selectedVariations) {
    List<List<bool?>> resultVariations = selectedVariations;
    if(!isMultiSelect) {
      for(int j = 0; j < resultVariations[index].length; j++) {
        if(variations![index].required!){
          resultVariations[index][j] = j == i;
        }else{
          if(resultVariations[index][j]!){
            resultVariations[index][j] = false;
          }else{
            resultVariations[index][j] = j == i;
          }
        }
      }
    } else {
      if(!resultVariations[index][i]! && selectedVariationLength(resultVariations, index) >= variations![index].max!) {
        _showUpperCartSnackBar('${'maximum_variation_for'.tr} ${variations[index].name} ${'is'.tr} ${variations[index].max}');
      }else {
        resultVariations[index][i] = !resultVariations[index][i]!;
      }
    }
    return resultVariations;
  }

  @override
  int selectedVariationLength(List<List<bool?>> selectedVariations, int index) {
    int length = 0;
    for(bool? isSelected in selectedVariations[index]) {
      if(isSelected!) {
        length++;
      }
    }
    return length;
  }

  void _showUpperCartSnackBar(String message) {
    Get.showSnackbar(GetSnackBar(
      backgroundColor: Colors.red,
      message: message,
      duration: const Duration(seconds: 3),
      maxWidth: Dimensions.webMaxWidth,
      snackStyle: SnackStyle.FLOATING,
      margin: const EdgeInsets.all(Dimensions.paddingSizeSmall),
      borderRadius: 10,
      isDismissible: true,
      dismissDirection: DismissDirection.horizontal,
    ));
  }

  @override
  int isExistInCartForBottomSheet(List<CartModel> cartList, int? productID, int? cartIndex, List<List<bool?>>? variations) {
    for(int index=0; index<cartList.length; index++) {
      if(cartList[index].product!.id == productID) {
        if((index == cartIndex)) {
          return -1;
        }else {
          if(variations != null) {
            bool same = false;
            for(int i=0; i<variations.length; i++) {
              for(int j=0; j<variations[i].length; j++) {
                if(variations[i][j] == cartList[index].variations![i][j]) {
                  same = true;
                } else {
                  same = false;
                  break;
                }

              }
              if(!same) {
                break;
              }
            }
            if(!same) {
              continue;
            }
            if(same) {
              return index;
            } else {
              return -1;
            }
          } else {
            return -1;
          }
        }
      }
    }
    return -1;
  }

}