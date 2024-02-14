import 'package:stackfood_multivendor/features/onboard/domain/models/onboarding_model.dart';

abstract class OnboardServiceInterface {
  Future<List<OnBoardingModel>> getOnBoardingList();
}