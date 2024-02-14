import 'package:stackfood_multivendor/features/category/controllers/category_controller.dart';
import 'package:stackfood_multivendor/features/category/domain/models/category_model.dart';
import 'package:stackfood_multivendor/features/interest/domain/services/interest_service_interface.dart';
import 'package:get/get.dart';

class InterestController extends GetxController implements GetxService {
  final InterestServiceInterface interestServiceInterface;

  InterestController({required this.interestServiceInterface});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<CategoryModel>? _categoryList;
  List<CategoryModel>? get categoryList => _categoryList;

  List<bool>? _interestCategorySelectedList;
  List<bool>? get interestCategorySelectedList => _interestCategorySelectedList;

  Future<void> getCategoryList(bool reload) async {
    if(Get.find<CategoryController>().categoryList == null || Get.find<CategoryController>().categoryList!.isEmpty) {
      await Get.find<CategoryController>().getCategoryList(false);
    }
    _categoryList = Get.find<CategoryController>().categoryList;
    _interestCategorySelectedList = interestServiceInterface.processCategorySelectedList(_categoryList);

    update();
  }

  void addInterestSelection(int index) {
    _interestCategorySelectedList![index] = !_interestCategorySelectedList![index];
    update();
  }

  Future<bool> saveInterest(List<int?> interests) async {
    _isLoading = true;
    update();
    bool isSuccess = await interestServiceInterface.saveUserInterests(interests);
    _isLoading = false;
    update();
    return isSuccess;
  }

}