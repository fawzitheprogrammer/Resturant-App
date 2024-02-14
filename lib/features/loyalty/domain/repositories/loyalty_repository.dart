import 'package:stackfood_multivendor/api/api_client.dart';
import 'package:stackfood_multivendor/features/loyalty/domain/repositories/loyalty_repository_interface.dart';
import 'package:stackfood_multivendor/features/wallet/domain/models/wallet_model.dart';
import 'package:stackfood_multivendor/util/app_constants.dart';
import 'package:get/get_connect.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoyaltyRepository implements LoyaltyRepositoryInterface {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;
  LoyaltyRepository({required this.apiClient, required this.sharedPreferences});

  @override
  Future<WalletModel?> getList({int? offset}) async {
    WalletModel? loyaltyModel;
    Response response = await apiClient.getData('${AppConstants.loyaltyTransactionUri}?offset=$offset&limit=10');
    if (response.statusCode == 200) {
      loyaltyModel = WalletModel.fromJson(response.body);
    }
    return loyaltyModel;
  }

  @override
  Future<Response> convertPointToWallet({int? point}) async {
    return await apiClient.postData(AppConstants.loyaltyPointTransferUri, {"point": point});
  }

  @override
  Future<bool> saveEarningPoint(String point) async {
    return await sharedPreferences.setString(AppConstants.earnPoint, point);
  }

  @override
  String getEarningPint() {
    return sharedPreferences.getString(AppConstants.earnPoint) ?? "";
  }

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
  Future update(Map<String, dynamic> body, int? id) {
    throw UnimplementedError();
  }

}