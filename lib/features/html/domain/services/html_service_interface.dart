import 'package:stackfood_multivendor/features/html/enums/html_type.dart';

abstract class HtmlServiceInterface{
  Future<String?> getHtmlText(HtmlType htmlType, String languageCode);
}