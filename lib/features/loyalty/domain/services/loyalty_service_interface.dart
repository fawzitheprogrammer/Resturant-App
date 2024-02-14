import 'package:stackfood_multivendor/features/wallet/domain/models/wallet_model.dart';
import 'package:get/get_connect/http/src/response/response.dart';

abstract class LoyaltyServiceInterface {
  Future<WalletModel?> getLoyaltyTransactionList(String offset);
  Future<Response> convertPointToWallet(int point);
  void saveEarningPoint(String point);
  String getEarningPint();
}