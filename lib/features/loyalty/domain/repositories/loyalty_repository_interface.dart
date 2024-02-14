import 'package:stackfood_multivendor/interface/repository_interface.dart';
import 'package:get/get_connect/http/src/response/response.dart';

abstract class LoyaltyRepositoryInterface extends RepositoryInterface {
  Future<Response> convertPointToWallet({int? point});
  Future<bool> saveEarningPoint(String point);
  String getEarningPint();
}