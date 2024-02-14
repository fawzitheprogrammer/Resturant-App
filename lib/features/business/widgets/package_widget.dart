import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PackageWidget extends StatelessWidget {
  final String title;
  const PackageWidget({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Padding(
        padding: EdgeInsets.only(left: ResponsiveHelper.isDesktop(Get.context) ? MediaQuery.of(Get.context!).size.width * 0.05 : MediaQuery.of(Get.context!).size.width * 0.15),
        child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          const Icon(Icons.check_circle, size: 18, color: Colors.green),
          const SizedBox(width: Dimensions.paddingSizeSmall),

          Text(title.tr, style: robotoMedium),
        ]),
      ),

      Divider(indent: 50, endIndent: 50, color: Theme.of(Get.context!).dividerColor,thickness: 1,)
    ]);
  }
}
