import 'package:stackfood_multivendor/common/widgets/web_menu_bar.dart';
import 'package:stackfood_multivendor/helper/route_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:stackfood_multivendor/common/widgets/cart_widget.dart';
import 'package:stackfood_multivendor/common/widgets/veg_filter_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomAppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool isBackButtonExist;
  final Function? onBackPressed;
  final bool showCart;
  final Color? bgColor;
  final Function(String value)? onVegFilterTap;
  final String? type;
  const CustomAppBarWidget({super.key, required this.title, this.isBackButtonExist = true, this.onBackPressed,
    this.showCart = false, this.bgColor, this.onVegFilterTap, this.type});

  @override
  Widget build(BuildContext context) {
    return GetPlatform.isDesktop ? const WebMenuBar() : AppBar(
      title: Text(title, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeLarge, color: bgColor == null ? Theme.of(context).textTheme.bodyLarge!.color : Theme.of(context).cardColor)),
      centerTitle: true,
      leading: isBackButtonExist ? IconButton(
        icon: const Icon(Icons.arrow_back_ios),
        color: bgColor == null ? Theme.of(context).textTheme.bodyLarge!.color : Theme.of(context).cardColor,
        onPressed: () => onBackPressed != null ? onBackPressed!() : Navigator.pop(context),
      ) : const SizedBox(),
      backgroundColor: bgColor ?? Theme.of(context).cardColor,
      elevation: 0,
      actions: showCart || onVegFilterTap != null ? [
        showCart ? IconButton(
          onPressed: () => Get.toNamed(RouteHelper.getCartRoute()),
          icon: CartWidget(color: Theme.of(context).textTheme.bodyLarge!.color, size: 25),
        ) : const SizedBox(),

        onVegFilterTap != null ? VegFilterWidget(
          type: type,
          onSelected: onVegFilterTap,
          fromAppBar: true,
        ) : const SizedBox(),
      ] : [const SizedBox()],
    );
  }

  @override
  Size get preferredSize => Size(Dimensions.webMaxWidth, GetPlatform.isDesktop ? 100 : 50);
}
