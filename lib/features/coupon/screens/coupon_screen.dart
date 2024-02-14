import 'package:stackfood_multivendor/features/auth/controllers/auth_controller.dart';
import 'package:stackfood_multivendor/features/coupon/controllers/coupon_controller.dart';
import 'package:stackfood_multivendor/features/coupon/widgets/coupon_card_widget.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/common/widgets/custom_app_bar_widget.dart';
import 'package:stackfood_multivendor/common/widgets/custom_snackbar_widget.dart';
import 'package:stackfood_multivendor/common/widgets/footer_view_widget.dart';
import 'package:stackfood_multivendor/common/widgets/menu_drawer_widget.dart';
import 'package:stackfood_multivendor/common/widgets/no_data_screen_widget.dart';
import 'package:stackfood_multivendor/common/widgets/not_logged_in_screen.dart';
import 'package:stackfood_multivendor/common/widgets/web_page_title_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class CouponScreen extends StatefulWidget {
  final bool fromCheckout;

  const CouponScreen({super.key, required this.fromCheckout});
  @override
  State<CouponScreen> createState() => _CouponScreenState();
}

class _CouponScreenState extends State<CouponScreen> {

  final ScrollController scrollController = ScrollController();
  final bool _isLoggedIn = Get.find<AuthController>().isLoggedIn();

  @override
  void initState() {
    super.initState();

    _initCall();
  }

  void _initCall(){
    if(Get.find<AuthController>().isLoggedIn()) {
      Get.find<CouponController>().getCouponList();
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: CustomAppBarWidget(title: 'coupon'.tr),
      endDrawer: const MenuDrawerWidget(), endDrawerEnableOpenDragGesture: false,
      body: _isLoggedIn ? GetBuilder<CouponController>(builder: (couponController) {
        return couponController.couponList != null ? couponController.couponList!.isNotEmpty ? RefreshIndicator(
          onRefresh: () async {
            await couponController.getCouponList();
          },
          child: Scrollbar(controller: scrollController, child: SingleChildScrollView(
            controller: scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                WebScreenTitleWidget(title: 'coupon'.tr),
                FooterViewWidget(
                  child: Center(child: SizedBox(width: Dimensions.webMaxWidth, child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: ResponsiveHelper.isDesktop(context) ? 3 : ResponsiveHelper.isTab(context) ? 2 : 1,
                      mainAxisSpacing: Dimensions.paddingSizeSmall, crossAxisSpacing: Dimensions.paddingSizeSmall,
                      childAspectRatio: ResponsiveHelper.isMobile(context) ? 3 : 3,
                    ),
                    itemCount: couponController.couponList!.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          Clipboard.setData(ClipboardData(text: couponController.couponList![index].code!));
                          // showCustomSnackBar('coupon_code_copied'.tr, isError: false);
                          if(!ResponsiveHelper.isDesktop(context)) {
                            showCustomSnackBar('coupon_code_copied'.tr, isError: false);
                          }
                        },
                        child: CouponCardWidget(couponController: couponController, index: index),
                      );
                    },
                  ))),
                ),
              ],
            ),
          )),
        ) : NoDataScreen(title: 'no_coupon_found'.tr) : const Center(child: CircularProgressIndicator());
      }) : NotLoggedInScreen(callBack: (bool value)  {
        _initCall();
        setState(() {});
      }),
    );
  }
}