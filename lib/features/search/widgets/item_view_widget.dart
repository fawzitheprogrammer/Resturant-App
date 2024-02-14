import 'package:stackfood_multivendor/features/search/controllers/search_controller.dart' as search;
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/common/widgets/footer_view_widget.dart';
import 'package:stackfood_multivendor/common/widgets/product_view_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ItemViewWidget extends StatelessWidget {
  final bool isRestaurant;
  const ItemViewWidget({super.key, required this.isRestaurant});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<search.SearchController>(builder: (searchController) {
        return SingleChildScrollView(
          child: FooterViewWidget(
            child: Center(child: SizedBox(width: Dimensions.webMaxWidth, child: ProductViewWidget(
              isRestaurant: isRestaurant, products: searchController.searchProductList, restaurants: searchController.searchRestList,
            ))),
          ),
        );
      }),
    );
  }
}
