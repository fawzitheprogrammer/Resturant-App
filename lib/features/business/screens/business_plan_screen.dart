import 'package:card_swiper/card_swiper.dart';
import 'package:stackfood_multivendor/common/widgets/confirmation_dialog_widget.dart';
import 'package:stackfood_multivendor/features/business/widgets/payment_cart_widget.dart';
import 'package:stackfood_multivendor/features/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor/features/auth/widgets/registration_stepper_widget.dart';
import 'package:stackfood_multivendor/features/business/controllers/business_controller.dart';
import 'package:stackfood_multivendor/features/business/domain/models/package_model.dart';
import 'package:stackfood_multivendor/features/business/widgets/base_card_widget.dart';
import 'package:stackfood_multivendor/features/business/widgets/business_payment_method_bottom_sheet_widget.dart';
import 'package:stackfood_multivendor/features/business/widgets/subscription_card_widget.dart';
import 'package:stackfood_multivendor/features/business/widgets/success_widget.dart';
import 'package:stackfood_multivendor/helper/color_coverter.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/images.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:stackfood_multivendor/common/widgets/custom_app_bar_widget.dart';
import 'package:stackfood_multivendor/common/widgets/custom_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BusinessPlanScreen extends StatefulWidget {
  final int restaurantId;
  const BusinessPlanScreen({super.key, required this.restaurantId});

  @override
  State<BusinessPlanScreen> createState() => _BusinessPlanScreenState();
}

class _BusinessPlanScreenState extends State<BusinessPlanScreen> {

  final bool _canBack = GetPlatform.isWeb ? true : false;
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    Get.find<BusinessController>().resetBusiness();
    Get.find<BusinessController>().getPackageList(isUpdate: false);
    Get.find<BusinessController>().changeDigitalPaymentName(null, canUpdate: false);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BusinessController>(
      builder: (businessController) {
        return PopScope(
          canPop: Navigator.canPop(context),
          onPopInvoked: (val) async{
            if(_canBack) {
            }else {
              _showBackPressedDialogue('your_business_plan_not_setup_yet'.tr);
            }
          },
          child: Scaffold(
            appBar: CustomAppBarWidget(title: 'business_plan'.tr, isBackButtonExist: false),
            body: businessController.businessPlanStatus == 'complete' ? const SuccessWidget() : Center(
              child: Column(children: [

                const SizedBox(height: Dimensions.paddingSizeDefault),
                SizedBox(
                  width: Dimensions.webMaxWidth,
                  child: RegistrationStepperWidget(status: businessController.businessPlanStatus),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: SizedBox(
                      width: Dimensions.webMaxWidth,
                      child: Center(
                        child: Column(children: [


                          businessController.businessPlanStatus != 'payment' ? Column(children: [

                            Center(child: Text('choose_your_business_plan'.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeDefault))),
                            const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
                              child: Row(children: [
                                Get.find<SplashController>().configModel!.businessPlan!.commission != 0 ? Expanded(
                                  child: BaseCardWidget(businessController: businessController, title: 'commission_base'.tr,
                                      index: 0, onTap: ()=> businessController.setBusiness(0)),
                                ) : const SizedBox(),
                                const SizedBox(width: Dimensions.paddingSizeDefault),

                                Get.find<SplashController>().configModel!.businessPlan!.subscription != 0 ? Expanded(
                                  child: BaseCardWidget(businessController: businessController, title: 'subscription_base'.tr,
                                      index: 1, onTap: ()=> businessController.setBusiness(1)),
                                ) : const SizedBox(),
                              ]),
                            ),
                            const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                            businessController.businessIndex == 0 ? Padding(
                              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
                              child: Text(
                                "${'restaurant_will_pay'.tr} ${Get.find<SplashController>().configModel!.adminCommission}% ${'commission_to'.tr} ${Get.find<SplashController>().configModel!.businessName} ${'from_each_order_You_will_get_access_of_all'.tr}",
                                style: robotoRegular, textAlign: TextAlign.start, textScaler: const TextScaler.linear(1.1),
                              ),
                            ) : Column(children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
                                child: Text(
                                  'run_restaurant_by_purchasing_subscription_packages'.tr,
                                  style: robotoRegular, textAlign: TextAlign.start,
                                ),
                              ),

                              businessController.packageModel != null ? SizedBox(
                                height: ResponsiveHelper.isDesktop(context) ? 700 : 600,
                                child: (businessController.packageModel!.packages!.isNotEmpty && businessController.packageModel!.packages!.isNotEmpty) ? Swiper(

                                  itemCount: businessController.packageModel!.packages!.length,
                                  itemWidth: ResponsiveHelper.isDesktop(context) ? 400 : context.width * 0.8,
                                  itemHeight: 600.0,
                                  layout: SwiperLayout.STACK,
                                  onIndexChanged: (index){
                                    businessController.selectSubscriptionCard(index);
                                  },
                                  itemBuilder: (BuildContext context, int index){
                                    Packages package = businessController.packageModel!.packages![index];

                                    Color color = ColorConverter.stringToColor(package.color);

                                    return GetBuilder<BusinessController>(
                                        builder: (businessController) {

                                          return Stack(clipBehavior: Clip.none, children: [

                                            Container(
                                              decoration: BoxDecoration(
                                                color: Theme.of(context).cardColor,
                                                borderRadius: BorderRadius.circular(Dimensions.radiusExtraLarge),
                                                boxShadow: [BoxShadow(color: Colors.grey[Get.isDarkMode ? 800 : 200]!, spreadRadius: 1, blurRadius: 10)],
                                              ),
                                              padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                                              margin: const EdgeInsets.only(top: Dimensions.paddingSizeLarge, bottom: Dimensions.paddingSizeExtraSmall),
                                              child: SubscriptionCardWidget(index: index, package: package, color: color),
                                            ),

                                            businessController.activeSubscriptionIndex == index ? Positioned(
                                              top: 5, right: -10,
                                              child: Container(
                                                height: 40, width: 40,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(50),
                                                  color: color, border: Border.all(color: Theme.of(context).cardColor, width: 2),
                                                ),
                                                child: Icon(Icons.check, color: Theme.of(context).cardColor),
                                              ),
                                            ) : const SizedBox(),

                                          ]);
                                        }
                                    );
                                  },
                                ) : Center(child: Column(mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(Images.emptyFood, height: 150),
                                      const SizedBox(height: Dimensions.paddingSizeLarge),
                                      Text('no_package_available'.tr, style: robotoMedium),
                                    ]),
                                ),
                              ) : const CircularProgressIndicator(),

                              const SizedBox(height: Dimensions.paddingSizeLarge),

                            ]),
                          ]) : Padding(
                            padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                            child: Column(children: [

                              Get.find<SplashController>().configModel!.freeTrialPeriodStatus == 1
                                  ? PaymentCartWidget(
                                  title: '${'continue_with'.tr} ${Get.find<SplashController>().configModel!.freeTrialPeriodDay} ${'days_free_trial'.tr}',
                                  index: 0,
                                  onTap: (){
                                    businessController.setPaymentIndex(0);
                                  }) : const SizedBox(),

                              const SizedBox(height: Dimensions.paddingSizeOverLarge),

                              PaymentCartWidget(
                                title: businessController.digitalPaymentName != null ? businessController.digitalPaymentName!.toString().replaceAll('_', ' ') : 'pay_online'.tr,
                                index: 1,
                                onTap: () {
                                  businessController.setPaymentIndex(1);

                                  if(ResponsiveHelper.isDesktop(context)) {
                                    Get.dialog(const Dialog(backgroundColor: Colors.transparent, child: BusinessPaymentMethodBottomSheetWidget()));
                                  } else {
                                    showModalBottomSheet(
                                      context: context, isScrollControlled: true, backgroundColor: Colors.transparent,
                                      builder: (con) => const BusinessPaymentMethodBottomSheetWidget(),
                                    );
                                  }
                                },
                              ),
                            ]),
                          ),
                        ]),
                      ),
                    ),
                  ),
                ),

                SizedBox(
                  width: Dimensions.webMaxWidth,
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical: Dimensions.paddingSizeSmall),
                      child: !businessController.isLoading ? Row(children: [
                        (businessController.businessPlanStatus == 'payment') ? Expanded(
                          child: InkWell(
                            onTap: () {
                              if(businessController.businessPlanStatus != 'payment'){
                                _showBackPressedDialogue('your_business_plan_not_setup_yet'.tr);
                              }else{
                                businessController.setBusinessStatus('business');
                                businessController.changeDigitalPaymentName(null);
                                if(!businessController.isFirstTime){
                                  businessController.changeFirstTimeStatus();
                                }
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                              child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                const Icon(Icons.keyboard_double_arrow_left),
                                const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                                Text("back".tr, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeLarge),),
                              ]),
                            ),
                          ),
                        ) : const SizedBox(),
                        SizedBox(width: (businessController.businessPlanStatus == 'payment') ? Dimensions.paddingSizeExtraSmall : 0),

                        businessController.businessIndex == 0 || (businessController.businessIndex == 1 && businessController.packageModel!.packages!.isNotEmpty) ? Expanded(child: CustomButtonWidget(
                          buttonText: 'next'.tr,
                          onPressed: () => businessController.submitBusinessPlan(restaurantId: widget.restaurantId),
                        )) : const SizedBox(),
                      ]) : const Center(child: CircularProgressIndicator()),
                    ),
                  ),
                )
              ]),
            ),
          ),
        );
      }
    );
  }

  void _showBackPressedDialogue(String title){
    Get.dialog(ConfirmationDialogWidget(icon: Images.support,
      title: title,
      description: 'are_you_sure_to_go_back'.tr, isLogOut: true,
      onYesPressed: () {
        if(Get.isDialogOpen!){
          Get.back();
        }
        Get.back();
      },
    ), useSafeArea: false);
  }

}

