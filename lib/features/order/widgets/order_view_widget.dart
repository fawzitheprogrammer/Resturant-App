import 'package:stackfood_multivendor/features/order/controllers/order_controller.dart';
import 'package:stackfood_multivendor/features/order/screens/order_details_screen.dart';
import 'package:stackfood_multivendor/features/order/widgets/order_shimmer_widget.dart';
import 'package:stackfood_multivendor/features/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor/features/order/domain/models/order_model.dart';
import 'package:stackfood_multivendor/helper/date_converter.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/helper/route_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/images.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:stackfood_multivendor/common/widgets/custom_image_widget.dart';
import 'package:stackfood_multivendor/common/widgets/footer_view_widget.dart';
import 'package:stackfood_multivendor/common/widgets/no_data_screen_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderViewWidget extends StatelessWidget {
  final bool isRunning;
  final bool isSubscription;
  const OrderViewWidget({super.key, required this.isRunning, this.isSubscription = false});

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: GetBuilder<OrderController>(builder: (orderController) {
        List<OrderModel>? orderList;
        bool paginate = false;
        int pageSize = 1;
        int offset = 1;
        if(orderController.runningOrderList != null && orderController.historyOrderList != null) {
          orderList = isSubscription ? orderController.runningSubscriptionOrderList : isRunning ? orderController.runningOrderList : orderController.historyOrderList;
          paginate = isSubscription ? orderController.runningSubscriptionPaginate : isRunning ? orderController.runningPaginate : orderController.historyPaginate;
          pageSize = isSubscription ? (orderController.runningSubscriptionPageSize!/100).ceil() : isRunning ? (orderController.runningPageSize!/100).ceil() : (orderController.historyPageSize!/100).ceil();
          offset = isSubscription ? orderController.runningSubscriptionOffset : isRunning ? orderController.runningOffset : orderController.historyOffset;
        }
        scrollController.addListener(() {
          if (scrollController.position.pixels == scrollController.position.maxScrollExtent && orderList != null && !paginate) {
            if (offset < pageSize) {
              Get.find<OrderController>().setOffset(offset + 1, isRunning, isSubscription);
              debugPrint('end of the page');
              Get.find<OrderController>().showBottomLoader(isRunning, isSubscription);
              if(isRunning) {
                Get.find<OrderController>().getRunningOrders(offset+1);
              } else if(isSubscription){
                Get.find<OrderController>().getRunningSubscriptionOrders(offset+1);
              }
              else {
                Get.find<OrderController>().getHistoryOrders(offset+1);
              }
            }
          }
        });

        return orderList != null ? orderList.isNotEmpty ? RefreshIndicator(
          onRefresh: () async {
            if(isRunning) {
              await orderController.getRunningOrders(1);
            }else {
              await orderController.getHistoryOrders(1);
            }
          },
          child: Scrollbar(controller: scrollController, child: SingleChildScrollView(
            controller: scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            child: Center(child: FooterViewWidget(
              child: SizedBox(
                width: Dimensions.webMaxWidth,
                child: Column(
                  children: [
                    GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisSpacing: ResponsiveHelper.isDesktop(context) ? Dimensions.paddingSizeOverLarge : Dimensions.paddingSizeLarge,
                        mainAxisSpacing: ResponsiveHelper.isDesktop(context) ? Dimensions.paddingSizeOverLarge : 0,
                        childAspectRatio: ResponsiveHelper.isDesktop(context) ? 5 : 4.5,
                        crossAxisCount: ResponsiveHelper.isMobile(context) ? 1 : 2,
                      ),
                      padding: ResponsiveHelper.isDesktop(context) ? const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeLarge) : const EdgeInsets.all(Dimensions.paddingSizeSmall),
                      itemCount: orderList.length,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {

                        return InkWell(
                          onTap: () {
                            Get.toNamed(
                              RouteHelper.getOrderDetailsRoute(orderList![index].id),
                              arguments: OrderDetailsScreen(orderId: orderList[index].id, orderModel: orderList[index]),
                            );
                          },
                          hoverColor: Colors.transparent,
                          child: Container(
                            padding: ResponsiveHelper.isDesktop(context) ? const EdgeInsets.all(Dimensions.paddingSizeSmall) : null,
                            margin: ResponsiveHelper.isDesktop(context) ? const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall) : null,
                            decoration: ResponsiveHelper.isDesktop(context) ? BoxDecoration(
                              color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                              boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5, spreadRadius: 1)],
                            ) : null,
                            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [

                              Row(children: [

                                ClipRRect(
                                  borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                                  child: CustomImageWidget(
                                    image: '${Get.find<SplashController>().configModel!.baseUrls!.restaurantImageUrl}'
                                        '/${orderList![index].restaurant != null ? orderList[index].restaurant!.logo : ''}',
                                    height: ResponsiveHelper.isDesktop(context) ? 80 : 60, width: ResponsiveHelper.isDesktop(context) ? 80 : 60, fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(width: Dimensions.paddingSizeSmall),

                                Expanded(
                                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                    Row(children: [
                                      Text('${'order_id'.tr}:', style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),
                                      const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                                      Text('#${orderList[index].id}', style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall)),
                                    ]),
                                    const SizedBox(height: Dimensions.paddingSizeSmall),

                                    ResponsiveHelper.isDesktop(context) ? Text(orderList[index].orderStatus!.tr, style: robotoMedium.copyWith(
                                      fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).primaryColor,
                                    )) : const SizedBox(),
                                    SizedBox(height: ResponsiveHelper.isDesktop(context) ? Dimensions.paddingSizeSmall : 0),

                                    Text(
                                      DateConverter.dateTimeStringToDateTime(orderList[index].createdAt!),
                                      style: robotoRegular.copyWith(color: Theme.of(context).disabledColor, fontSize: Dimensions.fontSizeSmall),
                                    ),
                                  ]),
                                ),
                                const SizedBox(width: Dimensions.paddingSizeSmall),

                                Row(crossAxisAlignment: CrossAxisAlignment.end, mainAxisAlignment: MainAxisAlignment.center, children: [

                                  ResponsiveHelper.isDesktop(context) ? Text(
                                    '${orderList[index].orderAmount!} ${Get.find<SplashController>().configModel!.currencySymbol}',
                                    style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
                                  ) : const SizedBox(),

                                  const SizedBox(width: Dimensions.paddingSizeSmall),
                                  isRunning || isSubscription ? Column(children: [

                                    !ResponsiveHelper.isDesktop(context) ? Container(
                                      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeExtraSmall),
                                      margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                                        color: Theme.of(context).primaryColor.withOpacity(0.1),
                                      ),
                                      child: Text(orderList[index].orderStatus!.tr, style: robotoMedium.copyWith(
                                        fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).primaryColor,
                                      )),
                                    ) : const SizedBox(),

                                    InkWell(
                                      onTap: () => Get.toNamed(RouteHelper.getOrderTrackingRoute(orderList![index].id, null)),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeExtraSmall),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                                          color: Theme.of(context).primaryColor,
                                          border: Border.all(width: 1, color: Theme.of(context).primaryColor),
                                        ),
                                        child: Row(children: [
                                          Text('track_order'.tr, style: robotoMedium.copyWith(
                                            fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).cardColor,
                                          )),
                                          const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                                          Image.asset(Images.tracking, height: 15, width: 15, color: Theme.of(context).cardColor),
                                        ]),
                                      ),
                                    ),
                                  ]) : Text(
                                    '${orderList[index].detailsCount} ${orderList[index].detailsCount! > 1 ? 'items'.tr : 'item'.tr}',
                                    style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall),
                                  ),
                                ]),

                              ]),

                              (index == orderList.length-1 || ResponsiveHelper.isDesktop(context)) ? const SizedBox() : Padding(
                                padding: const EdgeInsets.only(left: 70),
                                child: Divider(
                                  color: Theme.of(context).disabledColor, height: Dimensions.paddingSizeLarge,
                                ),
                              ),

                            ]),
                          ),
                        );
                      },
                    ),
                    paginate ? const Center(child: Padding(
                      padding: EdgeInsets.all(Dimensions.paddingSizeSmall),
                      child: CircularProgressIndicator(),
                    )) : const SizedBox(),
                  ],
                ),
              ),
            )),
          )),
        ) : SingleChildScrollView(child: FooterViewWidget(child: NoDataScreen(title: 'no_order_found'.tr))) : OrderShimmerWidget(orderController: orderController);
      }),
    );
  }
}
