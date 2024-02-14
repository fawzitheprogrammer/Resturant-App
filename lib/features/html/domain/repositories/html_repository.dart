import 'package:stackfood_multivendor/api/api_client.dart';
import 'package:stackfood_multivendor/features/html/domain/repositories/html_repository_interface.dart';
import 'package:stackfood_multivendor/features/html/enums/html_type.dart';
import 'package:stackfood_multivendor/util/app_constants.dart';
import 'package:get/get_connect/http/src/response/response.dart';

class HtmlRepository implements HtmlRepositoryInterface {
  final ApiClient apiClient;
  HtmlRepository({required this.apiClient});

  @override
  Future<Response> getHtmlText(HtmlType htmlType, String languageCode) async {
    return await apiClient.getData(
      htmlType == HtmlType.termsAndCondition ? AppConstants.termsAndConditionUri
          : htmlType == HtmlType.privacyPolicy ? AppConstants.privacyPolicyUri : htmlType == HtmlType.aboutUs
          ? AppConstants.aboutUsUri : htmlType == HtmlType.shippingPolicy ? AppConstants.shippingPolicyUri
          : htmlType == HtmlType.cancellation ? AppConstants.cancellationUri : AppConstants.refundUri,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        AppConstants.localizationKey: languageCode,
      },
    );
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
  Future getList({int? offset}) {
    throw UnimplementedError();
  }

  @override
  Future update(Map<String, dynamic> body, int? id) {
    throw UnimplementedError();
  }

}