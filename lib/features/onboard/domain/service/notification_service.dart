import 'package:stackfood_multivendor/features/onboard/domain/models/onboarding_model.dart';
import 'package:stackfood_multivendor/features/onboard/domain/repository/onboard_repository_interface.dart';
import 'package:stackfood_multivendor/features/onboard/domain/service/onboard_service_interface.dart';

class OnboardService implements OnboardServiceInterface {
  final OnboardRepositoryInterface onboardRepositoryInterface;
  OnboardService({required this.onboardRepositoryInterface});

  @override
  Future<List<OnBoardingModel>> getOnBoardingList() async {
    return await onboardRepositoryInterface.getList();
  }
}