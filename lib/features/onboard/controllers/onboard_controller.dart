import 'package:stackfood_multivendor/features/onboard/domain/models/onboarding_model.dart';
import 'package:stackfood_multivendor/features/onboard/domain/service/onboard_service_interface.dart';
import 'package:get/get.dart';

class OnBoardingController extends GetxController implements GetxService {
  final OnboardServiceInterface onboardServiceInterface;
  OnBoardingController({required this.onboardServiceInterface});

  List<OnBoardingModel>? _onBoardingList;
  List<OnBoardingModel>? get onBoardingList => _onBoardingList;

  int get selectedIndex => _selectedIndex;
  int _selectedIndex = 0;

  void changeSelectIndex(int index) {
    _selectedIndex = index;
    update();
  }

  void getOnBoardingList() async {
    _onBoardingList = await onboardServiceInterface.getOnBoardingList();
    update();
  }

}