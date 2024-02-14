import 'package:stackfood_multivendor/features/order/controllers/order_controller.dart';
import 'package:stackfood_multivendor/features/order/domain/models/delivery_log_model.dart';
import 'package:stackfood_multivendor/helper/date_converter.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:stackfood_multivendor/common/widgets/paginated_list_view_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';

class LogDialog extends StatefulWidget {
  final int? subscriptionID;
  final bool isDelivery;
  const LogDialog({super.key, required this.subscriptionID, required this.isDelivery});

  @override
  State<LogDialog> createState() => _LogDialogState();
}

class _LogDialogState extends State<LogDialog> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    if(widget.isDelivery) {
      Get.find<OrderController>().getDeliveryLogs(widget.subscriptionID, 1);
    }else {
      Get.find<OrderController>().getPauseLogs(widget.subscriptionID, 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusDefault)),
      insetPadding: const EdgeInsets.all(30),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: PointerInterceptor(
        child: SizedBox(width: 500, child: Stack(children: [

          Padding(
            padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
            child: Column(mainAxisSize: MainAxisSize.min, children: [

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
                child: Text(
                  widget.isDelivery ? 'delivery_log'.tr : 'pause_log'.tr, textAlign: TextAlign.center,
                  style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeExtraLarge, color: Colors.red),
                ),
              ),
              const SizedBox(height: Dimensions.paddingSizeLarge),

              Expanded(child: GetBuilder<OrderController>(builder: (orderController) {
                bool notNull = widget.isDelivery ? orderController.deliveryLogs != null : orderController.pauseLogs != null;
                int? length;
                int? total;
                int? offset;
                if(notNull) {
                  length = widget.isDelivery ? orderController.deliveryLogs!.data!.length : orderController.pauseLogs!.data!.length;
                  total = widget.isDelivery ? orderController.deliveryLogs!.totalSize : orderController.pauseLogs!.totalSize;
                  offset = widget.isDelivery ? orderController.deliveryLogs!.offset : orderController.pauseLogs!.offset;
                }

                return notNull ? length! > 0 ? PaginatedListViewWidget(
                  scrollController: _scrollController,
                  onPaginate: (int? offset) {
                    if(widget.isDelivery) {
                      orderController.getDeliveryLogs(widget.subscriptionID, offset!);
                    }else {
                      orderController.getPauseLogs(widget.subscriptionID, offset!);
                    }
                  },
                  totalSize: total,
                  offset: offset,
                  productView: ListView.builder(
                    controller: _scrollController,
                    itemCount: length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      DeliveryLogModel logData = orderController.deliveryLogs!.data![index];

                      return Column(children: [

                        Row(children: [

                          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                            Row(children: [
                              Text('${index + 1})  ', style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),

                              widget.isDelivery ? Text(
                                DateConverter.dateTimeStringToDateTime(
                                    logData.orderStatus == 'pending' ? logData.scheduleAt! : logData.orderStatus == 'accepted' ? logData.accepted!
                                    : logData.orderStatus == 'confirmed' ? logData.confirmed! : logData.orderStatus == 'processing' ? logData.processing!
                                        : logData.orderStatus == 'handover' ? logData.handover!
                                    : logData.orderStatus == 'picked_up' ? logData.pickedUp! : logData.orderStatus == 'delivered' ? logData.delivered!
                                    : logData.orderStatus == 'canceled' ? logData.canceled! : logData.failed!
                                ),
                                style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
                              ) : Text(
                                '${DateConverter.stringDateTimeToDate(orderController.pauseLogs!.data![index].from!)} '
                                    '- ${DateConverter.stringDateTimeToDate(orderController.pauseLogs!.data![index].to!)}',
                                style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault),
                              ),
                            ]),

                          ])),
                          const SizedBox(width: Dimensions.paddingSizeSmall),

                          widget.isDelivery ? Container(
                            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeExtraSmall),
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                            ),
                            child: Text(
                              orderController.deliveryLogs!.data![index].orderStatus!.tr,
                              style: robotoRegular.copyWith(color: Theme.of(context).cardColor, fontSize: Dimensions.fontSizeExtraSmall),
                            ),
                          ) : const SizedBox(),

                        ]),

                        index != length!-1 ? Divider(
                          color: Theme.of(context).disabledColor, height: Dimensions.paddingSizeLarge,
                        ) : const SizedBox(),

                      ]);
                    },
                  ),
                ) : Center(child: Text('no_log_found'.tr)) : const Center(child: CircularProgressIndicator());
              })),

            ]),
          ),

          Positioned(top: 0, right: 0, child: IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(Icons.cancel),
          )),

        ])),
      ),
    );
  }
}
