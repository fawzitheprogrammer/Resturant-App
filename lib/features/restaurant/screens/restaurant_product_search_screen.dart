import 'package:stackfood_multivendor/features/restaurant/controllers/restaurant_controller.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:stackfood_multivendor/common/widgets/menu_drawer_widget.dart';
import 'package:stackfood_multivendor/common/widgets/paginated_list_view_widget.dart';
import 'package:stackfood_multivendor/common/widgets/product_view_widget.dart';
import 'package:stackfood_multivendor/common/widgets/veg_filter_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RestaurantProductSearchScreen extends StatefulWidget {
  final String? storeID;
  const RestaurantProductSearchScreen({super.key, required this.storeID});

  @override
  State<RestaurantProductSearchScreen> createState() => _RestaurantProductSearchScreenState();
}

class _RestaurantProductSearchScreenState extends State<RestaurantProductSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    Get.find<RestaurantController>().initSearchData();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RestaurantController>(builder: (restaurantController) {
      return Scaffold(
        appBar: PreferredSize(
            preferredSize: const Size(Dimensions.webMaxWidth, 60),
            child: Container(
              height: 60 + context.mediaQueryPadding.top, width: Dimensions.webMaxWidth,
              padding: EdgeInsets.only(top: context.mediaQueryPadding.top),
              color: Theme.of(context).cardColor,
              alignment: Alignment.center,
              child: SizedBox(width: Dimensions.webMaxWidth, child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical: Dimensions.paddingSizeSmall),
                child: Row(children: [

                  IconButton(
                    onPressed: () => Get.back(),
                    icon: Icon(Icons.arrow_back_ios, color: Theme.of(context).primaryColor),
                  ),

                  Expanded(child: TextField(
                    controller: _searchController,
                    style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeLarge),
                    textInputAction: TextInputAction.search,
                    cursorColor: Theme.of(context).primaryColor,
                    textAlignVertical: TextAlignVertical.center,
                    decoration: InputDecoration(
                      hintText: 'search_item_in_store'.tr,
                      hintStyle: robotoRegular.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).hintColor),
                      isDense: true,
                      contentPadding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                        borderSide: BorderSide(color: Theme.of(context).primaryColor.withOpacity(0.3), width: 1),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                        borderSide: BorderSide(color: Theme.of(context).primaryColor.withOpacity(0.3), width: 1),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.search, color: Theme.of(context).hintColor, size: 25),
                        onPressed: () => Get.find<RestaurantController>().getRestaurantSearchProductList(
                          _searchController.text.trim(), widget.storeID, 1, Get.find<RestaurantController>().searchType,
                        ),
                      ),
                    ),
                    onSubmitted: (text) => Get.find<RestaurantController>().getRestaurantSearchProductList(
                      _searchController.text.trim(), widget.storeID, 1, Get.find<RestaurantController>().searchType,
                    ),
                  )),

                  VegFilterWidget(
                    type: restaurantController.searchText.isNotEmpty ? restaurantController.searchType : null,
                    onSelected: (String type) {
                      restaurantController.getRestaurantSearchProductList(restaurantController.searchText, widget.storeID, 1, type);
                    },
                    fromAppBar: true,
                  ),

                ]),
              )),
            ),
          ),
        endDrawer: const MenuDrawerWidget(), endDrawerEnableOpenDragGesture: false,

        body: SingleChildScrollView(
            controller: _scrollController,
            padding: ResponsiveHelper.isDesktop(context) ? null : const EdgeInsets.all(Dimensions.paddingSizeSmall),
            child: Center(
              child: SizedBox(width: Dimensions.webMaxWidth, child: PaginatedListViewWidget(
                scrollController: _scrollController,
                onPaginate: (int? offset) => restaurantController.getRestaurantSearchProductList(
                  restaurantController.searchText, widget.storeID, offset!, restaurantController.searchType,
                ),
                totalSize: restaurantController.restaurantSearchProductModel?.totalSize,
                offset: restaurantController.restaurantSearchProductModel != null ? restaurantController.restaurantSearchProductModel!.offset : 1,
                productView: ProductViewWidget(
                  isRestaurant: false, restaurants: null,
                  products: restaurantController.restaurantSearchProductModel?.products,
                  inRestaurantPage: true,
                ),
              )),
            ),
          ),

        );
    });
  }
}
