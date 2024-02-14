
import 'package:stackfood_multivendor/features/business/domain/models/business_plan_body.dart';
import 'package:stackfood_multivendor/features/business/domain/models/package_model.dart';

abstract class BusinessServiceInterface{
  Future<PackageModel?> getPackageList();
  Future<String> processesBusinessPlan(String businessPlanStatus, int paymentIndex, int restaurantId, PackageModel? packageModel, String? digitalPaymentName, int activeSubscriptionIndex);
  Future<String> setUpBusinessPlan(BusinessPlanBody businessPlanBody, String? digitalPaymentName, String businessPlanStatus);
}