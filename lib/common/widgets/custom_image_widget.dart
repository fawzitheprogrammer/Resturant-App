import 'package:cached_network_image/cached_network_image.dart';
import 'package:swift_tech_resto/util/images.dart';
import 'package:flutter/material.dart';

class CustomImageWidget extends StatelessWidget {
  final String image;
  final double? height;
  final double? width;
  final BoxFit? fit;
  final bool isNotification;
  final String placeholder;
  const CustomImageWidget(
      {super.key,
      required this.image,
      this.height,
      this.width,
      this.fit = BoxFit.cover,
      this.isNotification = false,
      this.placeholder = ''});

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: image,
      height: height,
      width: width,
      fit: fit,
      placeholder: (context, url) => Image.asset(
          placeholder.isNotEmpty
              ? placeholder
              : isNotification
                  ? Images.notificationPlaceholder
                  : Images.placeholder,
          height: height,
          width: width,
          fit: fit),
      errorWidget: (context, url, error) => Image.asset(
          placeholder.isNotEmpty
              ? placeholder
              : isNotification
                  ? Images.notificationPlaceholder
                  : Images.placeholder,
          height: height,
          width: width,
          fit: fit),
    );
  }
}
