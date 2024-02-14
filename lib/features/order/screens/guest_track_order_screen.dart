import 'package:stackfood_multivendor/features/order/controllers/order_controller.dart';
import 'package:stackfood_multivendor/features/order/domain/models/order_model.dart';
import 'package:stackfood_multivendor/features/order/widgets/guest_custom_stepper.dart';
import 'package:stackfood_multivendor/features/order/widgets/traking_map_widget.dart';
import 'package:stackfood_multivendor/helper/date_converter.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/helper/route_helper.dart';
import 'package:stackfood_multivendor/util/app_constants.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/images.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:stackfood_multivendor/common/widgets/custom_app_bar_widget.dart';
import 'package:stackfood_multivendor/common/widgets/custom_button_widget.dart';
import 'package:stackfood_multivendor/common/widgets/custom_snackbar_widget.dart';
import 'package:stackfood_multivendor/common/widgets/footer_view_widget.dart';
import 'package:stackfood_multivendor/common/widgets/menu_drawer_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher_string.dart';
class GuestTrackOrderScreen extends StatefulWidget {
  final String orderId;
  final String number;
  const GuestTrackOrderScreen({super.key, required this.orderId, required this.number});

  @override
  State<GuestTrackOrderScreen> createState() => _GuestTrackOrderScreenState();
}

class _GuestTrackOrderScreenState extends State<GuestTrackOrderScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    Get.find<OrderController>().trackOrder(widget.orderId, null, false, contactNumber: widget.number, fromGuestInput: true);
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.sizeOf(context).width;
    bool isDesktop = ResponsiveHelper.isDesktop(context);
    return Scaffold(
      appBar: CustomAppBarWidget(title: 'track_order'.tr),
      endDrawer: const MenuDrawerWidget(), endDrawerEnableOpenDragGesture: false,
      body:  Column(children: [
        Expanded(child: GetBuilder<OrderController>(builder: (orderController) {
          String? status;
          if(orderController.trackModel != null) {
            status = orderController.trackModel?.orderStatus;
          }
          OrderModel? order = orderController.trackModel;
          return SingleChildScrollView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            child: FooterViewWidget(
              child: Container(
                margin: isDesktop ? EdgeInsets.symmetric(horizontal: (width - 1170) / 2, vertical: 50) : null,
                decoration: isDesktop ? BoxDecoration(
                  color: Theme.of(context).canvasColor, borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 5, spreadRadius: 1)],
                ) : null,
                child: SingleChildScrollView(
                  physics: isDesktop ? const NeverScrollableScrollPhysics() : const BouncingScrollPhysics(),
                  child: Column(children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                      child: orderController.trackModel != null ? Column(children: [
                        const SizedBox(height: Dimensions.paddingSizeLarge),

                        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                          Text('your_order'.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeExtraLarge)),

                          Text(' #${orderController.trackModel?.id}', style: robotoMedium.copyWith(
                            fontSize: Dimensions.fontSizeExtraLarge, color: Theme.of(context).primaryColor,
                          )),
                        ]),
                        const SizedBox(height: Dimensions.paddingSizeLarge),

                        Column(children: [
                          GuestCustomStepper(
                            title: 'order_placed'.tr,
                            isComplete: status == AppConstants.pending
                                || status == AppConstants.confirmed
                                || status == AppConstants.processing
                                || status == AppConstants.pickedUp
                                || status == AppConstants.handover
                                || status == AppConstants.delivered
                                || status == AppConstants.accepted
                                || status == AppConstants.refundRequested,
                            isActive: status == AppConstants.pending,
                            haveTopBar: false,
                            statusImage: Images.trackOrderPlace,
                            subTitle: DateConverter.dateTimeStringToDateTime(order!.scheduleAt!),
                          ),

                          GuestCustomStepper(
                            title: 'order_confirmed'.tr,
                            isComplete: status == AppConstants.confirmed
                                || status == AppConstants.processing
                                || status == AppConstants.pickedUp
                                || status == AppConstants.handover
                                || status == AppConstants.delivered
                                || status == AppConstants.accepted
                                || status == AppConstants.refundRequested,
                            isActive: status == AppConstants.confirmed || status == AppConstants.accepted,
                            statusImage: Images.trackOrderAccept,
                          ),

                          GuestCustomStepper(
                            title: 'preparing_food'.tr,
                            isComplete: status == AppConstants.processing
                                || status == AppConstants.pickedUp
                                || status == AppConstants.handover
                                ||status == AppConstants.delivered
                                || status == AppConstants.refundRequested,
                            isActive: status == AppConstants.processing,
                            statusImage: Images.trackOrderPreparing,
                          ),

                          GuestCustomStepper(
                            title: 'order_is_on_the_way'.tr,
                            isComplete: status == AppConstants.handover
                                || status == AppConstants.pickedUp
                                || status == AppConstants.delivered
                                || status == AppConstants.refundRequested,
                            statusImage: Images.trackOrderOnTheWay,
                            isActive: status == AppConstants.handover,
                            subTitle: 'your_delivery_man_is_coming'.tr,
                            trailing: (orderController.trackModel?.deliveryMan?.phone != null && status != AppConstants.delivered && status != AppConstants.refundRequested)
                                ? InkWell(
                              onTap: () async {

                                if(await canLaunchUrlString('tel:${orderController.trackModel?.deliveryMan?.phone}')) {
                                  launchUrlString('tel:${orderController.trackModel?.deliveryMan?.phone}');
                                }else {
                                  showCustomSnackBar('${'can_not_launch'.tr} ${orderController.trackModel?.deliveryMan?.phone}');
                                }

                              },
                              child: const Icon(Icons.phone_in_talk),
                            ) : const SizedBox(),
                          ),

                          GuestCustomStepper(
                            title: 'order_delivered'.tr,
                            isComplete: status == AppConstants.delivered
                                || status == AppConstants.refundRequested,
                            isActive: status == AppConstants.delivered,
                            statusImage: Images.trackOrderDelivered,
                            child: (orderController.trackModel?.deliveryMan != null && status != AppConstants.delivered && status != AppConstants.refundRequested)
                                ? TrackingMapWidget(
                              track: orderController.trackModel,
                            ) : const SizedBox(),
                          ),

                        ]),
                      ]) : const Center(child: Padding(
                        padding: EdgeInsets.only(top: 200.0, bottom: 200),
                        child: CircularProgressIndicator(),
                      )),
                    ),

                    // const SizedBox(height: 50),

                    isDesktop ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeExtraLarge),
                      child: CustomButtonWidget(
                        buttonText: 'view_details'.tr,
                        width: 300,
                        onPressed: () {
                          Get.toNamed(RouteHelper.getOrderDetailsRoute(int.parse(widget.orderId), contactNumber: widget.number));
                        },
                      ),
                    ) : const SizedBox(),

                  ]),
                ),
              ),
            ),
          );
        })),

        !isDesktop ? SafeArea(child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeSmall),
          child: CustomButtonWidget(
            buttonText: 'view_details'.tr,
            onPressed: () {
              Get.toNamed(RouteHelper.getOrderDetailsRoute(int.parse(widget.orderId), contactNumber: widget.number, fromGuestTrack: true));
            },
          ),
        )) : const SizedBox(),
      ]),
    );
  }
}
