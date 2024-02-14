import 'package:stackfood_multivendor/interface/repository_interface.dart';
import 'package:get/get_connect/http/src/response/response.dart';

abstract class SplashRepositoryInterface extends RepositoryInterface {
  Future<Response> getConfigData();
  Future<bool> initSharedData();
  void disableIntro();
  bool? showIntro();
  bool getSavedCookiesData();
  Future<void> saveCookiesData(bool data);
  void cookiesStatusChange(String? data);
  bool getAcceptCookiesStatus(String data);
  Future<Response> subscribeEmail(String email);
  void setThemeStatusSharedPref(bool darkTheme);
  Future<bool> getCurrentThemeSharedPref();
}