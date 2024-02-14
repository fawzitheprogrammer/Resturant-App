import 'package:stackfood_multivendor/features/auth/controllers/auth_controller.dart';
import 'package:stackfood_multivendor/features/profile/controllers/profile_controller.dart';
import 'package:stackfood_multivendor/features/profile/widgets/profile_button_widget.dart';
import 'package:stackfood_multivendor/features/profile/widgets/profile_card_widget.dart';
import 'package:stackfood_multivendor/features/profile/widgets/web_profile_widget.dart';
import 'package:stackfood_multivendor/features/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor/features/splash/controllers/theme_controller.dart';
import 'package:stackfood_multivendor/features/auth/widgets/auth_dialog_widget.dart';
import 'package:stackfood_multivendor/helper/date_converter.dart';
import 'package:stackfood_multivendor/helper/price_converter.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/helper/route_helper.dart';
import 'package:stackfood_multivendor/util/app_constants.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/images.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:stackfood_multivendor/common/widgets/confirmation_dialog_widget.dart';
import 'package:stackfood_multivendor/common/widgets/custom_image_widget.dart';
import 'package:stackfood_multivendor/common/widgets/footer_view_widget.dart';
import 'package:stackfood_multivendor/common/widgets/menu_drawer_widget.dart';
import 'package:stackfood_multivendor/common/widgets/web_menu_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _initCall();
  }

  void _initCall() {
    if(Get.find<AuthController>().isLoggedIn() && Get.find<ProfileController>().userInfoModel == null) {
      Get.find<ProfileController>().getUserInfo();
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDesktop = ResponsiveHelper.isDesktop(context);
    bool isLoggedIn = Get.find<AuthController>().isLoggedIn();
    final bool showWalletCard = Get.find<SplashController>().configModel!.customerWalletStatus == 1
        || Get.find<SplashController>().configModel!.loyaltyPointStatus == 1;

    return Scaffold(
      appBar: isDesktop ? const WebMenuBar() : null,
      endDrawer: const MenuDrawerWidget(), endDrawerEnableOpenDragGesture: false,
      backgroundColor: isDesktop ? Theme.of(context).colorScheme.background : Theme.of(context).cardColor,
      body: GetBuilder<ProfileController>(builder: (profileController) {
        return (isLoggedIn && profileController.userInfoModel == null) ? const Center(
          child: CircularProgressIndicator(),
        ) : Center(
          child: SingleChildScrollView(
            controller: scrollController,
            child: FooterViewWidget(
              minHeight: isLoggedIn ?  isDesktop ? 0.4 : 0.6 : 0.35,
              child: (isLoggedIn && isDesktop) ? const WebProfileWidget() : Container(
                color: Theme.of(context).primaryColor.withOpacity(0.2),
                width: Dimensions.webMaxWidth, height: context.height,
                child: Center(
                  child: Column(children: [

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical: Dimensions.paddingSizeExtraLarge),
                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        !isDesktop ? IconButton(
                          onPressed: () => Get.back(),
                          icon: const Icon(Icons.arrow_back_ios),
                        ) : const SizedBox(),

                        Text('profile'.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge)),

                        const SizedBox(width: 50),
                      ]),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraLarge, vertical: Dimensions.paddingSizeExtraLarge),
                      child: Row(children: [

                        ClipOval(child: CustomImageWidget(
                          placeholder: Images.guestIcon,
                          image: '${Get.find<SplashController>().configModel!.baseUrls!.customerImageUrl}'
                              '/${(profileController.userInfoModel != null && isLoggedIn) ? profileController.userInfoModel!.image : ''}',
                          height: 70, width: 70, fit: BoxFit.cover,
                        )),
                        const SizedBox(width: Dimensions.paddingSizeDefault),

                        Expanded(
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text(
                              isLoggedIn ? '${profileController.userInfoModel!.fName} ${profileController.userInfoModel!.lName}' : 'guest_user'.tr,
                              style: robotoBold.copyWith(fontSize: Dimensions.fontSizeExtraLarge),
                            ),
                            const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                            isLoggedIn ? Text(
                              '${'joined'.tr} ${DateConverter.containTAndZToUTCFormat(profileController.userInfoModel!.createdAt!)}',
                              style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).primaryColor),
                            ) : InkWell(
                              onTap: () async {
                                if(!isDesktop) {
                                  await Get.toNamed(RouteHelper.getSignInRoute(Get.currentRoute));
                                }else{
                                  Get.dialog(const Center(child: AuthDialogWidget(exitFromApp: false, backFromThis: false))).then((value) {
                                    _initCall();
                                    setState(() {});
                                  });
                                }
                              },
                              child: Text(
                                'login_to_view_all_feature'.tr,
                                style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).primaryColor),
                              ),
                            ),
                          ]),
                        ),

                        isLoggedIn ? InkWell(
                          onTap: ()=> Get.toNamed(RouteHelper.getUpdateProfileRoute()),
                          child: Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Theme.of(context).cardColor,
                                boxShadow: [BoxShadow(color: Theme.of(context).primaryColor.withOpacity(0.05), blurRadius: 5, spreadRadius: 1, offset: const Offset(3, 3))]
                            ),
                            padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                            child: const Icon(Icons.edit_outlined, size: 24, color: Colors.blue),
                          ),
                        ) : InkWell(
                          onTap: () async {
                            if(!isDesktop) {
                              await Get.toNamed(RouteHelper.getSignInRoute(Get.currentRoute));
                            }else{
                              Get.dialog(const Center(child: AuthDialogWidget(exitFromApp: false, backFromThis: false))).then((value) {
                                _initCall();
                                setState(() {});
                              });
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                              color: Theme.of(context).primaryColor,
                            ),
                            padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall, horizontal: Dimensions.paddingSizeLarge),
                            child: Text(
                              'login'.tr, style: robotoMedium.copyWith(color: Theme.of(context).cardColor),
                            ),
                          ),
                        )

                      ]),
                    ),

                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(Dimensions.radiusExtraLarge)),
                          color: Theme.of(context).colorScheme.background,
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical: Dimensions.paddingSizeDefault),
                        child: Column(children: [

                          const SizedBox(height: Dimensions.paddingSizeLarge),
                          (showWalletCard && isLoggedIn) ? Row(children: [

                            Get.find<SplashController>().configModel!.loyaltyPointStatus == 1 ? Expanded(child: ProfileCardWidget(
                              image: Images.loyaltyIcon,
                              data: profileController.userInfoModel!.loyaltyPoint != null ? profileController.userInfoModel!.loyaltyPoint.toString() : '0',
                              title: 'loyalty_points'.tr,
                            )) : const SizedBox(),

                            SizedBox(width: Get.find<SplashController>().configModel!.loyaltyPointStatus == 1 ? Dimensions.paddingSizeSmall : 0),

                            isLoggedIn ?  Expanded(child: ProfileCardWidget(
                              image: Images.shoppingBagIcon,
                              data: profileController.userInfoModel!.orderCount.toString(),
                              title: 'total_order'.tr,
                            )) : const SizedBox(),

                            SizedBox(width: Get.find<SplashController>().configModel!.customerWalletStatus == 1 ? Dimensions.paddingSizeSmall : 0),

                            Get.find<SplashController>().configModel!.customerWalletStatus == 1 ? Expanded(child: ProfileCardWidget(
                              image: Images.walletProfile,
                              data: PriceConverter.convertPrice(profileController.userInfoModel!.walletBalance),
                              title: 'wallet_balance'.tr,
                            )) : const SizedBox(),

                          ]) : const SizedBox(),

                          const SizedBox(height: Dimensions.paddingSizeDefault),

                          ProfileButtonWidget(icon: Icons.tonality_outlined, title: 'dark_mode'.tr, isButtonActive: Get.isDarkMode, onTap: () {
                            Get.find<ThemeController>().toggleTheme();
                          }),
                          const SizedBox(height: Dimensions.paddingSizeSmall),

                          isLoggedIn ? GetBuilder<AuthController>(builder: (authController) {
                            return ProfileButtonWidget(
                              icon: Icons.notifications, title: 'notification'.tr,
                              isButtonActive: authController.notification, onTap: () {
                              authController.setNotificationActive(!authController.notification);
                            },
                            );
                          }) : const SizedBox(),
                          SizedBox(height: isLoggedIn ? Dimensions.paddingSizeSmall : 0),

                          isLoggedIn ? profileController.userInfoModel!.socialId == null ? ProfileButtonWidget(icon: Icons.lock, title: 'change_password'.tr, onTap: () {
                            Get.toNamed(RouteHelper.getResetPasswordRoute('', '', 'password-change'));
                          }) : const SizedBox() : const SizedBox(),
                          SizedBox(height: isLoggedIn ? profileController.userInfoModel!.socialId == null ? Dimensions.paddingSizeSmall : 0 : 0),

                          isLoggedIn ? ProfileButtonWidget(
                            icon: Icons.delete,
                            iconImage: Images.profileDelete,
                            title: 'delete_account'.tr,
                            onTap: () {
                              Get.dialog(ConfirmationDialogWidget(
                                isDelete: true,
                                icon: Images.warningIcon,
                                title: 'are_you_sure'.tr,
                                titleColor: Theme.of(context).textTheme.bodyLarge!.color,
                                description: 'it_will_remove_your_all_information'.tr, isLogOut: true,
                                onYesPressed: () => profileController.removeUser(),
                              ), useSafeArea: false);
                            },
                          ) : const SizedBox(),
                          SizedBox(height: isLoggedIn ? Dimensions.paddingSizeLarge : 0),

                          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                            Text('${'version'.tr}:', style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall)),
                            const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                            Text(AppConstants.appVersion.toString(), style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeExtraSmall)),
                          ]),
                        ]),
                      ),
                    ),

                  ]),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
