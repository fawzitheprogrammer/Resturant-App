import 'package:stackfood_multivendor/features/auth/controllers/auth_controller.dart';
import 'package:stackfood_multivendor/features/cart/controllers/cart_controller.dart';
import 'package:stackfood_multivendor/features/menu/widgets/portion_widget.dart';
import 'package:stackfood_multivendor/features/profile/controllers/profile_controller.dart';
import 'package:stackfood_multivendor/features/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor/features/splash/controllers/theme_controller.dart';
import 'package:stackfood_multivendor/features/auth/screens/sign_in_screen.dart';
import 'package:stackfood_multivendor/features/favourite/controllers/favourite_controller.dart';
import 'package:stackfood_multivendor/helper/auth_helper.dart';
import 'package:stackfood_multivendor/helper/date_converter.dart';
import 'package:stackfood_multivendor/helper/price_converter.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/helper/route_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/images.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:stackfood_multivendor/common/widgets/confirmation_dialog_widget.dart';
import 'package:stackfood_multivendor/common/widgets/custom_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      body: GetBuilder<ProfileController>(
        builder: (profileController) {
          final bool isLoggedIn = Get.find<AuthController>().isLoggedIn();

          return Column(children: [

            Container(
              decoration: BoxDecoration(color: Theme.of(context).primaryColor),
              child: Padding(
                padding: const EdgeInsets.only(
                  left: Dimensions.paddingSizeOverLarge, right: Dimensions.paddingSizeOverLarge,
                  top: 50, bottom: Dimensions.paddingSizeOverLarge,
                ),
                child: Row(children: [

                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(1),
                    child: ClipOval(child: CustomImageWidget(
                      placeholder: Images.guestIconLight,
                      image: '${Get.find<SplashController>().configModel!.baseUrls!.customerImageUrl}'
                          '/${(profileController.userInfoModel != null && isLoggedIn) ? profileController.userInfoModel!.image : ''}',
                      height: 70, width: 70, fit: BoxFit.cover,
                    )),
                  ),
                  const SizedBox(width: Dimensions.paddingSizeDefault),

                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      isLoggedIn && profileController.userInfoModel == null ? Shimmer(
                        duration: const Duration(seconds: 2),
                        enabled: true,
                        child: Container(
                          height: 16, width: 200,
                          decoration: BoxDecoration(
                            color: Colors.grey[Get.find<ThemeController>().darkTheme ? 700 : 200],
                            borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                          ),
                        ),
                      ) : Text(
                        isLoggedIn ? '${profileController.userInfoModel?.fName} ${profileController.userInfoModel?.lName}' : 'guest_user'.tr,
                        style: robotoBold.copyWith(fontSize: Dimensions.fontSizeExtraLarge, color: Theme.of(context).cardColor),
                      ),
                      const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                      isLoggedIn && profileController.userInfoModel != null ? Text(
                        DateConverter.containTAndZToUTCFormat(profileController.userInfoModel!.createdAt!),
                        style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).cardColor),
                      ) : InkWell(
                        onTap: () async {
                          if(!ResponsiveHelper.isDesktop(context)) {
                            Get.toNamed(RouteHelper.getSignInRoute(Get.currentRoute))?.then((value) {
                              profileController.getUserInfo();
                            });
                          }else{
                            Get.dialog(const SignInScreen(exitFromApp: true, backFromThis: true)).then((value) {
                              profileController.getUserInfo();
                            });
                          }
                        },
                        child: Text(
                          'login_to_view_all_feature'.tr,
                          style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).cardColor),
                        ),
                      ) ,

                    ]),
                  ),

                ]),
              ),
            ),

            Expanded(child: SingleChildScrollView(
              child: Ink(
                color: Get.find<ThemeController>().darkTheme ? Theme.of(context).colorScheme.background : Theme.of(context).primaryColor.withOpacity(0.1),
                padding: const EdgeInsets.only(top: Dimensions.paddingSizeLarge),
                child: Column(children: [

                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                      child: Text(
                        'general'.tr,
                        style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).primaryColor.withOpacity(0.5)),
                      ),
                    ),

                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                        boxShadow: const [BoxShadow(color: Colors.black12, spreadRadius: 1, blurRadius: 5)],
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical: Dimensions.paddingSizeDefault),
                      margin: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                      child: Column(children: [
                        PortionWidget(icon: Images.profileIcon, title: 'profile'.tr, route: RouteHelper.getProfileRoute()),
                        PortionWidget(icon: Images.addressIcon, title: 'my_address'.tr, route: RouteHelper.getAddressRoute()),
                        PortionWidget(icon: Images.languageIcon, title: 'language'.tr, hideDivider: true, route: RouteHelper.getLanguageRoute('menu')),
                      ]),
                    )

                  ]),

                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                      child: Text(
                        'promotional_activity'.tr,
                        style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).primaryColor.withOpacity(0.5)),
                      ),
                    ),

                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                        boxShadow: const [BoxShadow(color: Colors.black12, spreadRadius: 1, blurRadius: 5)],
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical: Dimensions.paddingSizeDefault),
                      margin: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                      child: Column(children: [
                        PortionWidget(icon: Images.couponIcon, title: 'coupon'.tr, route: RouteHelper.getCouponRoute(fromCheckout: false)),

                        (Get.find<SplashController>().configModel!.loyaltyPointStatus == 1) ? PortionWidget(
                          icon: Images.pointIcon, title: 'loyalty_points'.tr, route: RouteHelper.getLoyaltyRoute(),
                          hideDivider: Get.find<SplashController>().configModel!.customerWalletStatus == 1 ? false : true,
                          suffix: !isLoggedIn ? null : '${profileController.userInfoModel?.loyaltyPoint != null ? Get.find<ProfileController>().userInfoModel!.loyaltyPoint.toString() : '0'} ${'points'.tr}' ,
                        ) : const SizedBox(),

                        (Get.find<SplashController>().configModel!.customerWalletStatus == 1) ? PortionWidget(
                          icon: Images.walletIcon, title: 'my_wallet'.tr, hideDivider: true, route: RouteHelper.getWalletRoute(),
                          suffix: !isLoggedIn ? null : PriceConverter.convertPrice(profileController.userInfoModel != null ? Get.find<ProfileController>().userInfoModel!.walletBalance : 0),
                        ) : const SizedBox(),
                      ]),
                    )
                  ]),

                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                      child: Text(
                        'earnings'.tr,
                        style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).primaryColor.withOpacity(0.5)),
                      ),
                    ),

                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                        boxShadow: const [BoxShadow(color: Colors.black12, spreadRadius: 1, blurRadius: 5)],
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical: Dimensions.paddingSizeDefault),
                      margin: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                      child: Column(children: [

                        (Get.find<SplashController>().configModel!.refEarningStatus == 1 ) ? PortionWidget(
                          icon: Images.referIcon, title: 'refer_and_earn'.tr, route: RouteHelper.getReferAndEarnRoute(),
                        ) : const SizedBox(),

                        (Get.find<SplashController>().configModel!.toggleDmRegistration! && !ResponsiveHelper.isDesktop(context)) ? PortionWidget(
                          icon: Images.dmIcon, title: 'join_as_a_delivery_man'.tr, route: RouteHelper.getDeliverymanRegistrationRoute(),
                        ) : const SizedBox(),

                        (Get.find<SplashController>().configModel!.toggleRestaurantRegistration! && !ResponsiveHelper.isDesktop(context)) ? PortionWidget(
                          icon: Images.storeIcon, title: 'open_store'.tr, hideDivider: true, route: RouteHelper.getRestaurantRegistrationRoute(),
                        ) : const SizedBox(),
                      ]),
                    )
                  ]),

                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                      child: Text(
                        'help_and_support'.tr,
                        style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).primaryColor.withOpacity(0.5)),
                      ),
                    ),

                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                        boxShadow: const [BoxShadow(color: Colors.black12, spreadRadius: 1, blurRadius: 5)],
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical: Dimensions.paddingSizeDefault),
                      margin: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                      child: Column(children: [
                        PortionWidget(icon: Images.chatIcon, title: 'live_chat'.tr, route: RouteHelper.getConversationRoute()),
                        PortionWidget(icon: Images.helpIcon, title: 'help_and_support'.tr, route: RouteHelper.getSupportRoute()),
                        PortionWidget(icon: Images.aboutIcon, title: 'about_us'.tr, route: RouteHelper.getHtmlRoute('about-us')),
                        PortionWidget(icon: Images.termsIcon, title: 'terms_conditions'.tr, route: RouteHelper.getHtmlRoute('terms-and-condition')),
                        PortionWidget(icon: Images.privacyIcon, title: 'privacy_policy'.tr, route: RouteHelper.getHtmlRoute('privacy-policy')),

                        (Get.find<SplashController>().configModel!.refundPolicyStatus == 1 ) ? PortionWidget(
                          icon: Images.refundIcon, title: 'refund_policy'.tr, route: RouteHelper.getHtmlRoute('refund-policy'),
                        ) : const SizedBox(),

                        (Get.find<SplashController>().configModel!.cancellationPolicyStatus == 1 ) ? PortionWidget(
                          icon: Images.cancelationIcon, title: 'cancellation_policy'.tr, route: RouteHelper.getHtmlRoute('cancellation-policy'),
                        ) : const SizedBox(),

                        (Get.find<SplashController>().configModel!.shippingPolicyStatus == 1 ) ? PortionWidget(
                          icon: Images.shippingIcon, title: 'shipping_policy'.tr, hideDivider: true, route: RouteHelper.getHtmlRoute('shipping-policy'),
                        ) : const SizedBox(),

                      ]),
                    )
                  ]),

                  InkWell(
                    onTap: () async {
                      if(Get.find<AuthController>().isLoggedIn()) {
                        Get.dialog(ConfirmationDialogWidget(icon: Images.support, description: 'are_you_sure_to_logout'.tr, isLogOut: true, onYesPressed: () {
                          Get.find<ProfileController>().setForceFullyUserEmpty();
                          Get.find<AuthController>().clearSharedData();
                          Get.find<AuthController>().socialLogout();
                          Get.find<CartController>().clearCartList();
                          Get.find<FavouriteController>().removeFavourites();
                          Get.offAllNamed(RouteHelper.getSignInRoute(RouteHelper.splash));
                        }), useSafeArea: false);
                      }else {
                        Get.find<FavouriteController>().removeFavourites();
                        await Get.toNamed(RouteHelper.getSignInRoute(Get.currentRoute));
                        if(AuthHelper.isLoggedIn()) {
                          profileController.getUserInfo();
                        }
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                        Container(
                          padding: const EdgeInsets.all(2),
                          decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.red),
                          child: Icon(Icons.power_settings_new_sharp, size: 14, color: Theme.of(context).cardColor),
                        ),
                        const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                        Text(Get.find<AuthController>().isLoggedIn() ? 'logout'.tr : 'sign_in'.tr, style: robotoMedium)
                      ]),
                    ),
                  ),

                  const SizedBox(height: Dimensions.paddingSizeOverLarge)

                ]),
              ),
            )),
          ]);
        }
      ),
    );
  }
}
