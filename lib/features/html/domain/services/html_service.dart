import 'package:stackfood_multivendor/features/html/domain/repositories/html_repository_interface.dart';
import 'package:stackfood_multivendor/features/html/domain/services/html_service_interface.dart';
import 'package:stackfood_multivendor/features/html/enums/html_type.dart';
import 'package:get/get_connect.dart';

class HtmlService implements HtmlServiceInterface {
  final HtmlRepositoryInterface htmlRepositoryInterface;
  HtmlService({required this.htmlRepositoryInterface});

  @override
  Future<String?> getHtmlText(HtmlType htmlType, String languageCode) async {
    String? htmlText;
    Response response = await htmlRepositoryInterface.getHtmlText(htmlType, languageCode);
    if (response.statusCode == 200) {
      if(response.body != null && response.body.isNotEmpty && response.body is String){
        htmlText = response.body;
      }else{
        htmlText = '';
      }
      if(htmlText != null && htmlText.isNotEmpty) {
        htmlText = htmlText.replaceAll('href=', 'target="_blank" href=');
      }else {
        htmlText = '';
      }
    }
    return htmlText;
  }
}