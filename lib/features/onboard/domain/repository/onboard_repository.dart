import 'package:stackfood_multivendor/features/onboard/domain/models/onboarding_model.dart';
import 'package:stackfood_multivendor/util/images.dart';
import 'package:get/get_utils/get_utils.dart';
import 'onboard_repository_interface.dart';

class OnboardRepository implements OnboardRepositoryInterface {

  @override
  Future add(value) {
    throw UnimplementedError();
  }

  @override
  Future delete(int? id) {
    throw UnimplementedError();
  }

  @override
  Future get(String? id) {
    throw UnimplementedError();
  }

  @override
  Future<List<OnBoardingModel>> getList({int? offset}) async{
    List<OnBoardingModel> onBoardingList = [
      OnBoardingModel(Images.onboard_1, 'on_boarding_1_title'.tr, 'on_boarding_1_description'.tr),
      OnBoardingModel(Images.onboard_2, 'on_boarding_2_title'.tr, 'on_boarding_2_description'.tr),
      OnBoardingModel(Images.onboard_3, 'on_boarding_3_title'.tr, 'on_boarding_3_description'.tr),
    ];
    return onBoardingList;
  }

  @override
  Future update(Map<String, dynamic> body, int? id) {
    throw UnimplementedError();
  }

}