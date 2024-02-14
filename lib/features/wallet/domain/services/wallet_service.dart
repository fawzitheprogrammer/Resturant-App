import 'package:stackfood_multivendor/features/order/domain/models/order_model.dart';
import 'package:stackfood_multivendor/features/wallet/domain/models/fund_bonus_model.dart';
import 'package:stackfood_multivendor/features/wallet/domain/models/wallet_model.dart';
import 'package:stackfood_multivendor/features/wallet/domain/repositories/wallet_repository_interface.dart';
import 'package:stackfood_multivendor/features/wallet/domain/services/wallet_service_interface.dart';
import 'package:stackfood_multivendor/helper/auth_helper.dart';
import 'package:stackfood_multivendor/helper/route_helper.dart';
import 'package:get/get.dart';
import 'package:universal_html/html.dart' as html;

class WalletService implements WalletServiceInterface {
  final WalletRepositoryInterface walletRepositoryInterface;
  WalletService({required this.walletRepositoryInterface});

  @override
  Future<WalletModel?> getWalletTransactionList(String offset, String sortingType) async {
    return await walletRepositoryInterface.getList(offset: int.parse(offset), sortingType: sortingType);
  }

  @override
  Future<void> addFundToWallet(double amount, String paymentMethod) async{
    Response response = await walletRepositoryInterface.addFundToWallet(amount, paymentMethod);
    if (response.statusCode == 200) {
      String redirectUrl = response.body['redirect_link'];
      Get.back();
      if(GetPlatform.isWeb) {
        html.window.open(redirectUrl,"_self");
      } else{
        Get.toNamed(RouteHelper.getPaymentRoute(OrderModel(), '', addFundUrl: redirectUrl, guestId: AuthHelper.getGuestId()));
      }
    }
  }

  @override
  Future<List<FundBonusModel>?> getWalletBonusList() async {
    return await walletRepositoryInterface.getWalletBonusList();
  }

  @override
  Future<void> setWalletAccessToken(String token) {
    return walletRepositoryInterface.setWalletAccessToken(token);
  }

  @override
  String getWalletAccessToken() {
    return walletRepositoryInterface.getWalletAccessToken();
  }

}