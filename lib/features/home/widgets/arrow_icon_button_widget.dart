import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:flutter/material.dart';

class ArrowIconButtonWidget extends StatelessWidget {
  const ArrowIconButtonWidget({super.key, this.onTap, this.isLeft});

  final void Function()? onTap;
  final bool? isLeft;


  @override
  Widget build(BuildContext context) {
    return InkWell(
      hoverColor: Colors.transparent,
      onTap: onTap,
      child: Container(
        height: ResponsiveHelper.isMobile(context) ? 30 : 40, width: ResponsiveHelper.isMobile(context) ? 30 : 40,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          shape: BoxShape.circle,
          border: Border.all(color: Theme.of(context).primaryColor.withOpacity(0.3)),
        ),
        child: Icon(
          isLeft == true ? Icons.arrow_back : Icons.arrow_forward,  size: 20,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }
}
