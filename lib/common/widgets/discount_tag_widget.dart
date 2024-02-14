import 'package:stackfood_multivendor/features/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DiscountTagWidget extends StatelessWidget {
  final double? discount;
  final String? discountType;
  final double fromTop;
  final double? fontSize;
  final bool inLeft;
  final bool? freeDelivery;
  const DiscountTagWidget({super.key,
    required this.discount, required this.discountType, this.fromTop = 10, this.fontSize, this.freeDelivery = false,
    this.inLeft = true,
  });

  @override
  Widget build(BuildContext context) {
    bool isRightSide = Get.find<SplashController>().configModel!.currencySymbolDirection == 'right';
    String currencySymbol = Get.find<SplashController>().configModel!.currencySymbol!;

    return (discount! > 0 || freeDelivery!) ? Positioned(
      top: fromTop, left: inLeft ? 0 : null, right: inLeft ? null : 0,
      child: CustomPaint(
        size: const Size(110, 30),
        painter: LabelPaint(),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Text(
            discount! > 0 ? '${(isRightSide || discountType == 'percent') ? '' : currencySymbol}$discount${discountType == 'percent' ? '%'
                : isRightSide ? currencySymbol : ''} ${'off'.tr}' : 'free_delivery'.tr,
            style: robotoMedium.copyWith(
              color: Colors.white,
              fontSize: fontSize ?? (ResponsiveHelper.isMobile(context) ? 8 : 12),
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    ) : const SizedBox();
  }
}

class LabelPaint extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();
    Path path = Path();


    // Path number 1


    paint.color = const Color(0xffFF6B00);
    path = Path();
    path.lineTo(0, size.height * 0.27);
    path.cubicTo(0, size.height * 0.12, size.width * 0.04, 0, size.width * 0.08, 0);
    path.cubicTo(size.width * 0.08, 0, size.width * 0.97, 0, size.width * 0.97, 0);
    path.cubicTo(size.width, 0, size.width, size.height * 0.1, size.width, size.height * 0.17);
    path.cubicTo(size.width, size.height * 0.17, size.width * 0.95, size.height * 0.35, size.width * 0.95, size.height * 0.35);
    path.cubicTo(size.width * 0.93, size.height * 0.44, size.width * 0.93, size.height * 0.56, size.width * 0.95, size.height * 0.65);
    path.cubicTo(size.width * 0.95, size.height * 0.65, size.width, size.height * 0.83, size.width, size.height * 0.83);
    path.cubicTo(size.width, size.height * 0.9, size.width, size.height, size.width * 0.97, size.height);
    path.cubicTo(size.width * 0.97, size.height, 0, size.height, 0, size.height);
    path.cubicTo(0, size.height, 0, size.height * 0.27, 0, size.height * 0.27);
    path.cubicTo(0, size.height * 0.27, 0, size.height * 0.27, 0, size.height * 0.27);
    canvas.drawPath(path, paint);
  }
  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
