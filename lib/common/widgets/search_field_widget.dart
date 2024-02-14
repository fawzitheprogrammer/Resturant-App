import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:flutter/material.dart';

class SearchFieldWidget extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  final IconData suffixIcon;
  final Function iconPressed;
  final Function? onSubmit;
  final Function? onChanged;
  const SearchFieldWidget({super.key, required this.controller, required this.hint, required this.suffixIcon, required this.iconPressed, this.onSubmit, this.onChanged});

  @override
  State<SearchFieldWidget> createState() => _SearchFieldWidgetState();
}

class _SearchFieldWidgetState extends State<SearchFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ResponsiveHelper.isDesktop(context) ? Dimensions.radiusSmall : 25),
          borderSide: BorderSide(width: 1, color: Theme.of(context).primaryColor)),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ResponsiveHelper.isDesktop(context) ? Dimensions.radiusSmall : 25),
          borderSide: BorderSide(width: 1, color: Theme.of(context).primaryColor)),
      hintText: widget.hint, hintStyle: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(ResponsiveHelper.isDesktop(context) ? Dimensions.radiusSmall : 25), borderSide: BorderSide.none),
      filled: true, fillColor: Theme.of(context).cardColor,
      isDense: true,
      suffixIcon: IconButton(
          onPressed: widget.iconPressed as void Function()?,
          icon: Icon(widget.suffixIcon),
        ),
      ),
      onSubmitted: widget.onSubmit as void Function(String)?,
      onChanged: widget.onChanged as void Function(String)?,
    );
  }
}
