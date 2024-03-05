import 'package:swift_tech_resto/features/splash/controllers/splash_controller.dart';
import 'package:swift_tech_resto/util/dimensions.dart';
import 'package:swift_tech_resto/common/widgets/custom_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OverFlowContainerWidget extends StatelessWidget {
  final String image;
  const OverFlowContainerWidget({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
      height: 30,
      width: 30,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        shape: BoxShape.circle,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: CustomImageWidget(
          image:
              '${Get.find<SplashController>().configModel!.baseUrls!.productImageUrl}/$image',
          fit: BoxFit.cover,
          height: 30,
          width: 30,
        ),
      ),
    );
  }
}
