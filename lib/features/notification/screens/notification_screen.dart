import 'package:stackfood_multivendor/features/auth/controllers/auth_controller.dart';
import 'package:stackfood_multivendor/features/notification/controllers/notification_controller.dart';
import 'package:stackfood_multivendor/features/notification/widgets/notification_dialog_widget.dart';
import 'package:stackfood_multivendor/features/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor/helper/date_converter.dart';
import 'package:stackfood_multivendor/helper/route_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/images.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:stackfood_multivendor/common/widgets/custom_app_bar_widget.dart';
import 'package:stackfood_multivendor/common/widgets/custom_image_widget.dart';
import 'package:stackfood_multivendor/common/widgets/footer_view_widget.dart';
import 'package:stackfood_multivendor/common/widgets/menu_drawer_widget.dart';
import 'package:stackfood_multivendor/common/widgets/no_data_screen_widget.dart';
import 'package:stackfood_multivendor/common/widgets/not_logged_in_screen.dart';
import 'package:stackfood_multivendor/common/widgets/web_page_title_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationScreen extends StatefulWidget {
  final bool fromNotification;
  const NotificationScreen({super.key, this.fromNotification = false});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final ScrollController scrollController = ScrollController();

  void _loadData() async {
    Get.find<NotificationController>().clearNotification();
    if(Get.find<SplashController>().configModel == null) {
      await Get.find<SplashController>().getConfigData();
    }
    if(Get.find<AuthController>().isLoggedIn()) {
      Get.find<NotificationController>().getNotificationList(true);
    }
  }
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {


    return PopScope(
      canPop: Navigator.canPop(context),
      onPopInvoked: (val) async {
        if(widget.fromNotification) {
          Get.offAllNamed(RouteHelper.getInitialRoute());
        }else {
          return;
        }
      },
      child: Scaffold(
        appBar: CustomAppBarWidget(title: 'notification'.tr, onBackPressed: () {
          if(widget.fromNotification) {
            Get.offAllNamed(RouteHelper.getInitialRoute());
          }else {
            Get.back();
          }
        }),
        endDrawer: const MenuDrawerWidget(), endDrawerEnableOpenDragGesture: false,
        body: Get.find<AuthController>().isLoggedIn() ? GetBuilder<NotificationController>(builder: (notificationController) {
          if(notificationController.notificationList != null) {
            notificationController.saveSeenNotificationCount(notificationController.notificationList!.length);
          }
          List<DateTime> dateTimeList = [];
          return notificationController.notificationList != null ? notificationController.notificationList!.isNotEmpty ? RefreshIndicator(
            onRefresh: () async {
              await notificationController.getNotificationList(true);
            },
            child: Scrollbar(controller: scrollController, child: SingleChildScrollView(
              controller: scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              child: FooterViewWidget(
                child: Column(children: [
                  WebScreenTitleWidget(title: 'notification'.tr),

                  Center(child: SizedBox(width: Dimensions.webMaxWidth, child: ListView.builder(
                    itemCount: notificationController.notificationList!.length,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      DateTime originalDateTime = DateConverter.dateTimeStringToDate(notificationController.notificationList![index].createdAt!);
                      DateTime convertedDate = DateTime(originalDateTime.year, originalDateTime.month, originalDateTime.day);
                      bool addTitle = false;
                      if(!dateTimeList.contains(convertedDate)) {
                        addTitle = true;
                        dateTimeList.add(convertedDate);
                      }
                      bool isSeen = notificationController.getSeenNotificationIdList()!.contains(notificationController.notificationList![index].id);

                      return Builder(
                          builder: (context) {
                            return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                              addTitle ? Padding(
                                padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall, horizontal: Dimensions.paddingSizeSmall),
                                child: Text(
                                  DateConverter.dateTimeStringToDateOnly(notificationController.notificationList![index].createdAt!),
                                  style: robotoMedium,
                                ),
                              ) : const SizedBox(),

                              InkWell(
                                onTap: () {
                                  notificationController.addSeenNotificationId(notificationController.notificationList![index].id!);

                                  showDialog(context: context, builder: (BuildContext context) {
                                    return NotificationDialogWidget(notificationModel: notificationController.notificationList![index]);
                                  });
                                },
                                child: Container(
                                  color: isSeen ? Colors.transparent : Theme.of(context).cardColor,
                                  padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeLarge, horizontal: Dimensions.paddingSizeLarge),
                                  child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [

                                    ClipOval(child: CustomImageWidget(
                                      height: 34, width: 34, fit: BoxFit.cover, placeholder: Images.notificationPlaceholder,
                                      image: '${Get.find<SplashController>().configModel!.baseUrls!.notificationImageUrl}'
                                          '/${notificationController.notificationList![index].data!.image}',
                                    )),
                                    const SizedBox(width: Dimensions.paddingSizeSmall),

                                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                      Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                        Expanded(
                                          child: Text(
                                            notificationController.notificationList![index].data!.title ?? '', maxLines: 2, overflow: TextOverflow.ellipsis,
                                            style: isSeen ? robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall) : robotoBold.copyWith(fontSize: Dimensions.fontSizeSmall),
                                          ),
                                        ),

                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                                          child: Text(
                                            DateConverter.dateTimeStringToTime(notificationController.notificationList![index].createdAt!),
                                            style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
                                          ),
                                        ),
                                      ]),
                                      const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                                      Text(
                                        notificationController.notificationList![index].data!.description ?? '', maxLines: 2, overflow: TextOverflow.ellipsis,
                                        style: isSeen ? robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall) : robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
                                      ),
                                    ])),

                                  ]),
                                ),
                              ),

                              // Padding(
                              //   padding: const EdgeInsets.only(left: 50),
                              //   child: Divider(color: Theme.of(context).disabledColor, thickness: 1),
                              // ),

                            ]);
                          }
                      );
                    },
                  ))),
                ],
                ),
              ),
            )),
          ) : NoDataScreen(title: 'no_notification_found'.tr) : const Center(child: CircularProgressIndicator());
        }) : NotLoggedInScreen(callBack: (value){
          _loadData();
          setState(() {});
        }),
      ),
    );
  }
}
