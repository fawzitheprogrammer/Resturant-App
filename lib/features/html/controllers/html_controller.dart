import 'package:stackfood_multivendor/features/language/controllers/localization_controller.dart';
import 'package:stackfood_multivendor/features/html/domain/services/html_service_interface.dart';
import 'package:stackfood_multivendor/features/html/enums/html_type.dart';
import 'package:get/get.dart';

class HtmlController extends GetxController implements GetxService {
  final HtmlServiceInterface htmlServiceInterface;

  HtmlController({required this.htmlServiceInterface});

  String? _htmlText;
  String? get htmlText => _htmlText;

  Future<void> getHtmlText(HtmlType htmlType) async {
    _htmlText = await htmlServiceInterface.getHtmlText(htmlType, Get.find<LocalizationController>().locale.languageCode);
    update();
  }

}