import 'package:stackfood_multivendor/features/wallet/domain/models/wallet_filter_body_model.dart';
import 'package:stackfood_multivendor/features/wallet/domain/models/wallet_model.dart';
import 'package:stackfood_multivendor/features/wallet/domain/models/fund_bonus_model.dart';
import 'package:stackfood_multivendor/features/wallet/domain/services/wallet_service_interface.dart';
import 'package:stackfood_multivendor/util/app_constants.dart';
import 'package:get/get.dart';

class WalletController extends GetxController implements GetxService {
  final WalletServiceInterface walletServiceInterface;

  WalletController({required this.walletServiceInterface});

  List<Transaction>? _transactionList;
  List<Transaction>? get transactionList => _transactionList;

  List<String> _offsetList = [];
  int _offset = 1;
  int get offset => _offset;

  int? _pageSize;
  int? get popularPageSize => _pageSize;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _digitalPaymentName;
  String? get digitalPaymentName => _digitalPaymentName;

  bool _amountEmpty = true;
  bool get amountEmpty => _amountEmpty;

  List<FundBonusModel>? _fundBonusList;
  List<FundBonusModel>? get fundBonusList => _fundBonusList;

  int _currentIndex = 0;
  int get currentIndex => _currentIndex;

  String _type = 'all';
  String get type => _type;

  List<WalletFilterBodyModel> _walletFilterList = [];
  List<WalletFilterBodyModel> get walletFilterList => _walletFilterList;


  void setWalletFilerType(String type, {bool isUpdate = true}) {
    _type = type;
    if(isUpdate) {
      update();
    }
  }

  void insertFilterList(){
    _walletFilterList = [];
    for(int i=0; i < AppConstants.walletTransactionSortingList.length; i++){
      _walletFilterList.add(WalletFilterBodyModel.fromJson(AppConstants.walletTransactionSortingList[i]));
    }
  }

  void changeDigitalPaymentName(String name, {bool isUpdate = true}){
    _digitalPaymentName = name;
    if(isUpdate) {
      update();
    }
  }

  void isTextFieldEmpty(String value, {bool isUpdate = true}){
    _amountEmpty = value.isNotEmpty;
    if(isUpdate) {
      update();
    }
  }

  void setOffset(int offset) {
    _offset = offset;
  }
  void showBottomLoader() {
    _isLoading = true;
    update();
  }

  Future<void> getWalletTransactionList(String offset, bool reload, String walletType) async {
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
      WalletModel? walletModel = await walletServiceInterface.getWalletTransactionList(offset, walletType);
      if (walletModel != null) {
        if (offset == '1') {
          _transactionList = [];
        }
        _transactionList!.addAll(walletModel.data!);
        _pageSize = walletModel.totalSize;

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

  Future<void> addFundToWallet(double amount, String paymentMethod) async {
    _isLoading = true;
    update();
    await walletServiceInterface.addFundToWallet(amount, paymentMethod);
    _isLoading = false;
    update();
  }

  Future<void> getWalletBonusList({bool isUpdate = true}) async {
    _isLoading = true;
    if(isUpdate) {
      update();
    }
    _fundBonusList = await walletServiceInterface.getWalletBonusList();
    _isLoading = false;
    update();
  }

  void setCurrentIndex(int index, bool notify) {
    _currentIndex = index;
    if(notify) {
      update();
    }
  }

  void setWalletAccessToken(String accessToken){
    walletServiceInterface.setWalletAccessToken(accessToken);
  }

  String getWalletAccessToken (){
    return walletServiceInterface.getWalletAccessToken();
  }

}