import 'package:stackfood_multivendor/features/html/controllers/html_controller.dart';
import 'package:stackfood_multivendor/features/html/enums/html_type.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:stackfood_multivendor/common/widgets/custom_app_bar_widget.dart';
import 'package:stackfood_multivendor/common/widgets/footer_view_widget.dart';
import 'package:stackfood_multivendor/common/widgets/menu_drawer_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:universal_html/html.dart' as html;
import 'package:url_launcher/url_launcher_string.dart';
import 'package:flutter_html/flutter_html.dart';

class HtmlViewerScreen extends StatefulWidget {
  final HtmlType htmlType;
  const HtmlViewerScreen({super.key, required this.htmlType});

  @override
  State<HtmlViewerScreen> createState() => _HtmlViewerScreenState();
}

class _HtmlViewerScreenState extends State<HtmlViewerScreen> {
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    Get.find<HtmlController>().getHtmlText(widget.htmlType);
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(title: widget.htmlType == HtmlType.termsAndCondition ? 'terms_conditions'.tr
          : widget.htmlType == HtmlType.aboutUs ? 'about_us'.tr : widget.htmlType == HtmlType.privacyPolicy
          ? 'privacy_policy'.tr :  widget.htmlType == HtmlType.shippingPolicy ? 'shipping_policy'.tr
          : widget.htmlType == HtmlType.refund ? 'refund_policy'.tr :  widget.htmlType == HtmlType.cancellation
          ? 'cancellation_policy'.tr  : 'no_data_found'.tr),
      endDrawer: const MenuDrawerWidget(), endDrawerEnableOpenDragGesture: false,
      body: GetBuilder<HtmlController>(builder: (htmlController) {
        return Center(
          child: htmlController.htmlText != null ? Container(
            height: MediaQuery.of(context).size.height,
            color: Theme.of(context).cardColor,
            child: SingleChildScrollView(
              controller: scrollController,
              padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.isDesktop(context) ? 0 : Dimensions.paddingSizeLarge),
              child: FooterViewWidget(
                child: SizedBox(
                  width: Dimensions.webMaxWidth,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.isDesktop(context) ?  Dimensions.paddingSizeLarge : 0),
                    child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [

                      ResponsiveHelper.isDesktop(context) ? Container(
                        height: 50, alignment: Alignment.center, color: Theme.of(context).cardColor, width: Dimensions.webMaxWidth,
                        child: SelectableText(widget.htmlType == HtmlType.termsAndCondition ? 'terms_conditions'.tr
                            : widget.htmlType == HtmlType.aboutUs ? 'about_us'.tr : widget.htmlType == HtmlType.privacyPolicy
                            ? 'privacy_policy'.tr : widget.htmlType == HtmlType.shippingPolicy ? 'shipping_policy'.tr
                            : widget.htmlType == HtmlType.refund ? 'refund_policy'.tr :  widget.htmlType == HtmlType.cancellation
                            ? 'cancellation_policy'.tr : 'no_data_found'.tr,
                          style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).hintColor),
                        ),
                      ) : const SizedBox(),

                      (htmlController.htmlText!.contains('<ol>') || htmlController.htmlText!.contains('<ul>')) ? HtmlWidget(
                        htmlController.htmlText ?? '',
                        key: Key(widget.htmlType.toString()),
                        onTapUrl: (String url) {
                          return launchUrlString(url, mode: LaunchMode.externalApplication);
                        },
                      ) : SelectableHtml(
                        data: htmlController.htmlText, shrinkWrap: true,
                        onLinkTap: (String? url, RenderContext context, Map<String, String> attributes, element) {
                          if(url!.startsWith('www.')) {
                            url = 'https://$url';
                          }
                          if (kDebugMode) {
                            print('Redirect to url: $url');
                          }
                          html.window.open(url, "_blank");
                        },
                      ),

                    ]),
                  ),
                ),
              ),
            ),
          ) : const CircularProgressIndicator(),
        );
      }),
    );
  }
}