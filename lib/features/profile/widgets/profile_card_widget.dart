import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:flutter/material.dart';

class ProfileCardWidget extends StatelessWidget {
  final String image;
  final String title;
  final String data;
  const ProfileCardWidget({super.key, required this.data, required this.title, required this.image});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 112,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        color: Theme.of(context).cardColor,
        boxShadow: [BoxShadow(color: Theme.of(context).primaryColor.withOpacity(0.1), blurRadius: 5, spreadRadius: 1)],
      ),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Image.asset(image, height: 30, width: 30),
        const SizedBox(height: Dimensions.paddingSizeSmall),
        Text(data, style: robotoMedium.copyWith(
          fontSize: Dimensions.fontSizeExtraLarge, color: Theme.of(context).primaryColor,
        )),
        const SizedBox(height: Dimensions.paddingSizeSmall),
        Text(title, style: robotoRegular.copyWith(
          fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor,
        )),
      ]),
    );
  }
}