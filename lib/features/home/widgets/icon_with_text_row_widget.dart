import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:flutter/material.dart';

class IconWithTextRowWidget extends StatelessWidget {
  const IconWithTextRowWidget({
    super.key, required this.icon, required this.text, required this.style,
  });

  final IconData icon;
  final String text;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Icon(icon, color: Theme.of(context).primaryColor, size: 20),
        const SizedBox(width: Dimensions.paddingSizeExtraSmall),
        Text(text, style: style),
      ],
    );
  }
}



class ImageWithTextRowWidget extends StatelessWidget {
  const ImageWithTextRowWidget({
    super.key, required this.widget, required this.text, required this.style,
  });

  final Widget widget;
  final String text;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        widget,
        const SizedBox(width: Dimensions.paddingSizeExtraSmall),
        Text(text, style: style),
      ],
    );
  }
}