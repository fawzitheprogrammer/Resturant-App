import 'package:swift_tech_resto/features/html/enums/html_type.dart';

abstract class HtmlServiceInterface {
  Future<String?> getHtmlText(HtmlType htmlType, String languageCode);
}
