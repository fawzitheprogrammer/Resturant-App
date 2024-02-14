import 'package:stackfood_multivendor/features/auth/controllers/auth_controller.dart';
import 'package:stackfood_multivendor/features/refer%20and%20earn/controllers/refer_and_earn_controller.dart';
import 'package:stackfood_multivendor/features/refer%20and%20earn/widgets/bottom_sheet_view_widget.dart';
import 'package:stackfood_multivendor/features/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor/helper/price_converter.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/images.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:stackfood_multivendor/common/widgets/custom_app_bar_widget.dart';
import 'package:stackfood_multivendor/common/widgets/custom_snackbar_widget.dart';
import 'package:stackfood_multivendor/common/widgets/footer_view_widget.dart';
import 'package:stackfood_multivendor/common/widgets/menu_drawer_widget.dart';
import 'package:stackfood_multivendor/common/widgets/not_logged_in_screen.dart';
import 'package:stackfood_multivendor/common/widgets/web_page_title_widget.dart';
import 'package:expandable_bottom_sheet/expandable_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:share_plus/share_plus.dart';

class ReferAndEarnScreen extends StatefulWidget {
  const ReferAndEarnScreen({super.key});

  @override
  State<ReferAndEarnScreen> createState() => _ReferAndEarnScreenState();
}

class _ReferAndEarnScreenState extends State<ReferAndEarnScreen> {
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _initCall();
  }

  void _initCall(){
    Get.find<ReferAndEarnController>().getUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    bool isDesktop = ResponsiveHelper.isDesktop(context);
    bool isLoggedIn = Get.find<AuthController>().isLoggedIn();

    return Scaffold(
      appBar: CustomAppBarWidget(title: 'refer'.tr),
      endDrawer: const MenuDrawerWidget(), endDrawerEnableOpenDragGesture: false,
      body: ExpandableBottomSheet(
        background: isLoggedIn ? SingleChildScrollView(
          controller: scrollController,
          padding: EdgeInsets.symmetric(horizontal: isDesktop ? 0 : Dimensions.paddingSizeLarge),
          child: Column(children: [
            
            WebScreenTitleWidget(title: 'refer_and_earn'.tr),

            FooterViewWidget(
              child: Center(
                child: SizedBox(
                  width: Dimensions.webMaxWidth,
                  child: GetBuilder<ReferAndEarnController>(builder: (referAndEarnController) {
                    return Column(mainAxisAlignment: MainAxisAlignment.start, children: [

                      Image.asset(
                        Images.referImage, width: 500,
                        height: isDesktop ? 250 : 150, fit: BoxFit.contain,
                      ),
                      const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                      isDesktop ? const SizedBox() : Text('earn_money_on_every_referral'.tr, style: robotoRegular.copyWith(color: Theme.of(context).primaryColor, fontSize: Dimensions.fontSizeSmall)),
                      isDesktop ? const SizedBox() : const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                      isDesktop ? const SizedBox() : Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                        Text(
                          '${'one_referral'.tr}= ', style: robotoBold.copyWith(fontSize: Dimensions.fontSizeDefault),
                        ),
                        Text(
                          PriceConverter.convertPrice(Get.find<SplashController>().configModel != null
                              ? Get.find<SplashController>().configModel!.refEarningExchangeRate!.toDouble() : 0.0),
                          style: robotoBold.copyWith(fontSize: Dimensions.fontSizeDefault), textDirection: TextDirection.ltr,
                        ),
                      ]),
                      isDesktop ? const SizedBox() : const SizedBox(height: 40),

                      Text('invite_friends_and_business'.tr , style: robotoBold.copyWith(fontSize: Dimensions.fontSizeOverLarge), textAlign: TextAlign.center),
                      const SizedBox(height: Dimensions.paddingSizeSmall),

                      isDesktop ? Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                        Text(
                          '${'one_referral'.tr}= ', style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
                        ),
                        Text(
                          PriceConverter.convertPrice(Get.find<SplashController>().configModel != null
                              ? Get.find<SplashController>().configModel!.refEarningExchangeRate!.toDouble() : 0.0),
                          style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall), textDirection: TextDirection.ltr,
                        ),
                      ]) : const SizedBox(),
                      isDesktop ?  const SizedBox(height: 40) : const SizedBox(),

                      isDesktop ? const SizedBox() : Text('copy_your_code_share_it_with_your_friends'.tr , style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall), textAlign: TextAlign.center),
                      isDesktop ? const SizedBox() : const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                      isDesktop ? Align(
                        alignment: Alignment.topLeft,
                        child: Text('your_personal_code'.tr , style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall), textAlign: TextAlign.center),
                      ) : const SizedBox(),

                      isDesktop ? const SizedBox() : Text('your_personal_code'.tr , style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor), textAlign: TextAlign.center),
                      const SizedBox(height: Dimensions.paddingSizeSmall),

                      DottedBorder(
                        color: Theme.of(context).primaryColor,
                        strokeWidth: 1,
                        strokeCap: StrokeCap.butt,
                        dashPattern: const [8, 5],
                        padding: const EdgeInsets.all(0),
                        borderType: BorderType.RRect,
                        radius: Radius.circular( isDesktop ? Dimensions.radiusDefault : 50),
                        child: SizedBox(
                          height: 50,
                          child: (referAndEarnController.userInfoModel != null) ? Row(children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: Dimensions.paddingSizeLarge, right: Dimensions.paddingSizeLarge),
                                child: Text(
                                  referAndEarnController.userInfoModel != null ? referAndEarnController.userInfoModel!.refCode ?? '' : '',
                                  style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeExtraLarge),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                if(referAndEarnController.userInfoModel!.refCode!.isNotEmpty){
                                  Clipboard.setData(ClipboardData(text: '${referAndEarnController.userInfoModel != null ? referAndEarnController.userInfoModel!.refCode : ''}'));
                                  showCustomSnackBar('referral_code_copied'.tr, isError: false);
                                }
                              },
                              child: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(color: Theme.of(context).primaryColor, borderRadius: BorderRadius.circular( isDesktop ? Dimensions.radiusDefault : 50)),
                                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraLarge),
                                margin: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                                child: Text('copy'.tr, style: robotoMedium.copyWith(color: Theme.of(context).cardColor, fontSize: Dimensions.fontSizeDefault)),
                              ),
                            ),
                          ]) : const CircularProgressIndicator(),
                        ),
                      ),
                      const SizedBox(height: Dimensions.paddingSizeLarge),

                      Wrap(children: [
                        InkWell(
                          onTap: () => Share.share('${'this_is_my_refer_code'.tr}: ${referAndEarnController.userInfoModel!.refCode}'),
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Theme.of(context).cardColor,
                              boxShadow: [BoxShadow(color: Theme.of(context).primaryColor.withOpacity(0.2), blurRadius: 5)],
                            ),
                            padding: const EdgeInsets.all(7),
                            child: const Icon(Icons.share),
                          ),
                        )
                      ]),

                      isDesktop ? const Padding(
                        padding: EdgeInsets.only(top: Dimensions.paddingSizeExtraLarge),
                        child: BottomSheetViewWidget(),
                      ) : const SizedBox(),

                    ]);
                  }),
                ),
              ),
            ),
          ]),
        ) : NotLoggedInScreen(callBack: (value){
          _initCall();
          setState(() {});
        }),

        persistentContentHeight: isDesktop ? 0 : 60,
        expandableContent: isDesktop || !isLoggedIn ? const SizedBox() : const BottomSheetViewWidget(),

      ),
    );
  }
}



