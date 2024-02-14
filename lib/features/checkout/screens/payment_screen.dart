import 'dart:async';
import 'package:stackfood_multivendor/features/checkout/widgets/payment_failed_dialog.dart';
import 'package:stackfood_multivendor/features/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor/features/order/domain/models/order_model.dart';
import 'package:stackfood_multivendor/features/location/domain/models/zone_response_model.dart';
import 'package:stackfood_multivendor/features/loyalty/controllers/loyalty_controller.dart';
import 'package:stackfood_multivendor/features/wallet/widgets/fund_payment_dialog_widget.dart';
import 'package:stackfood_multivendor/helper/address_helper.dart';
import 'package:stackfood_multivendor/helper/route_helper.dart';
import 'package:stackfood_multivendor/util/app_constants.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/common/widgets/custom_app_bar_widget.dart';
import 'package:stackfood_multivendor/common/widgets/menu_drawer_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';

class PaymentScreen extends StatefulWidget {
  final OrderModel orderModel;
  final String paymentMethod;
  final String? addFundUrl;
  final String? subscriptionUrl;
  final String guestId;
  final String contactNumber;
  const PaymentScreen({super.key, required this.orderModel, required this.paymentMethod, this.addFundUrl, this.subscriptionUrl,
    required this.guestId, required this.contactNumber});

  @override
  PaymentScreenState createState() => PaymentScreenState();
}

class PaymentScreenState extends State<PaymentScreen> {
  late String selectedUrl;
  double value = 0.0;
  final bool _isLoading = true;
  PullToRefreshController? pullToRefreshController;
  late MyInAppBrowser browser;
  double? maxCodOrderAmount;

  @override
  void initState() {
    super.initState();
    if(widget.addFundUrl == '' && widget.addFundUrl!.isEmpty && widget.subscriptionUrl == '' && widget.subscriptionUrl!.isEmpty) {
      selectedUrl = '${AppConstants.baseUrl}/payment-mobile?customer_id=${widget.orderModel.userId == 0 ? widget.guestId : widget.orderModel.userId}&order_id=${widget.orderModel.id}&payment_method=${widget.paymentMethod}';
    } else if(widget.subscriptionUrl != '' && widget.subscriptionUrl!.isNotEmpty){
      selectedUrl = widget.subscriptionUrl!;
    } else {
      selectedUrl = widget.addFundUrl!;
    }
    _initData();
  }

  void _initData() async {

    if(widget.addFundUrl == null && widget.addFundUrl!.isEmpty){
      ZoneData zoneData = AddressHelper.getAddressFromSharedPref()!.zoneData!.firstWhere((data) => data.id == widget.orderModel.restaurant!.zoneId);
      maxCodOrderAmount = zoneData.maxCodOrderAmount;
    }

    browser = MyInAppBrowser(orderID: widget.orderModel.id.toString(), orderAmount: widget.orderModel.orderAmount, maxCodOrderAmount: maxCodOrderAmount, addFundUrl: widget.addFundUrl, subscriptionUrl: widget.subscriptionUrl, contactNumber: widget.contactNumber);

      await InAppWebViewController.setWebContentsDebuggingEnabled(true);

      bool swAvailable = await WebViewFeature.isFeatureSupported(WebViewFeature.SERVICE_WORKER_BASIC_USAGE);
      bool swInterceptAvailable = await WebViewFeature.isFeatureSupported(WebViewFeature.SERVICE_WORKER_SHOULD_INTERCEPT_REQUEST);

      if (swAvailable && swInterceptAvailable) {
        ServiceWorkerController serviceWorkerController = ServiceWorkerController.instance();
        await serviceWorkerController.setServiceWorkerClient(ServiceWorkerClient(
          shouldInterceptRequest: (request) async {
            if (kDebugMode) {
              print(request);
            }
            return null;
          },
        ));
      }

    await browser.openUrlRequest(
      urlRequest: URLRequest(url: WebUri(selectedUrl)),
      settings: InAppBrowserClassSettings(
        webViewSettings: InAppWebViewSettings(useShouldOverrideUrlLoading: true, useOnLoadResource: true),
        browserSettings: InAppBrowserSettings(hideUrlBar: true, hideToolbarTop: GetPlatform.isAndroid),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: Navigator.canPop(context),
      onPopInvoked: (val) {
        _exitApp().then((value) => value!);
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        appBar: CustomAppBarWidget(title: 'payment'.tr, onBackPressed: () => _exitApp()),
        endDrawer: const MenuDrawerWidget(), endDrawerEnableOpenDragGesture: false,
        body: Center(
          child: SizedBox(
            width: Dimensions.webMaxWidth,
            child: Stack(
              children: [
                _isLoading ? Center(
                  child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)),
                ) : const SizedBox.shrink(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool?> _exitApp() async {
    if (kDebugMode) {
      print('---------- : ${widget.orderModel.orderStatus} / ${widget.orderModel.paymentMethod}/ ${widget.orderModel.id}');
      print('---check------- : ${widget.addFundUrl == null} && ${widget.addFundUrl!.isEmpty} && ${widget.subscriptionUrl == ''} && ${widget.subscriptionUrl!.isEmpty}');
    }
    if((widget.addFundUrl == null || widget.addFundUrl!.isEmpty) && widget.subscriptionUrl == '' && widget.subscriptionUrl!.isEmpty){
      return Get.dialog(PaymentFailedDialog(orderID: widget.orderModel.id.toString(), orderAmount: widget.orderModel.orderAmount, maxCodOrderAmount: maxCodOrderAmount, contactPersonNumber: widget.contactNumber));
    } else {
      return Get.dialog(FundPaymentDialogWidget(isSubscription: widget.subscriptionUrl != null && widget.subscriptionUrl!.isNotEmpty));
    }
  }

}

class MyInAppBrowser extends InAppBrowser {
  final String orderID;
  final double? orderAmount;
  final double? maxCodOrderAmount;
  final String? addFundUrl;
  final String? subscriptionUrl;
  final String? contactNumber;
  MyInAppBrowser({required this.orderID, required this.orderAmount, required this.maxCodOrderAmount, this.contactNumber, super.windowId,
    super.initialUserScripts, this.addFundUrl, this.subscriptionUrl});

  bool _canRedirect = true;

  @override
  Future onBrowserCreated() async {
    if (kDebugMode) {
      print("\n\nBrowser Created!\n\n");
    }
  }

  @override
  Future onLoadStart(url) async {
    if (kDebugMode) {
      print("\n\nStarted: $url\n\n");
    }
    _redirect(url.toString(), contactNumber);
  }

  @override
  Future onLoadStop(url) async {
    pullToRefreshController?.endRefreshing();
    if (kDebugMode) {
      print("\n\nStopped: $url\n\n");
    }
    _redirect(url.toString(), contactNumber);
  }

  @override
  void onLoadError(url, code, message) {
    pullToRefreshController?.endRefreshing();
    if (kDebugMode) {
      print("Can't load [$url] Error: $message");
    }
  }

  @override
  void onProgressChanged(progress) {
    if (progress == 100) {
      pullToRefreshController?.endRefreshing();
    }
    if (kDebugMode) {
      print("Progress: $progress");
    }
  }

  @override
  void onExit() {
    if(_canRedirect) {
      // Get.dialog(PaymentFailedDialog(orderID: orderID, orderAmount: orderAmount, maxCodOrderAmount: maxCodOrderAmount));
      if((addFundUrl == null || addFundUrl!.isEmpty) && subscriptionUrl == '' && subscriptionUrl!.isEmpty){
        Get.dialog(PaymentFailedDialog(orderID: orderID, orderAmount: orderAmount, maxCodOrderAmount: maxCodOrderAmount, contactPersonNumber: contactNumber,));
      } else {
        Get.dialog(FundPaymentDialogWidget(isSubscription: subscriptionUrl != null && subscriptionUrl!.isNotEmpty));
      }
    }
    if (kDebugMode) {
      print("\n\nBrowser closed!\n\n");
    }
  }

  @override
  Future<NavigationActionPolicy> shouldOverrideUrlLoading(navigationAction) async {
    if (kDebugMode) {
      print("\n\nOverride ${navigationAction.request.url}\n\n");
    }
    return NavigationActionPolicy.ALLOW;
  }

  @override
  void onLoadResource(resource) {
    if (kDebugMode) {
      print("Started at: ${resource.startTime}ms ---> duration: ${resource.duration}ms ${resource.url ?? ''}");
    }
  }

  @override
  void onConsoleMessage(consoleMessage) {
    if (kDebugMode) {
      print("""
    console output:
      message: ${consoleMessage.message}
      messageLevel: ${consoleMessage.messageLevel.toValue()}
   """);
    }
  }

  void _redirect(String url, String? contactNumber) {
    if(_canRedirect) {
      bool isSuccess = url.contains('${AppConstants.baseUrl}/payment-success');
      bool isFailed = url.contains('${AppConstants.baseUrl}/payment-fail');
      bool isCancel = url.contains('${AppConstants.baseUrl}/payment-cancel');
      if (isSuccess || isFailed || isCancel) {
        _canRedirect = false;
        close();
      }

      if((addFundUrl == '' && addFundUrl!.isEmpty && subscriptionUrl == '' && subscriptionUrl!.isEmpty)){
        _orderPaymentDoneDecision(isSuccess, isFailed, isCancel);
      } else{
        _decideSubscriptionOrWallet(isSuccess, isFailed, isCancel);
      }
    }
  }

  void _orderPaymentDoneDecision(bool isSuccess, bool isFailed, bool isCancel) {
    if (isSuccess) {
      double total = ((orderAmount! / 100) * Get.find<SplashController>().configModel!.loyaltyPointItemPurchasePoint!);
      Get.find<LoyaltyController>().saveEarningPoint(total.toStringAsFixed(0));
      Get.offNamed(RouteHelper.getOrderSuccessRoute(orderID, 'success', orderAmount, contactNumber));
    } else if (isFailed || isCancel) {
      Get.offNamed(RouteHelper.getOrderSuccessRoute(orderID, 'fail', orderAmount, contactNumber));
    }
  }

  void _decideSubscriptionOrWallet(bool isSuccess, bool isFailed, bool isCancel) {
    if(isSuccess || isFailed || isCancel) {
      if(Get.currentRoute.contains(RouteHelper.payment)) {
        Get.back();
      }
      if(subscriptionUrl != null && subscriptionUrl!.isNotEmpty && addFundUrl == '' && addFundUrl!.isEmpty) {
        Get.toNamed(RouteHelper.getSubscriptionSuccessRoute(isSuccess ? 'success' : isFailed ? 'fail' : 'cancel'));
      } else {
        Get.back();
        Get.toNamed(RouteHelper.getWalletRoute(fundStatus: isSuccess ? 'success' : isFailed ? 'fail' : 'cancel', /*token: UniqueKey().toString()*/));
      }
    }
  }

}