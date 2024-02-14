import 'package:stackfood_multivendor/features/auth/controllers/auth_controller.dart';
import 'package:stackfood_multivendor/features/cart/controllers/cart_controller.dart';
import 'package:stackfood_multivendor/features/home/widgets/cuisine_card_widget.dart';
import 'package:stackfood_multivendor/features/search/controllers/search_controller.dart' as search;
import 'package:stackfood_multivendor/features/search/widgets/filter_widget.dart';
import 'package:stackfood_multivendor/common/widgets/search_field_widget.dart';
import 'package:stackfood_multivendor/features/search/widgets/search_result_widget.dart';
import 'package:stackfood_multivendor/features/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor/features/cuisine/controllers/cuisine_controller.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/helper/route_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:stackfood_multivendor/common/widgets/bottom_cart_widget.dart';
import 'package:stackfood_multivendor/common/widgets/custom_snackbar_widget.dart';
import 'package:stackfood_multivendor/common/widgets/footer_view_widget.dart';
import 'package:stackfood_multivendor/common/widgets/menu_drawer_widget.dart';
import 'package:stackfood_multivendor/common/widgets/product_bottom_sheet_widget.dart';
import 'package:stackfood_multivendor/common/widgets/web_menu_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  SearchScreenState createState() => SearchScreenState();
}

class SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  late bool _isLoggedIn;

  @override
  void initState() {
    super.initState();

    _isLoggedIn = Get.find<AuthController>().isLoggedIn();
    Get.find<search.SearchController>().setSearchMode(true, canUpdate: false);
    if(_isLoggedIn) {
      Get.find<search.SearchController>().getSuggestedFoods();
    }
    Get.find<CuisineController>().getCuisineList();
    Get.find<search.SearchController>().getHistoryList();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: Navigator.canPop(context),
      onPopInvoked: (val) async {
        if(Get.find<search.SearchController>().isSearchMode) {
        }else {
          Get.find<search.SearchController>().setSearchMode(true);
        }
      },
      child: Scaffold(
        appBar: ResponsiveHelper.isDesktop(context) ? const WebMenuBar() : null,
        endDrawer: const MenuDrawerWidget(), endDrawerEnableOpenDragGesture: false,
        body: SafeArea(child: GetBuilder<search.SearchController>(builder: (searchController) {
          _searchController.text = searchController.searchText;
          return Column(children: [

            Container(
              height: ResponsiveHelper.isDesktop(context) ? 130 : 80,
              color: ResponsiveHelper.isDesktop(context) ? Theme.of(context).primaryColor.withOpacity(0.1) : Colors.transparent,
              child: Center(child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ResponsiveHelper.isDesktop(context) ? Text('search_food_and_restaurant'.tr, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge)) : const SizedBox(),

                  SizedBox(width: Dimensions.webMaxWidth, child: Row(children: [
                    SizedBox(width: ResponsiveHelper.isMobile(context) ? 0 : Dimensions.paddingSizeExtraSmall),

                    ResponsiveHelper.isDesktop(context) ? const SizedBox() : IconButton(onPressed: () => searchController.isSearchMode ? Get.back() : searchController.setSearchMode(true),
                        icon: const Icon(Icons.arrow_back_ios)),

                    Expanded(child: SearchFieldWidget(
                      controller: _searchController,
                      hint: 'search_food_or_restaurant'.tr,
                      suffixIcon: !searchController.isSearchMode ? Icons.filter_list : Icons.search,
                      iconPressed: () => _actionSearch(searchController, false),
                      onSubmit: (text) => _actionSearch(searchController, true),
                    )),
                    SizedBox(width: ResponsiveHelper.isMobile(context) ? Dimensions.paddingSizeSmall : 0),
                  ])),
                ],
              )),
            ),

            Expanded(child: searchController.isSearchMode ? SingleChildScrollView(
              controller: scrollController,
              physics: const BouncingScrollPhysics(),
              padding: ResponsiveHelper.isDesktop(context) ? EdgeInsets.zero : const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
              child: FooterViewWidget(
                child: SizedBox(width: Dimensions.webMaxWidth, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                  const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                  searchController.historyList.isNotEmpty ? Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Text('recent_search'.tr, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge)),

                    InkWell(
                      onTap: () => searchController.clearSearchAddress(),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall, horizontal: 4),
                        child: Text('clear_all'.tr, style: robotoRegular.copyWith(
                          fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).colorScheme.error,
                        )),
                      ),
                    ),
                  ]) : const SizedBox(),

                  const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                  Wrap(
                    children: searchController.historyList.map((address) {
                      return Padding(
                        padding: const EdgeInsets.only(right: Dimensions.paddingSizeSmall, bottom: Dimensions.paddingSizeSmall),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                          decoration: BoxDecoration(
                            color: Theme.of(context).disabledColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                            border: Border.all(color: Theme.of(context).disabledColor.withOpacity(0.6)),
                          ),
                          child: Row(mainAxisSize: MainAxisSize.min, children: [
                            InkWell(
                              onTap: () => searchController.searchData(address),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall),
                                child: Text(
                                  address,
                                  style: robotoRegular.copyWith(color: Theme.of(context).textTheme.bodyMedium!.color!.withOpacity(0.5)),
                                  maxLines: 1, overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            const SizedBox(width: Dimensions.paddingSizeSmall),

                            InkWell(
                              onTap: () => searchController.removeHistory(searchController.historyList.indexOf(address)),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall),
                                child: Icon(Icons.close, color: Theme.of(context).disabledColor, size: 20),
                              ),
                            )
                          ]),
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: Dimensions.paddingSizeLarge),

                  (_isLoggedIn && searchController.suggestedFoodList != null) ? Text(
                    'recommended'.tr, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge),
                  ) : const SizedBox(),
                  const SizedBox(height: Dimensions.paddingSizeDefault),

                  (_isLoggedIn && searchController.suggestedFoodList != null) ? searchController.suggestedFoodList!.isNotEmpty ?  Wrap(
                    children: searchController.suggestedFoodList!.map((product) {
                      return Padding(
                        padding: const EdgeInsets.only(right: Dimensions.paddingSizeSmall, bottom: Dimensions.paddingSizeSmall),
                        child: InkWell(
                          onTap: () {
                            ResponsiveHelper.isMobile(context) ? Get.bottomSheet(
                              ProductBottomSheetWidget(product: product),
                              backgroundColor: Colors.transparent, isScrollControlled: true,
                            ) : Get.dialog(
                              Dialog(child: ProductBottomSheetWidget(product: product)),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeSmall),
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                              border: Border.all(color: Theme.of(context).disabledColor.withOpacity(0.6)),
                            ),
                            child: Text(
                              product.name!,
                              style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
                              maxLines: 1, overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ) : Padding(padding: const EdgeInsets.only(top: 10), child: Text('no_suggestions_available'.tr)) : const SizedBox(),



                  const SizedBox(height: Dimensions.paddingSizeLarge),

                  GetBuilder<CuisineController>(builder: (cuisineController) {
                    return (cuisineController.cuisineModel != null && cuisineController.cuisineModel!.cuisines!.isEmpty) ? const SizedBox() : Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        (cuisineController.cuisineModel != null) ? Text(
                          'cuisines'.tr, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge),
                        ) : const SizedBox(),
                        const SizedBox(height: Dimensions.paddingSizeDefault),


                        (cuisineController.cuisineModel != null) ? cuisineController.cuisineModel!.cuisines!.isNotEmpty ? GetBuilder<CuisineController>(
                            builder: (cuisineController) {
                              return cuisineController.cuisineModel != null ? GridView.builder(
                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: ResponsiveHelper.isDesktop(context) ? 8 : ResponsiveHelper.isTab(context) ? 6 : 4,
                                    mainAxisSpacing: 20,
                                    crossAxisSpacing: ResponsiveHelper.isDesktop(context) ? 35 : 15,
                                    childAspectRatio: ResponsiveHelper.isDesktop(context) ? 1 : 0.9,
                                  ),
                                  shrinkWrap: true,
                                  itemCount: cuisineController.cuisineModel!.cuisines!.length,
                                  scrollDirection: Axis.vertical,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index){
                                    return InkWell(
                                      onTap: (){
                                        Get.toNamed(RouteHelper.getCuisineRestaurantRoute(cuisineController.cuisineModel!.cuisines![index].id, cuisineController.cuisineModel!.cuisines![index].name));
                                      },
                                      child: SizedBox(
                                        height: 130,
                                        child: CuisineCardWidget(
                                          image: '${Get.find<SplashController>().configModel!.baseUrls!.cuisineImageUrl}/${cuisineController.cuisineModel!.cuisines![index].image}',
                                          name: cuisineController.cuisineModel!.cuisines![index].name!,
                                        ),
                                      ),
                                    );
                                  }) : const Center(child: CircularProgressIndicator());
                            }
                        ) : Padding(padding: const EdgeInsets.only(top: 10), child: Text('no_suggestions_available'.tr)) : const SizedBox(),
                      ],
                    );
                  }
                  ),


                ])),
              ),
            ) : SearchResultWidget(searchText: _searchController.text.trim())),




          ]);
        })),
        bottomNavigationBar: GetBuilder<CartController>(builder: (cartController) {
          return cartController.cartList.isNotEmpty && !ResponsiveHelper.isDesktop(context) ? const BottomCartWidget() : const SizedBox();
        }),
      ),
    );
  }

  void _actionSearch(search.SearchController searchController, bool isSubmit) {
    if(searchController.isSearchMode || isSubmit) {
      if(_searchController.text.trim().isNotEmpty) {
        searchController.searchData(_searchController.text.trim());
      }else {
        showCustomSnackBar('search_food_or_restaurant'.tr);
      }
    }else {
      List<double?> prices = [];
      if(!searchController.isRestaurant) {
        for (var product in searchController.allProductList!) {
          prices.add(product.price);
        }
        prices.sort();
      }
      double? maxValue = prices.isNotEmpty ? prices[prices.length-1] : 1000;
      ResponsiveHelper.isMobile(context) ? Get.bottomSheet(FilterWidget(maxValue: maxValue, isRestaurant: searchController.isRestaurant), isScrollControlled: true)
      : Get.dialog(Dialog(
        insetPadding: const EdgeInsets.all(30),
        child: FilterWidget(maxValue: maxValue, isRestaurant: searchController.isRestaurant),
      ));
    }
  }
}
