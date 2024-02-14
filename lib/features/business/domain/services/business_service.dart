import 'package:stackfood_multivendor/features/order/domain/models/order_model.dart';
import 'package:stackfood_multivendor/features/auth/controllers/auth_controller.dart';
import 'package:stackfood_multivendor/features/business/domain/models/business_plan_body.dart';
import 'package:stackfood_multivendor/features/business/domain/models/package_model.dart';
import 'package:stackfood_multivendor/features/business/domain/reposotories/business_repo_interface.dart';
import 'package:stackfood_multivendor/features/business/widgets/business_payment_method_bottom_sheet_widget.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/helper/route_helper.dart';
import 'package:stackfood_multivendor/common/widgets/custom_snackbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'business_service_interface.dart';
import 'package:universal_html/html.dart' as html;

class BusinessService implements BusinessServiceInterface{
  final BusinessRepoInterface businessRepoInterface;
  BusinessService({required this.businessRepoInterface});

  @override
  Future<PackageModel?> getPackageList() async {
    return await businessRepoInterface.getList();
  }

  @override
  Future<String> processesBusinessPlan(String businessPlanStatus, int paymentIndex, int restaurantId, PackageModel? packageModel, String? digitalPaymentName, int activeSubscriptionIndex) async {
    if (businessPlanStatus == 'payment' && packageModel!.packages!.isNotEmpty) {

      String businessPlan = 'subscription';
      int? packageId = packageModel.packages![activeSubscriptionIndex].id;
      String payment = paymentIndex == 0 ? 'free_trial' : 'paying_now';

      if(paymentIndex == 1 && digitalPaymentName == null) {
        if(ResponsiveHelper.isDesktop(Get.context)) {
          Get.dialog(const Dialog(backgroundColor: Colors.transparent, child: BusinessPaymentMethodBottomSheetWidget()));
        } else {
          showModalBottomSheet(
            context: Get.context!, isScrollControlled: true, backgroundColor: Colors.transparent,
            builder: (con) => const BusinessPaymentMethodBottomSheetWidget(),
          );
        }
      } else {
        businessPlanStatus = await setUpBusinessPlan(BusinessPlanBody(businessPlan: businessPlan,
            packageId: packageId.toString(),
            restaurantId: restaurantId.toString(),
            payment: payment),
          digitalPaymentName, businessPlanStatus,
        );
      }

    } else if(packageModel!.packages!.isEmpty && packageModel.packages!.isEmpty){
      showCustomSnackBar('no_package_found'.tr);
    } else {
      showCustomSnackBar('please Select Any Process');
    }
    return businessPlanStatus;
  }

  @override
  Future<String> setUpBusinessPlan(BusinessPlanBody businessPlanBody, String? digitalPaymentName, String businessPlanStatus) async {
    Response response = await businessRepoInterface.setUpBusinessPlan(businessPlanBody);
    if (response.statusCode == 200) {
      if(response.body['id'] != null) {
        _subscriptionPayment(response.body['id'], digitalPaymentName);
      }else {
        businessPlanStatus = 'complete';
        Future.delayed(const Duration(seconds: 2),()=> Get.offAllNamed(RouteHelper.getInitialRoute()));
      }
    }
    return businessPlanStatus;
  }

  Future<void> _subscriptionPayment(String id, String? digitalPaymentName) async {
    Response response = await businessRepoInterface.subscriptionPayment(id, digitalPaymentName);
    if (response.statusCode == 200) {
      String redirectUrl = response.body['redirect_link'];
      Get.back();
      if(GetPlatform.isWeb) {
        html.window.open(redirectUrl,"_self");
      } else{
        Get.toNamed(RouteHelper.getPaymentRoute(OrderModel(), digitalPaymentName, subscriptionUrl: redirectUrl, guestId: Get.find<AuthController>().getGuestId()));
      }
    }
  }

}