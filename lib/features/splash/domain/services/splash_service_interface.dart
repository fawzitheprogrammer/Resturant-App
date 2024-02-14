import 'package:stackfood_multivendor/features/splash/domain/models/config_model.dart';
import 'package:get/get_connect/http/src/response/response.dart';

abstract class SplashServiceInterface {
  Future<Response> getConfigData();
  ConfigModel? prepareConfigData(Response response);
  Future<bool> initSharedData();
  bool? showIntro();
  void disableIntro();
  Future<void> saveCookiesData(bool data);
  bool getCookiesData();
  void cookiesStatusChange(String? data);
  bool getAcceptCookiesStatus(String data);
  Future<bool> subscribeMail(String email);
  void toggleTheme(bool darkTheme);
  Future<bool> loadCurrentTheme();
}