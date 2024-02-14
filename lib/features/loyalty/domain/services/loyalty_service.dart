import 'package:stackfood_multivendor/features/loyalty/domain/repositories/loyalty_repository_interface.dart';
import 'package:stackfood_multivendor/features/loyalty/domain/services/loyalty_service_interface.dart';
import 'package:stackfood_multivendor/features/wallet/domain/models/wallet_model.dart';
import 'package:get/get_connect.dart';

class LoyaltyService implements LoyaltyServiceInterface {
final LoyaltyRepositoryInterface loyaltyRepositoryInterface;
LoyaltyService({required this.loyaltyRepositoryInterface});

  @override
  Future<WalletModel?> getLoyaltyTransactionList(String offset) async {
    return await loyaltyRepositoryInterface.getList(offset: int.parse(offset));
  }

  @override
  Future<Response> convertPointToWallet(int point) async {
    return await loyaltyRepositoryInterface.convertPointToWallet(point: point);
  }

  @override
  void saveEarningPoint(String point) async {
    await loyaltyRepositoryInterface.saveEarningPoint(point);
  }

  @override
  String getEarningPint() {
    return loyaltyRepositoryInterface.getEarningPint();
  }

}