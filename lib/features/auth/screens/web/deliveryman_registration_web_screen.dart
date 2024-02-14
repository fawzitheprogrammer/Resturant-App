import 'dart:io';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:stackfood_multivendor/common/widgets/custom_button_widget.dart';
import 'package:stackfood_multivendor/common/widgets/custom_text_field_widget.dart';
import 'package:stackfood_multivendor/common/widgets/footer_view_widget.dart';
import 'package:stackfood_multivendor/common/widgets/web_screen_title_widget.dart';
import 'package:stackfood_multivendor/features/language/controllers/localization_controller.dart';
import 'package:stackfood_multivendor/features/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor/features/auth/controllers/deliveryman_registration_controller.dart';
import 'package:stackfood_multivendor/features/auth/widgets/deliveryman_additional_data_section_widget.dart';
import 'package:stackfood_multivendor/features/auth/widgets/pass_view_widget.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:stackfood_multivendor/common/widgets/custom_dropdown_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class DeliverymanRegistrationWebScreen extends StatefulWidget {
  final DeliverymanRegistrationController deliverymanController;
  final List<int> zoneIndexList;
  final List<DropdownItem<int>> typeList;
  final List<DropdownItem<int>> zoneList;
  final List<DropdownItem<int>> identityTypeList;
  final List<DropdownItem<int>> vehicleList;
  final ScrollController scrollController;
  final TextEditingController fNameController;
  final TextEditingController lNameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final TextEditingController identityNumberController;
  final FocusNode fNameNode;
  final FocusNode lNameNode;
  final FocusNode emailNode;
  final FocusNode phoneNode;
  final FocusNode passwordNode;
  final FocusNode confirmPasswordNode;
  final FocusNode identityNumberNode;
  final String? countryDialCode;
  final Widget buttonView;
  const DeliverymanRegistrationWebScreen({
    super.key, required this.deliverymanController, required this.zoneIndexList, required this.typeList,
    required this.zoneList, required this.identityTypeList, required this.vehicleList, required this.scrollController,
    required this.fNameController, required this.lNameController, required this.emailController,
    required this.phoneController, required this.passwordController, required this.confirmPasswordController,
    required this.identityNumberController, required this.fNameNode, required this.lNameNode, required this.emailNode,
    required this.phoneNode, required this.passwordNode, required this.confirmPasswordNode, required this.identityNumberNode,
    this.countryDialCode, required this.buttonView,
  });

  @override
  State<DeliverymanRegistrationWebScreen> createState() => _DeliverymanRegistrationWebScreenState();
}

class _DeliverymanRegistrationWebScreenState extends State<DeliverymanRegistrationWebScreen> {
  String? _countryDialCode;
  @override
  void initState() {
    super.initState();
    _countryDialCode = widget.countryDialCode;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: widget.scrollController,
      child: FooterViewWidget(
        child: Center(
          child: Column(
            children: [
              WebScreenTitleWidget( title: 'join_as_a_delivery_man'.tr),
              SizedBox(
                width: Dimensions.webMaxWidth,
                child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                  const SizedBox(height: Dimensions.paddingSizeSmall),

                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                      boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5, spreadRadius: 1)],
                    ),
                    padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                    child: Column(children: [
                      Text('delivery_man_registration'.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
                      const SizedBox(height: Dimensions.paddingSizeSmall),

                      Text(
                        'complete_registration_process_to_serve_as_delivery_man_in_this_platform'.tr,
                        style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor),
                      ),
                      const SizedBox(height: Dimensions.paddingSizeLarge),

                      Align(alignment: Alignment.center, child: Stack(children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                          child: widget.deliverymanController.pickedImage != null ? GetPlatform.isWeb ? Image.network(
                            widget.deliverymanController.pickedImage!.path, width: 180, height: 180, fit: BoxFit.cover,
                          ) : Image.file(
                            File(widget.deliverymanController.pickedImage!.path), width: 180, height: 180, fit: BoxFit.cover,
                          ) : SizedBox(
                            width: 180, height: 180,
                            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [

                              Icon(Icons.camera_alt, size: 38, color: Theme.of(context).disabledColor),
                              const SizedBox(height: Dimensions.paddingSizeSmall),

                              Text(
                                'upload_deliveryman_photo'.tr,
                                style: robotoMedium.copyWith(color: Theme.of(context).disabledColor), textAlign: TextAlign.center,
                              ),
                            ]),
                          ),
                        ),

                        Positioned(
                          bottom: 0, right: 0, top: 0, left: 0,
                          child: InkWell(
                            onTap: () => widget.deliverymanController.pickDmImage(true, false),
                            child: DottedBorder(
                              color: Theme.of(context).primaryColor,
                              strokeWidth: 1,
                              strokeCap: StrokeCap.butt,
                              dashPattern: const [5, 5],
                              padding: const EdgeInsets.all(0),
                              borderType: BorderType.RRect,
                              radius: const Radius.circular(Dimensions.radiusDefault),
                              child: Visibility(
                                visible: widget.deliverymanController.pickedImage != null,
                                child: Center(
                                  child: Container(
                                    margin: const EdgeInsets.all(25),
                                    decoration: BoxDecoration(border: Border.all(width: 2, color: Colors.white), shape: BoxShape.circle,),
                                    padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                                    child: const Icon(Icons.camera_alt, color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ])),
                      const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                      Row(children: [
                        Expanded(child: CustomTextFieldWidget(
                          titleText: 'first_name'.tr,
                          controller: widget.fNameController,
                          capitalization: TextCapitalization.words,
                          inputType: TextInputType.name,
                          focusNode: widget.fNameNode,
                          nextFocus: widget.lNameNode,
                          prefixIcon: Icons.person,
                          showTitle: true,
                        )),
                        const SizedBox(width: Dimensions.paddingSizeSmall),

                        Expanded(child: CustomTextFieldWidget(
                          titleText: 'last_name'.tr,
                          controller: widget.lNameController,
                          capitalization: TextCapitalization.words,
                          inputType: TextInputType.name,
                          focusNode: widget.lNameNode,
                          nextFocus: widget.phoneNode,
                          prefixIcon: Icons.person,
                          showTitle: true,
                        )),
                        const SizedBox(width: Dimensions.paddingSizeSmall),

                        Expanded(
                          child: CustomTextFieldWidget(
                            titleText: 'phone'.tr,
                            controller: widget.phoneController,
                            focusNode: widget.phoneNode,
                            nextFocus: widget.emailNode,
                            inputType: TextInputType.phone,
                            isPhone: true,
                            showTitle: ResponsiveHelper.isDesktop(context),
                            onCountryChanged: (CountryCode countryCode) {
                              _countryDialCode = countryCode.dialCode;
                            },
                            countryDialCode: _countryDialCode != null ? CountryCode.fromCountryCode(Get.find<SplashController>().configModel!.country!).code
                                : Get.find<LocalizationController>().locale.countryCode,
                          ),
                        ),
                      ]),
                      const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                      Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Expanded(child:CustomTextFieldWidget(
                          titleText: 'email'.tr,
                          controller: widget.emailController,
                          focusNode: widget.emailNode,
                          nextFocus: widget.passwordNode,
                          inputType: TextInputType.emailAddress,
                          prefixIcon: Icons.email,
                          showTitle: true,
                        )),
                        const SizedBox(width: Dimensions.paddingSizeSmall),

                        Expanded(child: Column(
                          children: [
                            CustomTextFieldWidget(
                              titleText: 'password'.tr,
                              controller: widget.passwordController,
                              focusNode: widget.passwordNode,
                              nextFocus: widget.confirmPasswordNode,
                              inputAction: TextInputAction.done,
                              inputType: TextInputType.visiblePassword,
                              isPassword: true,
                              prefixIcon: Icons.lock,
                              showTitle: true,
                              onChanged: (value){
                                if(value != null && value.isNotEmpty){
                                  if(!widget.deliverymanController.showPassView){
                                    widget.deliverymanController.showHidePassView();
                                  }
                                  widget.deliverymanController.validPassCheck(value);
                                }else{
                                  if(widget.deliverymanController.showPassView){
                                    widget.deliverymanController.showHidePassView();
                                  }
                                }
                              },
                            ),

                            widget.deliverymanController.showPassView ? const PassViewWidget() : const SizedBox(),
                          ],
                        )),
                        const SizedBox(width: Dimensions.paddingSizeSmall),

                        Expanded(child: CustomTextFieldWidget(
                          titleText: 'confirm_password'.tr,
                          hintText: '8_character'.tr,
                          controller: widget.confirmPasswordController,
                          focusNode: widget.confirmPasswordNode,
                          inputAction: TextInputAction.done,
                          inputType: TextInputType.visiblePassword,
                          prefixIcon: Icons.lock,
                          isPassword: true,
                          showTitle: true,
                        ))
                      ]),
                    ]),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeLarge),

                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                      boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5, spreadRadius: 1)],
                    ),
                    padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                    child: Column(children: [
                      Row(children: [
                        const Icon(Icons.person),
                        const SizedBox(width: Dimensions.paddingSizeSmall),
                        Text('delivery_man_information'.tr, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall))
                      ]),
                      const Divider(),
                      const SizedBox(height: Dimensions.paddingSizeLarge),


                      Row(children: [
                        Expanded(child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('delivery_man_type'.tr, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),
                            const SizedBox(height: Dimensions.paddingSizeDefault),
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                  color: Theme.of(context).cardColor,
                                  border: Border.all(color: Theme.of(context).primaryColor, width: 0.3)
                              ),
                              child: CustomDropdown<int>(
                                onChange: (int? value, int index) {
                                  widget.deliverymanController.setDMTypeIndex(index, true);
                                },
                                dropdownButtonStyle: DropdownButtonStyle(
                                  height: 45,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: Dimensions.paddingSizeExtraSmall,
                                    horizontal: Dimensions.paddingSizeExtraSmall,
                                  ),
                                  primaryColor: Theme.of(context).textTheme.bodyLarge!.color,
                                ),
                                dropdownStyle: DropdownStyle(
                                  elevation: 10,
                                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                  padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                                ),
                                items: widget.typeList,
                                child: Text('${widget.deliverymanController.dmTypeList[0]}'.tr),
                              ),
                            ),
                          ],
                        )),
                        const SizedBox(width: Dimensions.paddingSizeLarge),

                        Expanded(child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('zone'.tr, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),
                            const SizedBox(height: Dimensions.paddingSizeDefault),

                            (widget.deliverymanController.zoneList != null && widget.deliverymanController.zoneList!.isNotEmpty) ? Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                  color: Theme.of(context).cardColor,
                                  border: Border.all(color: Theme.of(context).primaryColor, width: 0.3)
                              ),
                              child: CustomDropdown<int>(
                                onChange: (int? value, int index) {
                                  widget.deliverymanController.setZoneIndex(value);
                                },
                                dropdownButtonStyle: DropdownButtonStyle(
                                  height: 45,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: Dimensions.paddingSizeExtraSmall,
                                    horizontal: Dimensions.paddingSizeExtraSmall,
                                  ),
                                  primaryColor: Theme.of(context).textTheme.bodyLarge!.color,
                                ),
                                dropdownStyle: DropdownStyle(
                                  elevation: 10,
                                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                  padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                                ),
                                items: widget.zoneList,
                                child: Text('${widget.deliverymanController.zoneList![widget.deliverymanController.selectedZoneIndex!].name}'.tr),
                              ),
                            ) : const Center(child: CircularProgressIndicator()),
                          ],
                        )),
                        const SizedBox(width: Dimensions.paddingSizeSmall),

                        Expanded(child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('vehicle_type'.tr, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),
                            const SizedBox(height: Dimensions.paddingSizeDefault),

                            (widget.deliverymanController.vehicleIds != null && widget.deliverymanController.vehicleIds!.isNotEmpty) ? Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                  color: Theme.of(context).cardColor,
                                  border: Border.all(color: Theme.of(context).primaryColor, width: 0.3)
                              ),
                              child: CustomDropdown<int>(
                                onChange: (int? value, int index) {
                                  widget.deliverymanController.setVehicleIndex(index, true);
                                },
                                dropdownButtonStyle: DropdownButtonStyle(
                                  height: 45,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: Dimensions.paddingSizeExtraSmall,
                                    horizontal: Dimensions.paddingSizeExtraSmall,
                                  ),
                                  primaryColor: Theme.of(context).textTheme.bodyLarge!.color,
                                ),
                                dropdownStyle: DropdownStyle(
                                  elevation: 10,
                                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                  padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                                ),
                                items: widget.vehicleList,
                                child: Text(widget.deliverymanController.vehicles![widget.deliverymanController.vehicleIndex!].type!.tr),
                              ),
                            ) : const Center(child: CircularProgressIndicator()),
                          ],
                        ),
                        ),

                      ]),
                      const SizedBox(height: Dimensions.paddingSizeLarge),

                      Row(children: [
                        Expanded(child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('identity_type'.tr, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),
                            const SizedBox(height: Dimensions.paddingSizeDefault),

                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                  color: Theme.of(context).cardColor,
                                  border: Border.all(color: Theme.of(context).primaryColor, width: 0.3)
                              ),
                              child: CustomDropdown<int>(
                                onChange: (int? value, int index) {
                                  widget.deliverymanController.setIdentityTypeIndex(widget.deliverymanController.identityTypeList[index], true);
                                },
                                dropdownButtonStyle: DropdownButtonStyle(
                                  height: 45,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: Dimensions.paddingSizeExtraSmall,
                                    horizontal: Dimensions.paddingSizeExtraSmall,
                                  ),
                                  primaryColor: Theme.of(context).textTheme.bodyLarge!.color,
                                ),
                                dropdownStyle: DropdownStyle(
                                  elevation: 10,
                                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                  padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                                ),
                                items: widget.identityTypeList,
                                child: Text(widget.deliverymanController.identityTypeList[widget.deliverymanController.identityTypeIndex].tr),
                              ),
                            ),
                          ],
                        ),
                        ),
                        const SizedBox(width: Dimensions.paddingSizeSmall),

                        Expanded(child: CustomTextFieldWidget(
                          titleText: widget.deliverymanController.identityTypeIndex == 1 ? 'identity_number'.tr
                              : widget.deliverymanController.identityTypeIndex == 2 ? 'driving_license_number'.tr : 'nid_number'.tr,
                          controller: widget.identityNumberController,
                          focusNode: widget.identityNumberNode,
                          inputAction: TextInputAction.done,
                          showTitle: true,
                        )),

                        const Expanded(child: SizedBox()),

                      ]),
                      const SizedBox(height: Dimensions.paddingSizeLarge),

                      SizedBox(
                        height: 120,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          itemCount: widget.deliverymanController.pickedIdentities.length+1,
                          itemBuilder: (context, index) {
                            XFile? file = index == widget.deliverymanController.pickedIdentities.length ? null : widget.deliverymanController.pickedIdentities[index];
                            if(index == widget.deliverymanController.pickedIdentities.length) {
                              return InkWell(
                                onTap: () => widget.deliverymanController.pickDmImage(false, false),
                                child: DottedBorder(
                                  color: Theme.of(context).primaryColor,
                                  strokeWidth: 1,
                                  strokeCap: StrokeCap.butt,
                                  dashPattern: const [5, 5],
                                  padding: const EdgeInsets.all(5),
                                  borderType: BorderType.RRect,
                                  radius: const Radius.circular(Dimensions.radiusDefault),
                                  child: Container(
                                    height: 120, width: 150, alignment: Alignment.center,
                                    padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                                    child: Column(
                                      children: [
                                        Icon(Icons.camera_alt, color: Theme.of(context).disabledColor),
                                        Text('upload_identity_image'.tr, style: robotoMedium.copyWith(color: Theme.of(context).disabledColor), textAlign: TextAlign.center),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }
                            return Container(
                              margin: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
                              decoration: BoxDecoration(
                                border: Border.all(color: Theme.of(context).primaryColor, width: 2),
                                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                              ),
                              child: Stack(children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                                  child: GetPlatform.isWeb ? Image.network(
                                    file!.path, width: 150, height: 120, fit: BoxFit.cover,
                                  ) : Image.file(
                                    File(file!.path), width: 150, height: 120, fit: BoxFit.cover,
                                  ),
                                ),
                                Positioned(
                                  right: 0, top: 0,
                                  child: InkWell(
                                    onTap: () => widget.deliverymanController.removeIdentityImage(index),
                                    child: const Padding(
                                      padding: EdgeInsets.all(Dimensions.paddingSizeSmall),
                                      child: Icon(Icons.delete_forever, color: Colors.red),
                                    ),
                                  ),
                                ),
                              ]),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: Dimensions.paddingSizeLarge),

                    ]),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeSmall),

                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                      boxShadow: const [BoxShadow(color: Colors.black12, spreadRadius: 1, blurRadius: 5)],
                    ),
                    padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                    margin: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                    child: Column(children: [
                      Row(children: [
                        const Icon(Icons.person),
                        Text('additional_information'.tr, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall))
                      ]),
                      const Divider(),
                      const SizedBox(height: Dimensions.paddingSizeLarge),

                      DeliverymanAdditionalDataSectionWidget(deliverymanController: widget.deliverymanController, scrollController: widget.scrollController),

                    ]),
                  ),

                  Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                          border: Border.all(color: Theme.of(context).hintColor)
                      ),
                      width: 165,
                      child: CustomButtonWidget(
                        transparent: true,
                        textColor: Theme.of(context).hintColor,
                        radius: Dimensions.radiusSmall,
                        onPressed: () {
                          widget.phoneController.text = '';
                          widget.emailController.text = '';
                          widget.fNameController.text = '';
                          widget.lNameController.text = '';
                          widget.lNameController.text = '';
                          widget.passwordController.text = '';
                          widget.confirmPasswordController.text = '';
                          widget.identityNumberController.text = '';
                          widget.deliverymanController.resetDeliveryRegistration();
                          widget.deliverymanController.setDeliverymanAdditionalJoinUsPageData(isUpdate: true);
                        },
                        buttonText: 'reset'.tr,
                        isBold: false,
                        fontSize: Dimensions.fontSizeSmall,
                      ),
                    ),

                    const SizedBox( width: Dimensions.paddingSizeLarge),
                    SizedBox(width: 165, child: widget.buttonView),
                  ]),

                ]),
              )
            ],
          ),
        ),
      ),
    );
  }
}
