import 'package:stackfood_multivendor/features/loyalty/domain/services/loyalty_service_interface.dart';
import 'package:stackfood_multivendor/features/profile/controllers/profile_controller.dart';
import 'package:stackfood_multivendor/features/wallet/domain/models/wallet_model.dart';
import 'package:stackfood_multivendor/common/widgets/custom_snackbar_widget.dart';
import 'package:get/get.dart';

class LoyaltyController extends GetxController implements GetxService {
  final LoyaltyServiceInterface loyaltyServiceInterface;

  LoyaltyController({required this.loyaltyServiceInterface});

  List<Transaction>? _transactionList;
  List<Transaction>? get transactionList => _transactionList;

  List<String> _offsetList = [];
  int _offset = 1;
  int get offset => _offset;

  int? _pageSize;
  int? get popularPageSize => _pageSize;

  bool _isLoading = false;
  bool get isLoading => _isLoading;


  Future<void> getLoyaltyTransactionList(String offset, bool reload) async {
    if(offset == '1' || reload) {
      _offsetList = [];
      _offset = 1;
      _transactionList = null;
      if(reload) {
        update();
      }

    }
    if (!_offsetList.contains(offset)) {
      _offsetList.add(offset);
      WalletModel? transactionModel = await loyaltyServiceInterface.getLoyaltyTransactionList(offset);
      if (transactionModel != null) {
        if (offset == '1') {
          _transactionList = [];
        }
        _transactionList!.addAll(transactionModel.data!);
        _pageSize = transactionModel.totalSize;

        _isLoading = false;
        update();
      }
    } else {
      if(isLoading) {
        _isLoading = false;
        update();
      }
    }
  }

  void setOffset(int offset) {
    _offset = offset;
  }

  void showBottomLoader() {
    _isLoading = true;
    update();
  }

  Future<void> convertPointToWallet(int point) async {
    _isLoading = true;
    update();
    Response response = await loyaltyServiceInterface.convertPointToWallet(point);
    if(response.statusCode == 200) {
      Get.back();
      getLoyaltyTransactionList('1', true);
      Get.find<ProfileController>().getUserInfo();
      showCustomSnackBar('converted_successfully_transfer_to_your_wallet'.tr, isError: false);
    }
    _isLoading = false;
    update();
  }

  void saveEarningPoint(String point){
    loyaltyServiceInterface.saveEarningPoint(point);
  }

  String getEarningPint() {
    return loyaltyServiceInterface.getEarningPint();
  }

}