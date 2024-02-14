import 'package:stackfood_multivendor/features/notification/domain/models/notification_model.dart';
import 'package:stackfood_multivendor/features/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/images.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:stackfood_multivendor/common/widgets/custom_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationDialogWidget extends StatelessWidget {
  final NotificationModel notificationModel;
  const NotificationDialogWidget({super.key, required this.notificationModel});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(Dimensions.radiusSmall))),
      insetPadding: const EdgeInsets.all(30),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child:  SizedBox(
        width: 600,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),

              (notificationModel.data!.image != null && notificationModel.data!.image!.isNotEmpty) ? Container(
                height: 150, width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.radiusSmall), color: Theme.of(context).primaryColor.withOpacity(0.20)),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                  child: CustomImageWidget(
                    placeholder: Images.notificationPlaceholder,
                    image: '${Get.find<SplashController>().configModel!.baseUrls!.notificationImageUrl}/${notificationModel.data!.image}',
                    height: 150, width: MediaQuery.of(context).size.width, fit: BoxFit.cover,
                  ),
                ),
              ) : SizedBox(
                height: 100, width: 100,
                child: ClipOval(
                  child: Image.asset(Images.orderPlaceHolder),
                ),
              ),
              const SizedBox(height: Dimensions.paddingSizeLarge),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: (notificationModel.data!.image != null && notificationModel.data!.image!.isNotEmpty)
                    ? Dimensions.paddingSizeLarge : 0),
                child: Text(
                  notificationModel.data!.title!,
                  textAlign: TextAlign.center,
                  style: robotoMedium.copyWith(
                    color: Theme.of(context).primaryColor,
                    fontSize: Dimensions.fontSizeLarge,
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                child: Text(
                  notificationModel.data!.description!,
                  textAlign: TextAlign.center,
                  style: robotoRegular.copyWith(
                    color: Theme.of(context).disabledColor,
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
