import 'package:stackfood_multivendor/common/models/review_model.dart';
import 'package:stackfood_multivendor/common/widgets/rating_bar_widget.dart';
import 'package:stackfood_multivendor/features/auth/controllers/auth_controller.dart';
import 'package:stackfood_multivendor/features/checkout/widgets/offline_info_edit_dialog.dart';
import 'package:stackfood_multivendor/features/notification/domain/models/notification_body_model.dart';
import 'package:stackfood_multivendor/features/order/controllers/order_controller.dart';
import 'package:stackfood_multivendor/features/order/widgets/delivery_details.dart';
import 'package:stackfood_multivendor/features/order/widgets/log_dialog.dart';
import 'package:stackfood_multivendor/features/order/widgets/order_product_widget.dart';
import 'package:stackfood_multivendor/features/review/widgets/review_dialog_widget.dart';
import 'package:stackfood_multivendor/features/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor/features/order/domain/models/order_model.dart';
import 'package:stackfood_multivendor/features/chat/domain/models/conversation_model.dart';
import 'package:stackfood_multivendor/features/chat/widgets/image_dialog_widget.dart';
import 'package:stackfood_multivendor/helper/date_converter.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/helper/route_helper.dart';
import 'package:stackfood_multivendor/util/app_constants.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/images.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:stackfood_multivendor/common/widgets/custom_button_widget.dart';
import 'package:stackfood_multivendor/common/widgets/custom_image_widget.dart';
import 'package:stackfood_multivendor/common/widgets/custom_snackbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import 'package:url_launcher/url_launcher_string.dart';
class OrderInfoSection extends StatelessWidget {
  final OrderModel order;
  final OrderController orderController;
  final List<String> schedules;
  final bool showChatPermission;
  final String? contactNumber;
  const OrderInfoSection({super.key, required this.order, required this.orderController, required this.schedules, required this.showChatPermission, this.contactNumber});

  @override
  Widget build(BuildContext context) {
    ExpansionTileController expansionTileController = ExpansionTileController();
    bool subscription = order.subscription != null;

    bool pending = order.orderStatus == AppConstants.pending;
    bool accepted = order.orderStatus == AppConstants.accepted;
    bool confirmed = order.orderStatus == AppConstants.confirmed;
    bool processing = order.orderStatus == AppConstants.processing;
    bool pickedUp = order.orderStatus == AppConstants.pickedUp;
    bool delivered = order.orderStatus == AppConstants.delivered;
    bool cancelled = order.orderStatus == AppConstants.cancelled;
    bool takeAway = order.orderType == 'take_away';
    bool cod = order.paymentMethod == 'cash_on_delivery';
    bool isDesktop = ResponsiveHelper.isDesktop(context);
    bool isGuestLoggedIn = Get.find<AuthController>().isGuestLoggedIn();

    bool ongoing = (order.orderStatus != 'delivered' && order.orderStatus != 'failed'
        && order.orderStatus != 'refund_requested' && order.orderStatus != 'refunded'
        && order.orderStatus != 'refund_request_canceled' && order.orderStatus != 'canceled');

    bool pastOrder = (order.orderStatus == 'delivered' || order.orderStatus == 'failed'
        || order.orderStatus == 'refund_requested' || order.orderStatus == 'refunded'
        || order.orderStatus == 'refund_request_canceled' ||order.orderStatus == 'canceled');

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

      Container(
        decoration: isDesktop ? BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(isDesktop ? Dimensions.radiusDefault : 0),
          boxShadow: [BoxShadow(color: isDesktop ? Colors.black.withOpacity(0.05) : Theme.of(context).primaryColor.withOpacity(0.05), blurRadius: 10)],
        ) : null,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          DateConverter.isBeforeTime(order.scheduleAt) ? (!cancelled && ongoing && !subscription) ? Column(children: [

            ClipRRect(borderRadius: BorderRadius.circular(10), child: Image.asset(order.orderStatus == 'pending' ? Images.pendingOrderDetails : (order.orderStatus == 'confirmed' || order.orderStatus == 'processing' || order.orderStatus == 'handover')
                ? Images.preparingFoodOrderDetails : Images.animateDeliveryMan, fit: BoxFit.contain, height: 180)),
            const SizedBox(height: Dimensions.paddingSizeDefault),

            Text('your_food_will_delivered_within'.tr, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).disabledColor)),
            const SizedBox(height: Dimensions.paddingSizeExtraSmall),

            Center(
              child: Row(mainAxisSize: MainAxisSize.min, children: [

                Text(
                  DateConverter.differenceInMinute(order.restaurant!.deliveryTime, order.createdAt, order.processingTime, order.scheduleAt) < 5 ? '1 - 5'
                      : '${DateConverter.differenceInMinute(order.restaurant!.deliveryTime, order.createdAt, order.processingTime, order.scheduleAt)-5} '
                      '- ${DateConverter.differenceInMinute(order.restaurant!.deliveryTime, order.createdAt, order.processingTime, order.scheduleAt)}',
                  style: robotoBold.copyWith(fontSize: Dimensions.fontSizeExtraLarge), textDirection: TextDirection.ltr,
                ),
                const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                Text('min'.tr, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).primaryColor)),
              ]),
            ),
            const SizedBox(height: Dimensions.paddingSizeExtraLarge),

          ]) : const SizedBox() : const SizedBox(),

          (pastOrder) ? CustomImageWidget(image: '${Get.find<SplashController>().configModel!.baseUrls!.restaurantCoverPhotoUrl}/${order.restaurant!.coverPhoto}', height: 160, width: double.infinity)
              : const SizedBox(),

          isDesktop ? Padding(
            padding: const EdgeInsets.only(left: Dimensions.paddingSizeExtraSmall),
            child: Text('general_info'.tr, style: robotoMedium),
          ) : const SizedBox(),
          SizedBox(height: isDesktop ? Dimensions.paddingSizeLarge : 0),

          Container(
            decoration: !isDesktop ? BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(isDesktop ? Dimensions.radiusDefault : 0),
              boxShadow: [BoxShadow(color: Theme.of(context).primaryColor.withOpacity(0.05), blurRadius: 10)],
            ) : null,
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical: Dimensions.paddingSizeSmall),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

              !isDesktop ? Text('general_info'.tr, style: robotoMedium) : const SizedBox(),
              SizedBox(height: !isDesktop ? Dimensions.paddingSizeLarge : 0),

              Row(children: [
                Text('${subscription ? 'subscription_id'.tr : 'order_id'.tr}:', style: robotoRegular),
                const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                Text(order.id.toString(), style: robotoMedium),
                const Expanded(child: SizedBox()),

                const Icon(Icons.watch_later, size: 17),
                const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                Text(
                  DateConverter.dateTimeStringToDateTime(order.createdAt!),
                  style: robotoRegular,
                ),
              ]),
              const Divider(height: Dimensions.paddingSizeLarge),

              order.scheduled == 1 ? Row(children: [
                Text('${'scheduled_at'.tr}:', style: robotoRegular),
                const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                Text(DateConverter.dateTimeStringToDateTime(order.scheduleAt!), style: robotoMedium),
              ]) : const SizedBox(),
              order.scheduled == 1 ? const Divider(height: Dimensions.paddingSizeLarge) : const SizedBox(),

              Get.find<SplashController>().configModel!.orderDeliveryVerification! ? Row(children: [
                Text('${'delivery_verification_code'.tr}:', style: robotoRegular),
                const Expanded(child: SizedBox()),
                Text(order.otp!, style: robotoMedium),
              ]) : const SizedBox(),
              Get.find<SplashController>().configModel!.orderDeliveryVerification! ?const Divider(height: Dimensions.paddingSizeLarge) : const SizedBox(),

              Row(children: [
                Text(order.orderType!.tr, style: robotoMedium),
                const Expanded(child: SizedBox()),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeExtraSmall),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.05), borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                  ),
                  child: Text(
                    cod ? 'cash_on_delivery'.tr
                        : order.paymentMethod == 'wallet' ? 'wallet_payment'.tr
                        : order.paymentMethod == 'partial_payment' ? 'partial_payment'.tr
                        : order.paymentMethod == 'offline_payment' ? 'offline_payment'.tr : 'digital_payment'.tr,
                    style: robotoMedium.copyWith(color: Theme.of(context).primaryColor, fontSize: Dimensions.fontSizeExtraSmall),
                  ),
                ),
              ]),
              const Divider(height: Dimensions.paddingSizeLarge),

              subscription ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                Row(children: [
                  Text('${'subscription_date'.tr}:', style: robotoRegular),
                  const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                  Text(
                    '${DateConverter.stringDateTimeToDate(order.subscription!.startAt!)} '
                        '- ${DateConverter.stringDateTimeToDate(order.subscription!.endAt!)}',
                    style: robotoMedium,
                  ),
                ]),
                const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                Row(children: [
                  Text('${'subscription_type'.tr}:', style: robotoRegular),
                  const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                  Text(
                    order.subscription!.type!.tr,
                    style: robotoMedium,
                  ),
                ]),
                const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                Text('${'subscription_schedule'.tr}:', style: robotoRegular),
                const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                SizedBox(height: 30, child: ListView.builder(
                  itemCount: schedules.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                      margin: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                        border: Border.all(color: Theme.of(context).disabledColor, width: 1),
                      ),
                      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                        Text(
                          schedules[index],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: robotoRegular,
                        ),
                      ]),
                    );
                  },
                )),
                const SizedBox(height: Dimensions.paddingSizeSmall),

                Row(children: [
                  Expanded(child: CustomButtonWidget(
                    buttonText: 'delivery_log'.tr,
                    height: 35,
                    onPressed: () => Get.dialog(LogDialog(subscriptionID: order.subscriptionId, isDelivery: true)),
                  )),
                  const SizedBox(width: Dimensions.paddingSizeSmall),
                  Expanded(child: CustomButtonWidget(
                    buttonText: 'pause_log'.tr,
                    height: 35,
                    onPressed: () => Get.dialog(LogDialog(subscriptionID: order.subscriptionId, isDelivery: false)),
                  )),
                ]),

                const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                const Divider(height: Dimensions.paddingSizeLarge),
              ]) : const SizedBox(),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall),
                child: Row(children: [
                  Text('${'item'.tr}:', style: robotoRegular),
                  const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                  Text(
                    orderController.orderDetails!.length.toString(),
                    style: robotoMedium.copyWith(color: Theme.of(context).primaryColor),
                  ),
                  const Expanded(child: SizedBox()),
                  Container(height: 7, width: 7, decoration: BoxDecoration(
                    color: (subscription ? order.subscription!.status == 'canceled' : (order.orderStatus == 'failed' || cancelled || order.orderStatus == 'refund_request_canceled'))
                        ? Colors.red : order.orderStatus == 'refund_requested' ? Colors.yellow : Colors.green ,
                    shape: BoxShape.circle,
                  )),
                  const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                  Text(
                    delivered ? '${'delivered_at'.tr} ${DateConverter.dateTimeStringToDateTime(order.delivered!)}'
                        : subscription ? order.subscription!.status!.tr : order.orderStatus!.tr,
                    style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
                  ),
                ]),
              ),
              // const Divider(height: Dimensions.paddingSizeLarge),

              Column(children: [
                const Divider(height: Dimensions.paddingSizeLarge),

                Row(children: [
                  Text('${'cutlery'.tr}: ', style: robotoRegular),
                  const Expanded(child: SizedBox()),

                  Text(
                    order.cutlery! ? 'yes'.tr : 'no'.tr,
                    style: robotoRegular,
                  ),
                ]),
              ]),

              order.unavailableItemNote != null ? Column(
                children: [
                  const Divider(height: Dimensions.paddingSizeLarge),
                  Row(children: [
                    Text('${'if_item_is_not_available'.tr}: ', style: robotoMedium),

                    Text(
                      order.unavailableItemNote!.tr,
                      style: robotoRegular,
                    ),
                  ]),
                ],
              ) : const SizedBox(),

              order.deliveryInstruction != null ? Column(children: [
                const Divider(height: Dimensions.paddingSizeLarge),

                Row(children: [
                  Text('${'delivery_instruction'.tr}: ', style: robotoMedium),

                  Text(
                    order.deliveryInstruction!.tr,
                    style: robotoRegular,
                  ),
                ]),
              ]) : const SizedBox(),
              SizedBox(height: order.deliveryInstruction != null ? Dimensions.paddingSizeSmall : 0),

              cancelled ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Divider(height: Dimensions.paddingSizeLarge),
                Text('${'cancellation_reason'.tr}:', style: robotoMedium),
                const SizedBox(height: Dimensions.paddingSizeSmall),

                InkWell(
                  onTap: () => Get.dialog(ReviewDialogWidget(review: ReviewModel(comment: order.cancellationReason), fromOrderDetails: true)),
                  child: Text(
                    order.cancellationReason ?? '', maxLines: 2, overflow: TextOverflow.ellipsis,
                    style: robotoRegular.copyWith(color: Theme.of(context).disabledColor),
                  ),
                ),

              ]) : const SizedBox(),

              cancelled && order.cancellationNote != null && order.cancellationNote != '' ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Divider(height: Dimensions.paddingSizeLarge),

                Text('${'cancellation_note'.tr}:', style: robotoMedium),
                const SizedBox(height: Dimensions.paddingSizeSmall),

                InkWell(
                  onTap: () => Get.dialog(ReviewDialogWidget(review: ReviewModel(comment: order.cancellationNote), fromOrderDetails: true)),
                  child: Text(
                    order.cancellationNote ?? '', maxLines: 2, overflow: TextOverflow.ellipsis,
                    style: robotoRegular.copyWith(color: Theme.of(context).disabledColor),
                  ),
                ),

              ]) : const SizedBox(),

              (order.orderStatus == 'refund_requested' || order.orderStatus == 'refund_request_canceled') ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                const Divider(height: Dimensions.paddingSizeLarge),
                order.orderStatus == 'refund_requested' ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                  RichText(text: TextSpan(children: [
                    TextSpan(text: '${'refund_note'.tr}:', style: robotoMedium.copyWith(color: Theme.of(context).textTheme.bodyLarge!.color)),
                    TextSpan(text: '(${(order.refund != null) ? order.refund!.customerReason : ''})', style: robotoRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge!.color)),
                  ])),
                  const SizedBox(height: Dimensions.paddingSizeSmall),

                  (order.refund != null && order.refund!.customerNote != null) ? InkWell(
                    onTap: () => Get.dialog(ReviewDialogWidget(review: ReviewModel(comment: order.refund!.customerNote), fromOrderDetails: true)),
                    child: Text(
                      '${order.refund!.customerNote}', maxLines: 2, overflow: TextOverflow.ellipsis,
                      style: robotoRegular.copyWith(color: Theme.of(context).disabledColor),
                    ),
                  ) : const SizedBox(),
                  SizedBox(height: (order.refund != null && order.refund!.image != null) ? Dimensions.paddingSizeSmall : 0),

                  (order.refund != null && order.refund!.image != null && order.refund!.image!.isNotEmpty) ? InkWell(
                    onTap: () => showDialog(context: context, builder: (context) {
                      return ImageDialogWidget(imageUrl: '${Get.find<SplashController>().configModel!.baseUrls!.refundImageUrl}/${order.refund!.image!.isNotEmpty ? order.refund!.image![0] : ''}');
                    }),
                    child: CustomImageWidget(
                      height: 40, width: 40, fit: BoxFit.cover,
                      image: order.refund != null ? '${Get.find<SplashController>().configModel!.baseUrls!.refundImageUrl}/${order.refund!.image!.isNotEmpty ? order.refund!.image![0] : ''}' : '',
                    ),
                  ) : const SizedBox(),
                ]) : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Divider(height: Dimensions.paddingSizeLarge),

                  Text('${'refund_cancellation_note'.tr}:', style: robotoMedium),
                  const SizedBox(height: Dimensions.paddingSizeSmall),

                  InkWell(
                    onTap: () => Get.dialog(ReviewDialogWidget(review: ReviewModel(comment: order.refund!.adminNote), fromOrderDetails: true)),
                    child: Text(
                      '${order.refund != null ? order.refund!.adminNote : ''}', maxLines: 2, overflow: TextOverflow.ellipsis,
                      style: robotoRegular.copyWith(color: Theme.of(context).disabledColor),
                    ),
                  ),

                ]),
              ]) : const SizedBox(),

              (order.orderNote  != null && order.orderNote!.isNotEmpty) ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Divider(height: Dimensions.paddingSizeLarge),

                Text('additional_note'.tr, style: robotoRegular),
                const SizedBox(height: Dimensions.paddingSizeSmall),

                Container(
                  width: Dimensions.webMaxWidth,
                  padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                    border: Border.all(width: 1, color: Theme.of(context).disabledColor),
                  ),
                  child: Text(
                    order.orderNote!,
                    style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
                  ),
                ),
                const SizedBox(height: Dimensions.paddingSizeLarge),
              ]) : const SizedBox(),

              (order.orderStatus == 'delivered' && order.orderProof != null && order.orderProof!.isNotEmpty) ? Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  boxShadow: [BoxShadow(color: Theme.of(context).primaryColor.withOpacity(0.05), blurRadius: 10)],
                ),
                margin: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('order_proof'.tr, style: robotoRegular),
                  const SizedBox(height: Dimensions.paddingSizeSmall),

                  GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: 1.5,
                      crossAxisCount: ResponsiveHelper.isTab(context) ? 5 : 3,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 5,
                    ),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: order.orderProof!.length,
                    itemBuilder: (BuildContext context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: InkWell(
                          onTap: () => openDialog(context, '${Get.find<SplashController>().configModel!.baseUrls!.orderAttachmentUrl}/${order.orderProof![index]}'),
                          child: Center(child: ClipRRect(
                            borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                            child: CustomImageWidget(
                              image: '${Get.find<SplashController>().configModel!.baseUrls!.orderAttachmentUrl}/${order.orderProof![index]}',
                              width: 100, height: 100,
                            ),
                          )),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: Dimensions.paddingSizeLarge),
                ]),
              ) : const SizedBox(),
            ]),
          ),
        ]),
      ),


      !ResponsiveHelper.isDesktop(context) ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical: Dimensions.paddingSizeSmall),
          child: Text('item_info'.tr, style: robotoMedium),
        ),
        const SizedBox(height: Dimensions.paddingSizeSmall),

        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: orderController.orderDetails!.length,
          itemBuilder: (context, index) {
            return OrderProductWidget(order: order, orderDetails: orderController.orderDetails![index]);
          },
        ),
      ]) : const SizedBox(),
      const SizedBox(height: Dimensions.paddingSizeSmall),

      isDesktop ? Padding(
        padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
        child: Text('delivery_details'.tr, style: robotoMedium),
      ) : const SizedBox(),

      Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(isDesktop ? Dimensions.radiusDefault : 0),
          boxShadow: [BoxShadow(color: isDesktop ? Colors.black.withOpacity(0.05) : Theme.of(context).primaryColor.withOpacity(0.05), blurRadius: 10)],
        ),
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical: Dimensions.paddingSizeSmall),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          !isDesktop ? Text('delivery_details'.tr, style: robotoMedium) : const SizedBox(),
          SizedBox(height: isDesktop ? 0 : Dimensions.paddingSizeSmall),

          DeliveryDetails(from: true, address: order.restaurant?.address ?? ''),
          const Divider(height: Dimensions.paddingSizeLarge),

          DeliveryDetails(from: false, address: order.deliveryAddress?.address ?? ''),
        ]),
      ),
      const SizedBox(height: Dimensions.paddingSizeSmall),

      isDesktop ? Padding(
        padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
        child: Text('restaurant_details'.tr, style: robotoMedium),
      ) : const SizedBox(),

      Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(isDesktop ? Dimensions.radiusDefault : 0),
          boxShadow: [BoxShadow(color: isDesktop ? Colors.black.withOpacity(0.05) : Theme.of(context).primaryColor.withOpacity(0.05), blurRadius: 10)],
        ),
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical: Dimensions.paddingSizeSmall),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

          !isDesktop ? Text('restaurant_details'.tr, style: robotoMedium) : const SizedBox(),
          SizedBox(height: !isDesktop ? Dimensions.paddingSizeSmall : 0),

          order.restaurant != null ? Row(children: [
            ClipOval(child: CustomImageWidget(
              image: '${Get.find<SplashController>().configModel!.baseUrls!.restaurantImageUrl}/${order.restaurant!.logo}',
              height: 35, width: 35, fit: BoxFit.cover,
            )),
            const SizedBox(width: Dimensions.paddingSizeSmall),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                order.restaurant!.name!, maxLines: 1, overflow: TextOverflow.ellipsis,
                style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
              ),
              Text(
                order.restaurant!.address!, maxLines: 1, overflow: TextOverflow.ellipsis,
                style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
              ),
            ])),

            (takeAway && (pending || accepted || confirmed || processing || order.orderStatus == 'handover'
            || pickedUp)) ? TextButton.icon(
              onPressed: () async {
                String url ='https://www.google.com/maps/dir/?api=1&destination=${order.restaurant!.latitude}'
                    ',${order.restaurant!.longitude}&mode=d';
                if (await canLaunchUrlString(url)) {
                  await launchUrlString(url, mode: LaunchMode.externalApplication);
                }else {
                  showCustomSnackBar('unable_to_launch_google_map'.tr);
                }
              },
              icon: const Icon(Icons.directions), label: Text('direction'.tr),
            ) : const SizedBox(),

            (showChatPermission && !delivered && order.orderStatus != 'failed' && !cancelled && order.orderStatus != 'refunded' && !isGuestLoggedIn) ? InkWell(
              onTap: () async {
                orderController.cancelTimer();
                await Get.toNamed(RouteHelper.getChatRoute(
                  notificationBody: NotificationBodyModel(orderId: order.id, restaurantId: order.restaurant!.vendorId),
                  user: User(id: order.restaurant!.vendorId, fName: order.restaurant!.name, lName: '', image: order.restaurant!.logo),
                ));
                orderController.callTrackOrderApi(orderModel: order, orderId: order.id.toString());
              },
              child: Image.asset(Images.chatImageOrderDetails, height: 25, width: 25, fit: BoxFit.cover),
            ) : const SizedBox(),

            (!subscription && Get.find<SplashController>().configModel!.refundStatus! && delivered && orderController.orderDetails![0].itemCampaignId == null && !isGuestLoggedIn)
            ? InkWell(
              onTap: () => Get.toNamed(RouteHelper.getRefundRequestRoute(order.id.toString())),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Theme.of(context).primaryColor, width: 1),
                  borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                ),
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall, vertical: Dimensions.paddingSizeSmall),
                child: Text('request_for_refund'.tr, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).primaryColor)),
              ),
            ) : const SizedBox(),

          ]) : Center(child: Padding(
            padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
            child: Text(
              'no_restaurant_data_found'.tr, maxLines: 1, overflow: TextOverflow.ellipsis,
              style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
            ),
          )),
        ]),
      ),
      const SizedBox(height: Dimensions.paddingSizeSmall),

      order.deliveryMan != null ? Column(children: [

        isDesktop ? Padding(
          padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
          child: Text('delivery_man_details'.tr, style: robotoMedium),
        ) : const SizedBox(),

        Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(isDesktop ? Dimensions.radiusDefault : 0),
              boxShadow: [BoxShadow(color: isDesktop ? Colors.black.withOpacity(0.05) : Theme.of(context).primaryColor.withOpacity(0.05), blurRadius: 10)],
            ),
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical: Dimensions.paddingSizeSmall),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

              !isDesktop ? Text('delivery_man_details'.tr, style: robotoMedium) : const SizedBox(),
              SizedBox(height: !isDesktop ? Dimensions.paddingSizeSmall : 0),

              Row(children: [
                ClipOval(child: CustomImageWidget(
                  image: '${ Get.find<SplashController>().configModel!.baseUrls!.deliveryManImageUrl}/${order.deliveryMan!.image}',
                  height: 35, width: 35, fit: BoxFit.cover,
                )),
                const SizedBox(width: Dimensions.paddingSizeSmall),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(
                      '${order.deliveryMan!.fName} ${order.deliveryMan!.lName}',
                      maxLines: 1, overflow: TextOverflow.ellipsis,
                      style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall)
                  ),
                  RatingBarWidget(
                    rating: order.deliveryMan!.avgRating, size: 10,
                    ratingCount: order.deliveryMan!.ratingCount,
                  ),
                ])),

                !isGuestLoggedIn ? InkWell(
                  onTap: () async {
                    orderController.cancelTimer();
                    await Get.toNamed(RouteHelper.getChatRoute(
                      notificationBody: NotificationBodyModel(deliverymanId: order.deliveryMan!.id, orderId: int.parse(order.id.toString())),
                      user: User(id: order.deliveryMan!.id, fName: order.deliveryMan!.fName, lName: order.deliveryMan!.lName, image: order.deliveryMan!.image),
                    ));
                    orderController.callTrackOrderApi(orderModel: order, orderId: order.id.toString());
                  },
                  child: Image.asset(Images.chatImageOrderDetails, height: 25, width: 25, fit: BoxFit.cover),
                ) : const SizedBox(),
                const SizedBox(width: Dimensions.paddingSizeDefault),

                InkWell(
                  onTap: () async {
                    if(await canLaunchUrlString('tel:${order.deliveryMan!.phone}')) {
                      launchUrlString('tel:${order.deliveryMan!.phone}', mode: LaunchMode.externalApplication);
                    }else {
                      showCustomSnackBar('${'can_not_launch'.tr} ${order.deliveryMan!.phone}');
                    }

                  },
                  child: Image.asset(Images.callImageOrderDetails, height: 25, width: 25, fit: BoxFit.cover),
                ),

              ]),
            ]),
          ),
      ]) : const SizedBox(),
      SizedBox(height: order.deliveryMan != null ? Dimensions.paddingSizeLarge : 0),

      isDesktop ? Padding(
        padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
        child: Text('payment_method'.tr, style: robotoMedium),
      ) : const SizedBox(),

      Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(isDesktop ? Dimensions.radiusDefault : 0),
          boxShadow: [BoxShadow(color: isDesktop ? Colors.black.withOpacity(0.05) : Theme.of(context).primaryColor.withOpacity(0.05), blurRadius: 10)],
        ),
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical: Dimensions.paddingSizeSmall),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          !isDesktop ? Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

            Text('payment_method'.tr, style: robotoMedium),
            order.paymentMethod == 'offline_payment' || (order.paymentMethod == 'partial_payment' && orderController.trackModel!.offlinePayment != null) ? Text(
              orderController.trackModel!.offlinePayment != null ? orderController.trackModel!.offlinePayment!.data!.status!.tr : '',
              style: robotoMedium.copyWith(color: (orderController.trackModel!.offlinePayment != null ? orderController.trackModel!.offlinePayment!.data!.status.toString() == 'denied' : false) ? Colors.red : Theme.of(context).primaryColor),
            ) : const SizedBox(),
          ]) : const SizedBox(),
          SizedBox(height: (!isDesktop && order.paymentMethod != 'offline_payment') ? Dimensions.paddingSizeSmall : 0),

          order.paymentMethod == 'offline_payment'  || (order.paymentMethod == 'partial_payment' && orderController.trackModel!.offlinePayment != null)
          ? offlineView(context, orderController, expansionTileController, ongoing, contactNumber) :  Row(children: [

            Image.asset(
              order.paymentMethod == 'cash_on_delivery' ? Images.cashOnDelivery
                  : order.paymentMethod == 'wallet' ? Images.wallet
                  : order.paymentMethod == 'partial_payment' ? Images.partialWallet
                  : Images.digitalPayment,
              width: 20, height: 20,
              color: Theme.of(context).textTheme.bodyMedium!.color,
            ),
            const SizedBox(width: Dimensions.paddingSizeSmall),

            Expanded(
              child: Text(
                order.paymentMethod == 'cash_on_delivery' ? 'cash'.tr
                    : order.paymentMethod == 'wallet' ? 'wallet'.tr
                    : order.paymentMethod == 'partial_payment' ? 'partial_payment'.tr
                    : 'digital'.tr,
                style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
              ),
            ),

          ]),
        ]),
      ),
    ]);
  }
}

Widget offlineView(BuildContext context, OrderController orderController, ExpansionTileController controller, bool ongoing, String? contactNumber) {
  return ListTileTheme(
    contentPadding: const EdgeInsets.all(0),
    dense: true,
    horizontalTitleGap: 5.0,
    minLeadingWidth: 0,
    child: Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        controller: controller,
        leading: Image.asset(
          Images.cash, width: 20, height: 20,
          color: Theme.of(context).textTheme.bodyMedium!.color,
        ),
        title: Text(
          'offline_payment'.tr,
          style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
        ),
        trailing: Icon(orderController.isExpanded ? Icons.expand_more : Icons.expand_less, size: 18),
        tilePadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        onExpansionChanged: (value) => orderController.expandedUpdate(value),

        children: [
          const Divider(),

          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('seller_payment_info'.tr, style: robotoMedium),
            const SizedBox(),
          ]),
          const SizedBox(height: Dimensions.paddingSizeDefault),

          orderController.trackModel!.offlinePayment != null ? ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: orderController.trackModel!.offlinePayment!.methodFields!.length,
            itemBuilder: (context, index){
              return Padding(
                padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeExtraSmall),
                child: Row(children: [
                  Text('${orderController.trackModel!.offlinePayment!.methodFields![index].inputName.toString().replaceAll('_', ' ')} : ', style: robotoRegular),
                  Text('${orderController.trackModel!.offlinePayment!.methodFields![index].inputData}', style: robotoRegular),
                ]),
              );
            },
          ) : Text('no_data_found'.tr),
          const Divider(),

          orderController.trackModel!.offlinePayment != null ? Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('my_payment_info'.tr, style: robotoMedium),

            (ongoing && orderController.trackModel!.offlinePayment!.data!.status != 'verified') ? InkWell(
              onTap: (){
                Get.dialog(OfflineInfoEditDialog(offlinePayment: orderController.trackModel!.offlinePayment!, orderId: orderController.trackModel!.id!, contactNumber: contactNumber), barrierDismissible: true);
              },
              child: Text('edit_details'.tr, style: robotoBold.copyWith(color: Colors.blue)),
            ) : const SizedBox(),
          ]) : const SizedBox(),
          const SizedBox(height: Dimensions.paddingSizeDefault),

          orderController.trackModel!.offlinePayment != null ? ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: orderController.trackModel!.offlinePayment!.input!.length,
            itemBuilder: (context, index){
              Input data = orderController.trackModel!.offlinePayment!.input![index];
              return Padding(
                padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeExtraSmall),
                child: Row(children: [
                  Text('${data.userInput.toString().replaceAll('_', ' ')}: ', style: robotoRegular),
                  Text(data.userData.toString(), style: robotoRegular),
                ]),
              );
            },
          ) : const SizedBox(),
          // const SizedBox(height: Dimensions.paddingSizeSmall),
        ],
      ),
    ),
  );
}

void openDialog(BuildContext context, String imageUrl) => showDialog(
  context: context,
  builder: (BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusLarge)),
      child: Stack(children: [

        ClipRRect(
          borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
          child: PhotoView(
            tightMode: true,
            imageProvider: NetworkImage(imageUrl),
            heroAttributes: PhotoViewHeroAttributes(tag: imageUrl),
          ),
        ),

        Positioned(top: 0, right: 0, child: IconButton(
          splashRadius: 5,
          onPressed: () => Get.back(),
          icon: const Icon(Icons.cancel, color: Colors.red),
        )),

      ]),
    );
  },
);