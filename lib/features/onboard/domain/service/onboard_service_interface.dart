import 'package:swift_tech_resto/features/onboard/domain/models/onboarding_model.dart';

abstract class OnboardServiceInterface {
  Future<List<OnBoardingModel>> getOnBoardingList();
}
