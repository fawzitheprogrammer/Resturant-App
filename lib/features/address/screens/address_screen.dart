import 'package:stackfood_multivendor/common/widgets/not_logged_in_screen.dart';
import 'package:stackfood_multivendor/features/address/controllers/address_controller.dart';
import 'package:stackfood_multivendor/features/address/widgets/address_confirmation_dialogue_widget.dart';
import 'package:stackfood_multivendor/features/auth/controllers/auth_controller.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/helper/route_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/images.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:stackfood_multivendor/common/widgets/custom_app_bar_widget.dart';
import 'package:stackfood_multivendor/common/widgets/custom_snackbar_widget.dart';
import 'package:stackfood_multivendor/common/widgets/footer_view_widget.dart';
import 'package:stackfood_multivendor/common/widgets/menu_drawer_widget.dart';
import 'package:stackfood_multivendor/common/widgets/no_data_screen_widget.dart';
import 'package:stackfood_multivendor/common/widgets/web_page_title_widget.dart';
import 'package:stackfood_multivendor/features/address/widgets/address_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddressScreen extends StatefulWidget {
  const AddressScreen({super.key});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _initCall();
  }

  void _initCall(){
    if(Get.find<AuthController>().isLoggedIn()) {
      Get.find<AddressController>().getAddressList();
    }
  }

  @override
  Widget build(BuildContext context) {

    bool isLoggedIn = Get.find<AuthController>().isLoggedIn();

    return GetBuilder<AddressController>(builder: (addressController) {
      return Scaffold (

        appBar: CustomAppBarWidget(title: 'my_address'.tr),

        endDrawer: const MenuDrawerWidget(), endDrawerEnableOpenDragGesture: false,

        floatingActionButton:  ResponsiveHelper.isDesktop(context) || !isLoggedIn ? null : (addressController.addressList?.isEmpty ?? true) ? null : FloatingActionButton(
          backgroundColor: Theme.of(context).primaryColor,
          onPressed: () => Get.toNamed(RouteHelper.getAddAddressRoute(false, 0)),
          child: Icon(Icons.add, color: Theme.of(context).cardColor),
        ),
        floatingActionButtonLocation: ResponsiveHelper.isDesktop(context) ? FloatingActionButtonLocation.centerFloat : null,

        body: Container(
          height: context.height,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(Images.city),
              alignment: Alignment.bottomCenter,
            ),
          ),
          child: isLoggedIn ? GetBuilder<AddressController>(builder: (addressController) {
            return RefreshIndicator(
              onRefresh: () async {
                await addressController.getAddressList();
              },
              child: Scrollbar(controller: scrollController, child: SingleChildScrollView(
                controller: scrollController,
                physics: const BouncingScrollPhysics(),
                child: Column(children: [

                  WebScreenTitleWidget(title: 'address'.tr),

                  Center(child: FooterViewWidget(
                    child: SizedBox(
                      width: Dimensions.webMaxWidth,
                      child: Column(children: [

                        ResponsiveHelper.isDesktop(context) ? const SizedBox( height: Dimensions.paddingSizeSmall) : const SizedBox(),

                        addressController.addressList != null ? addressController.addressList!.isNotEmpty ? Padding(
                          padding: ResponsiveHelper.isMobile(context) ? const EdgeInsets.all(Dimensions.paddingSizeSmall) : EdgeInsets.zero,
                          child: GridView.builder(
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisSpacing: Dimensions.paddingSizeLarge,
                              mainAxisSpacing: ResponsiveHelper.isDesktop(context) ? Dimensions.paddingSizeLarge : 0.01,
                              childAspectRatio: ResponsiveHelper.isDesktop(context) ? 4 : 5,
                              crossAxisCount: ResponsiveHelper.isMobile(context) ? 1 : ResponsiveHelper.isTab(context) ? 2 : 3,
                            ),
                            physics: const NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.all(ResponsiveHelper.isTab(context) ? Dimensions.paddingSizeSmall : 0),
                            shrinkWrap: true,
                            itemCount: ResponsiveHelper.isDesktop(context) ? (addressController.addressList!.length + 1)  : addressController.addressList!.length,
                            itemBuilder: (context, index) {
                              return (ResponsiveHelper.isDesktop(context) && (index == addressController.addressList!.length)) ? InkWell(
                                onTap: () => Get.toNamed(RouteHelper.getAddAddressRoute(false, 0)),
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
                                  padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                                  decoration:  BoxDecoration(
                                    color: Theme.of(context).cardColor,
                                    borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                    boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5, spreadRadius: 1)],
                                  ),
                                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                                    Icon(Icons.add_circle_outline, color: Theme.of(context).primaryColor),
                                    const SizedBox(height: Dimensions.paddingSizeSmall),

                                    Text('add_new_address'.tr, style: robotoRegular.copyWith(color: Theme.of(context).primaryColor, fontSize: Dimensions.fontSizeSmall)),

                                  ]),
                                ),
                              ) : AddressCardWidget(
                                address: addressController.addressList![index], fromAddress: true,
                                onTap: () {
                                  Get.toNamed(RouteHelper.getMapRoute(
                                    addressController.addressList![index], 'address',
                                  ));
                                },
                                onEditPressed: () {
                                  Get.toNamed(RouteHelper.getEditAddressRoute(addressController.addressList![index]));
                                },
                                onRemovePressed: () {
                                  if(Get.isSnackbarOpen) {
                                    Get.back();
                                }
                                Get.dialog(AddressConfirmDialogueWidget(
                                  icon: Images.locationConfirm,
                                  title: 'are_you_sure'.tr,
                                  description: 'you_want_to_delete_this_location'.tr,
                                  onYesPressed: () {
                                    addressController.deleteAddress(addressController.addressList![index].id, index).then((response) {
                                      Get.back();
                                      showCustomSnackBar(response.message, isError: !response.isSuccess);
                                    });
                                  },
                                ));
                                },
                              );
                            },
                          ),
                        ) : NoDataScreen(title: 'no_saved_address_found'.tr, fromAddress: true) : const Center(child: CircularProgressIndicator()),

                      ]),
                    ),
                  )),

                ]),
              )),
            );
          }) : NotLoggedInScreen(callBack: (value){
            _initCall();
            setState(() {});
          }),
        ),
      );
    });
  }
}