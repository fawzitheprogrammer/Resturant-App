import 'dart:convert';
import 'dart:io';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:stackfood_multivendor/features/auth/domain/models/delivery_man_body_model.dart';
import 'package:stackfood_multivendor/features/language/controllers/localization_controller.dart';
import 'package:stackfood_multivendor/features/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor/features/splash/domain/models/config_model.dart';
import 'package:stackfood_multivendor/features/auth/controllers/deliveryman_registration_controller.dart';
import 'package:stackfood_multivendor/features/auth/domain/models/vehicle_model.dart';
import 'package:stackfood_multivendor/features/auth/domain/models/zone_model.dart';
import 'package:stackfood_multivendor/features/auth/screens/web/deliveryman_registration_web_screen.dart';
import 'package:stackfood_multivendor/features/auth/widgets/deliveryman_additional_data_section_widget.dart';
import 'package:stackfood_multivendor/features/auth/widgets/pass_view_widget.dart';
import 'package:stackfood_multivendor/helper/custom_validator.dart';
import 'package:stackfood_multivendor/helper/extensions.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:stackfood_multivendor/common/widgets/custom_app_bar_widget.dart';
import 'package:stackfood_multivendor/common/widgets/custom_button_widget.dart';
import 'package:stackfood_multivendor/common/widgets/custom_dropdown_widget.dart';
import 'package:stackfood_multivendor/common/widgets/custom_snackbar_widget.dart';
import 'package:stackfood_multivendor/common/widgets/custom_text_field_widget.dart';
import 'package:stackfood_multivendor/common/widgets/menu_drawer_widget.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class DeliveryManRegistrationScreen extends StatefulWidget {
  const DeliveryManRegistrationScreen({super.key});

  @override
  State<DeliveryManRegistrationScreen> createState() => _DeliveryManRegistrationScreenState();
}

class _DeliveryManRegistrationScreenState extends State<DeliveryManRegistrationScreen> {
  final TextEditingController _fNameController = TextEditingController();
  final TextEditingController _lNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _identityNumberController = TextEditingController();
  final FocusNode _fNameNode = FocusNode();
  final FocusNode _lNameNode = FocusNode();
  final FocusNode _emailNode = FocusNode();
  final FocusNode _phoneNode = FocusNode();
  final FocusNode _passwordNode = FocusNode();
  final FocusNode _confirmPasswordNode = FocusNode();
  final FocusNode _identityNumberNode = FocusNode();
  String? _countryDialCode;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _countryDialCode = CountryCode.fromCountryCode(Get.find<SplashController>().configModel!.country!).dialCode;
    if(Get.find<DeliverymanRegistrationController>().showPassView){
      Get.find<DeliverymanRegistrationController>().showHidePassView();
    }
    Get.find<DeliverymanRegistrationController>().pickDmImage(false, true);
    Get.find<DeliverymanRegistrationController>().dmStatusChange(0.4, isUpdate: false);
    Get.find<DeliverymanRegistrationController>().validPassCheck('', isUpdate: false);
    Get.find<DeliverymanRegistrationController>().setIdentityTypeIndex(Get.find<DeliverymanRegistrationController>().identityTypeList[0], false);
    Get.find<DeliverymanRegistrationController>().setDMTypeIndex(0, false);
    Get.find<DeliverymanRegistrationController>().setVehicleIndex(0, false);
    Get.find<DeliverymanRegistrationController>().getZoneList();
    Get.find<DeliverymanRegistrationController>().getVehicleList();
    Get.find<DeliverymanRegistrationController>().initIdentityTypeIndex();
    Get.find<DeliverymanRegistrationController>().setDeliverymanAdditionalJoinUsPageData(isUpdate: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: const MenuDrawerWidget(), endDrawerEnableOpenDragGesture: false,
      appBar: CustomAppBarWidget(title: 'delivery_man_registration'.tr,
        onBackPressed: () {
          if(Get.find<DeliverymanRegistrationController>().dmStatus != 0.4) {
            Get.find<DeliverymanRegistrationController>().dmStatusChange(0.4);
          } else{
            Get.back();
          }
        },
      ),
      body: SafeArea(
        child: GetBuilder<DeliverymanRegistrationController>(builder: (deliverymanController) {
          List<int> zoneIndexList = _generateZoneIndexList(deliverymanController.zoneList);
          List<DropdownItem<int>> zoneList = _generateDropDownZoneList(deliverymanController.zoneList);
          List<DropdownItem<int>> vehicleList = _generateDropDownVehicleList(deliverymanController.vehicles);
          List<DropdownItem<int>> dmTypeList = _generateDropDownDmTypeList(deliverymanController.dmTypeList);
          List<DropdownItem<int>> identityTypeList = _generateDropDownIdentityTypeList(deliverymanController.identityTypeList);

          return ResponsiveHelper.isDesktop(context) ? DeliverymanRegistrationWebScreen(
            deliverymanController: deliverymanController, zoneIndexList: zoneIndexList, typeList: dmTypeList,
            zoneList: zoneList, identityTypeList: identityTypeList, vehicleList: vehicleList, scrollController: _scrollController,
            fNameController: _fNameController, lNameController: _lNameController, emailController: _emailController,
            phoneController: _phoneController, passwordController: _passwordController, confirmPasswordController: _confirmPasswordController,
            identityNumberController: _identityNumberController, fNameNode: _fNameNode, lNameNode: _lNameNode, emailNode: _emailNode,
            phoneNode: _phoneNode, passwordNode: _passwordNode, confirmPasswordNode: _confirmPasswordNode, identityNumberNode: _identityNumberNode,
            buttonView: buttonView()) /*webView(deliverymanController, zoneIndexList, dmTypeList, zoneList, identityTypeList, vehicleList)*/
          : Column(children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical:  Dimensions.paddingSizeSmall),
              child: Column(children: [
                Text(
                  'complete_registration_process_to_serve_as_delivery_man_in_this_platform'.tr,
                  style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor),
                ),

                const SizedBox(height: Dimensions.paddingSizeSmall),

                LinearProgressIndicator(
                  backgroundColor: Theme.of(context).disabledColor, minHeight: 2,
                  value: deliverymanController.dmStatus,
                ),
                // const SizedBox(height: Dimensions.paddingSizeExtraLarge),
              ]),
            ),



            Expanded(child: SingleChildScrollView(
              padding:  const EdgeInsets.all(Dimensions.paddingSizeLarge),
              physics: const BouncingScrollPhysics(),
              child: Center(child: SizedBox(width: Dimensions.webMaxWidth, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                Column(
                  children: [
                    Visibility(
                      visible: deliverymanController.dmStatus == 0.4,
                      child: Column(children: [

                        Align(alignment: Alignment.center, child: Stack(clipBehavior: Clip.none, children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                            child: deliverymanController.pickedImage != null ? GetPlatform.isWeb ? Image.network(
                              deliverymanController.pickedImage!.path, width: 150, height: 120, fit: BoxFit.cover,
                            ) : Image.file(
                              File(deliverymanController.pickedImage!.path), width: 150, height: 120, fit: BoxFit.cover,
                            ) : SizedBox(
                              width: 150, height: 120,
                              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [

                                Icon(Icons.photo_camera, size: 38, color: Theme.of(context).disabledColor),
                                const SizedBox(height: Dimensions.paddingSizeSmall),

                                Text(
                                  'upload_deliveryman_photo'.tr,
                                  style: robotoMedium.copyWith(color: Theme.of(context).disabledColor, fontSize: Dimensions.fontSizeSmall), textAlign: TextAlign.center,
                                ),
                              ]),
                            ),
                          ),

                          Positioned(
                            bottom: 0, right: 0, top: 0, left: 0,
                            child: InkWell(
                              onTap: () => deliverymanController.pickDmImage(true, false),
                              child: DottedBorder(
                                color: Theme.of(context).primaryColor,
                                strokeWidth: 1,
                                strokeCap: StrokeCap.butt,
                                dashPattern: const [5, 5],
                                padding: const EdgeInsets.all(0),
                                borderType: BorderType.RRect,
                                radius: const Radius.circular(Dimensions.radiusDefault),
                                child: Visibility(
                                  visible: deliverymanController.pickedImage != null,
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

                          deliverymanController.pickedImage != null ? Positioned(
                            bottom: -10, right: -10,
                            child: InkWell(
                              onTap: () => deliverymanController.removeDmImage(),
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Theme.of(context).cardColor, width: 2),
                                  shape: BoxShape.circle, color: Theme.of(context).colorScheme.error,
                                ),
                                padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                                child:  Icon(Icons.remove, size: 18, color: Theme.of(context).cardColor,),
                              ),
                            ),

                          ) : const SizedBox(),
                        ])),
                        const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                        Row(children: [
                          Expanded(child: CustomTextFieldWidget(
                            titleText: 'first_name'.tr,
                            controller: _fNameController,
                            capitalization: TextCapitalization.words,
                            inputType: TextInputType.name,
                            focusNode: _fNameNode,
                            nextFocus: _lNameNode,
                            prefixIcon: Icons.person,
                          )),
                          const SizedBox(width: Dimensions.paddingSizeSmall),

                          Expanded(child: CustomTextFieldWidget(
                            titleText: 'last_name'.tr,
                            controller: _lNameController,
                            capitalization: TextCapitalization.words,
                            inputType: TextInputType.name,
                            focusNode: _lNameNode,
                            nextFocus: _phoneNode,
                            prefixIcon: Icons.person,
                          )),
                        ]),
                        const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                        CustomTextFieldWidget(
                          titleText: ResponsiveHelper.isDesktop(context) ? 'phone'.tr : 'enter_phone_number'.tr,
                          controller: _phoneController,
                          focusNode: _phoneNode,
                          nextFocus: _emailNode,
                          inputType: TextInputType.phone,
                          isPhone: true,
                          onCountryChanged: (CountryCode countryCode) {
                            _countryDialCode = countryCode.dialCode;
                          },
                          countryDialCode: _countryDialCode != null ? CountryCode.fromCountryCode(Get.find<SplashController>().configModel!.country!).code
                              : Get.find<LocalizationController>().locale.countryCode,
                        ),
                        const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                        CustomTextFieldWidget(
                          titleText: 'email'.tr,
                          controller: _emailController,
                          focusNode: _emailNode,
                          nextFocus: _passwordNode,
                          inputType: TextInputType.emailAddress,
                          prefixIcon: Icons.email,
                        ),
                        const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                        CustomTextFieldWidget(
                          titleText: 'password'.tr,
                          controller: _passwordController,
                          focusNode: _passwordNode,
                          nextFocus: _confirmPasswordNode,
                          inputType: TextInputType.visiblePassword,
                          isPassword: true,
                          prefixIcon: Icons.lock,
                          onChanged: (value){
                            if(value != null && value.isNotEmpty){
                              if(!deliverymanController.showPassView){
                                deliverymanController.showHidePassView();
                              }
                              deliverymanController.validPassCheck(value);
                            }else{
                              if(deliverymanController.showPassView){
                                deliverymanController.showHidePassView();
                              }
                            }
                          },
                        ),

                        deliverymanController.showPassView ? const PassViewWidget() : const SizedBox(),
                        const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                        CustomTextFieldWidget(
                          titleText: 'confirm_password'.tr,
                          hintText: '',
                          controller: _confirmPasswordController,
                          focusNode: _confirmPasswordNode,
                          inputAction: TextInputAction.done,
                          inputType: TextInputType.visiblePassword,
                          prefixIcon: Icons.lock,
                          isPassword: true,
                        ),
                        const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                      ]),
                    ),

                    Visibility(
                      visible: deliverymanController.dmStatus != 0.4,
                      child: Column(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.start, children: [

                        Row(children: [
                          Expanded(child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                color: Theme.of(context).cardColor,
                                border: Border.all(color: Theme.of(context).primaryColor, width: 0.3)
                            ),
                            child: CustomDropdown<int>(
                              onChange: (int? value, int index) {
                                deliverymanController.setDMTypeIndex(index, true);
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
                              items: dmTypeList,
                              child: Text(deliverymanController.dmTypeList[deliverymanController.dmTypeIndex]!.tr),
                            ),
                          ),
                          ),
                          const SizedBox(width: Dimensions.paddingSizeSmall),

                          Expanded(child: (deliverymanController.zoneList != null && deliverymanController.selectedZoneIndex != -1) ? Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                color: Theme.of(context).cardColor,
                                border: Border.all(color: Theme.of(context).primaryColor, width: 0.3)
                            ),
                            child: CustomDropdown<int>(
                              onChange: (int? value, int index) {
                                deliverymanController.setZoneIndex(value);
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
                              items: zoneList,
                              child: Text('${deliverymanController.zoneList![deliverymanController.selectedZoneIndex!].name}'.tr),
                            ),
                          ) : const Center(child: CircularProgressIndicator())),
                        ]),

                        const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                        deliverymanController.vehicleIds != null ? Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                              color: Theme.of(context).cardColor,
                              border: Border.all(color: Theme.of(context).primaryColor, width: 0.3)
                          ),
                          child: CustomDropdown<int>(
                            onChange: (int? value, int index) {
                              deliverymanController.setVehicleIndex(index, true);
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
                            items: vehicleList,
                            child: Text(deliverymanController.vehicles![deliverymanController.vehicleIndex!].type!.tr),
                          ),
                        ) : const CircularProgressIndicator(),
                        const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                              color: Theme.of(context).cardColor,
                              border: Border.all(color: Theme.of(context).primaryColor, width: 0.3)
                          ),
                          child: CustomDropdown<int>(
                            onChange: (int? value, int index) {
                              deliverymanController.setIdentityTypeIndex(deliverymanController.identityTypeList[index], true);
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
                            items: identityTypeList,
                            child: Text(deliverymanController.identityTypeList[deliverymanController.identityTypeIndex].tr),
                          ),
                        ),
                        const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                        CustomTextFieldWidget(
                          titleText: deliverymanController.identityTypeIndex == 0 ? 'Ex: XXXXX-XXXXXXX-X'
                              : deliverymanController.identityTypeIndex == 1 ? 'L-XXX-XXX-XXX-XXX.' : 'XXX-XXXXX',
                          controller: _identityNumberController,
                          focusNode: _identityNumberNode,
                          inputAction: TextInputAction.done,
                        ),
                        const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                        ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: deliverymanController.pickedIdentities.length+1,
                          itemBuilder: (context, index) {
                            XFile? file = index == deliverymanController.pickedIdentities.length ? null : deliverymanController.pickedIdentities[index];
                            if(index == deliverymanController.pickedIdentities.length) {
                              return InkWell(
                                onTap: () => deliverymanController.pickDmImage(false, false),
                                child: DottedBorder(
                                  color: Theme.of(context).primaryColor,
                                  strokeWidth: 1,
                                  strokeCap: StrokeCap.butt,
                                  dashPattern: const [5, 5],
                                  padding: const EdgeInsets.all(5),
                                  borderType: BorderType.RRect,
                                  radius: const Radius.circular(Dimensions.radiusDefault),
                                  child: SizedBox(
                                    height: 120, width: double.infinity,
                                    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                                      Icon(Icons.camera_alt, color: Theme.of(context).disabledColor, size: 38),
                                      Text('upload_identity_image'.tr, style: robotoMedium.copyWith(color: Theme.of(context).disabledColor)),
                                    ]),
                                  ),
                                ),
                              );
                            }
                            return Padding(
                              padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
                              child: DottedBorder(
                                color: Theme.of(context).primaryColor,
                                strokeWidth: 1,
                                strokeCap: StrokeCap.butt,
                                dashPattern: const [5, 5],
                                padding: const EdgeInsets.all(5),
                                borderType: BorderType.RRect,
                                radius: const Radius.circular(Dimensions.radiusDefault),
                                child: Stack(children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                                    child: GetPlatform.isWeb ? Image.network(
                                      file!.path, width: double.infinity, height: 120, fit: BoxFit.cover,
                                    ) : Image.file(
                                      File(file!.path), width: double.infinity, height: 120, fit: BoxFit.cover,
                                    ),
                                  ),
                                  Positioned(
                                    right: 0, top: 0,
                                    child: InkWell(
                                      onTap: () => deliverymanController.removeIdentityImage(index),
                                      child: const Padding(
                                        padding: EdgeInsets.all(Dimensions.paddingSizeSmall),
                                        child: Icon(Icons.delete_forever, color: Colors.red),
                                      ),
                                    ),
                                  ),
                                ]),
                              ),
                            );
                          },
                        ),

                        const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                        DeliverymanAdditionalDataSectionWidget(deliverymanController: deliverymanController, scrollController: _scrollController),

                        const SizedBox(height: Dimensions.paddingSizeSmall),

                        //ConditionCheckBox(authController: authController, fromSignUp: true),
                      ]),
                    ),
                  ],
                ),

                const SizedBox(height: Dimensions.paddingSizeLarge),
                (ResponsiveHelper.isDesktop(context) || ResponsiveHelper.isWeb()) ? buttonView() : const SizedBox(),

              ]))),
            )),

            (ResponsiveHelper.isDesktop(context) || ResponsiveHelper.isWeb()) ? const SizedBox() : buttonView(),

          ]);
        }),
      ),
    );
  }

  Widget buttonView(){
    return GetBuilder<DeliverymanRegistrationController>(builder: (deliverymanController) {
      return CustomButtonWidget(
        isLoading: deliverymanController.isLoading,
        buttonText: (deliverymanController.dmStatus == 0.4  && !ResponsiveHelper.isDesktop(context)) ? 'next'.tr : 'submit'.tr,
        margin: EdgeInsets.all((ResponsiveHelper.isDesktop(context) || ResponsiveHelper.isWeb()) ? 0 : Dimensions.paddingSizeSmall),
        height: 50,
        onPressed: () async {
          if(deliverymanController.dmStatus == 0.4 && !ResponsiveHelper.isDesktop(context)){
            String fName = _fNameController.text.trim();
            String lName = _lNameController.text.trim();
            String email = _emailController.text.trim();
            String phone = _phoneController.text.trim();
            String password = _passwordController.text.trim();
            String confirmPassword = _confirmPasswordController.text.trim();
            String numberWithCountryCode = _countryDialCode!+phone;
            PhoneValid phoneValid = await CustomValidator.isPhoneValid(numberWithCountryCode);
            numberWithCountryCode = phoneValid.phone;

            if(deliverymanController.pickedImage == null) {
              showCustomSnackBar('upload_delivery_man_image'.tr);
            }else if(fName.isEmpty) {
              showCustomSnackBar('enter_delivery_man_first_name'.tr);
            }else if(lName.isEmpty) {
              showCustomSnackBar('enter_delivery_man_last_name'.tr);
            }else if(deliverymanController.pickedImage == null) {
              showCustomSnackBar('pick_delivery_man_profile_image'.tr);
            }else if(phone.isEmpty) {
              showCustomSnackBar('enter_delivery_man_phone_number'.tr);
            }else if(email.isEmpty) {
              showCustomSnackBar('enter_delivery_man_email_address'.tr);
            }else if(!GetUtils.isEmail(email)) {
              showCustomSnackBar('enter_a_valid_email_address'.tr);
            }else if(!phoneValid.isValid) {
              showCustomSnackBar('enter_a_valid_phone_number'.tr);
            }else if(password.isEmpty) {
              showCustomSnackBar('enter_password_for_delivery_man'.tr);
            }else if(password != confirmPassword) {
              showCustomSnackBar('confirm_password_does_not_matched'.tr);
            }else if(!deliverymanController.spatialCheck || !deliverymanController.lowercaseCheck || !deliverymanController.uppercaseCheck || !deliverymanController.numberCheck || !deliverymanController.lengthCheck) {
              showCustomSnackBar('provide_valid_password'.tr);
            }else {
              deliverymanController.dmStatusChange(0.8);
            }
          }else{
            _addDeliveryMan(deliverymanController);
          }
        },
      );
    });
  }

  void _addDeliveryMan(DeliverymanRegistrationController deliverymanController) async {
    String fName = _fNameController.text.trim();
    String lName = _lNameController.text.trim();
    String email = _emailController.text.trim();
    String phone = _phoneController.text.trim();
    String password = _passwordController.text.trim();
    String identityNumber = _identityNumberController.text.trim();
    String numberWithCountryCode = _countryDialCode!+phone;

    bool customFieldEmpty = false;

    Map<String, dynamic> additionalData = {};
    List<FilePickerResult> additionalDocuments = [];
    List<String> additionalDocumentsInputType = [];

    if(deliverymanController.dmStatus != 0.4) {
      for (DataModel data in deliverymanController.dataList!) {
        bool isTextField = data.fieldType == 'text' || data.fieldType == 'number' || data.fieldType == 'email' || data.fieldType == 'phone';
        bool isDate = data.fieldType == 'date';
        bool isCheckBox = data.fieldType == 'check_box';
        bool isFile = data.fieldType == 'file';
        int index = deliverymanController.dataList!.indexOf(data);
        bool isRequired = data.isRequired == 1;

        if(isTextField) {
          if (kDebugMode) {
            print('=====check text field : ${deliverymanController.additionalList![index].text == ''}');
          }
          if(deliverymanController.additionalList![index].text != '') {
            additionalData.addAll({data.inputData! : deliverymanController.additionalList![index].text});
          } else {
            if(isRequired) {
              customFieldEmpty = true;
              showCustomSnackBar('${data.placeholderData} ${'can_not_be_empty'.tr}');
              break;
            }
          }
        } else if(isDate) {
          if (kDebugMode) {
            print('---check date : ${deliverymanController.additionalList![index]}');
          }
          if(deliverymanController.additionalList![index] != null) {
            additionalData.addAll({data.inputData! : deliverymanController.additionalList![index]});
          } else {
            if(isRequired) {
              customFieldEmpty = true;
              showCustomSnackBar('${data.placeholderData} ${'can_not_be_empty'.tr}');
              break;
            }
          }
        } else if(isCheckBox) {
          List<String> checkData = [];
          bool noNeedToGoElse = false;
          for(var e in deliverymanController.additionalList![index]) {
            if(e != 0) {
              checkData.add(e);
              customFieldEmpty = false;
              noNeedToGoElse = true;
            } else if(!noNeedToGoElse) {
              customFieldEmpty = true;
            }
          }
          if(customFieldEmpty && isRequired) {
            showCustomSnackBar( '${'please_set_data_in'.tr} ${deliverymanController.dataList![index].inputData?.replaceAll('_', ' ').toTitleCase()} ${'field'.tr}');
            break;
          } else {
            additionalData.addAll({data.inputData! : checkData});
          }

        } else if(isFile) {
          if (kDebugMode) {
            print('---check file : ${deliverymanController.additionalList![index]}');
          }
          if(deliverymanController.additionalList![index].length == 0 && isRequired) {
            customFieldEmpty = true;
            showCustomSnackBar('${'please_add'.tr} ${deliverymanController.dataList![index].inputData?.replaceAll('_', ' ').toTitleCase()}');
            break;
          } else {
            deliverymanController.additionalList![index].forEach((file) {
              additionalDocuments.add(file);
              additionalDocumentsInputType.add(deliverymanController.dataList![index].inputData!);
            });
          }
        }
      }
    }

    if(ResponsiveHelper.isDesktop(context)){
      PhoneValid phoneValid = await CustomValidator.isPhoneValid(numberWithCountryCode);
      numberWithCountryCode = phoneValid.phone;

      if(deliverymanController.pickedImage == null) {
        showCustomSnackBar('upload_delivery_man_image'.tr);
      }else if(fName.isEmpty) {
        showCustomSnackBar('enter_delivery_man_first_name'.tr);
      }else if(lName.isEmpty) {
        showCustomSnackBar('enter_delivery_man_last_name'.tr);
      }else if(deliverymanController.pickedImage == null) {
        showCustomSnackBar('pick_delivery_man_profile_image'.tr);
      }else if(phone.isEmpty) {
        showCustomSnackBar('enter_delivery_man_phone_number'.tr);
      }else if(email.isEmpty) {
        showCustomSnackBar('enter_delivery_man_email_address'.tr);
      }else if(!GetUtils.isEmail(email)) {
        showCustomSnackBar('enter_a_valid_email_address'.tr);
      }else if(!phoneValid.isValid) {
        showCustomSnackBar('enter_a_valid_phone_number'.tr);
      }else if(password.isEmpty) {
        showCustomSnackBar('enter_password_for_delivery_man'.tr);
      }else if(!deliverymanController.spatialCheck || !deliverymanController.lowercaseCheck || !deliverymanController.uppercaseCheck || !deliverymanController.numberCheck || !deliverymanController.lengthCheck) {
        showCustomSnackBar('provide_valid_password'.tr);
      }
    }

    if(deliverymanController.dmTypeIndex == 0) {
      showCustomSnackBar('please_select_deliveryman_type'.tr);
    }else if(deliverymanController.vehicleIndex == 0) {
      showCustomSnackBar('please_select_vehicle_for_the_deliveryman'.tr);
    }else if(deliverymanController.identityTypeIndex == 0) {
      showCustomSnackBar('please_select_identity_type_for_the_deliveryman'.tr);
    }else if(deliverymanController.selectedZoneIndex == 0) {
      showCustomSnackBar('please_select_zone_for_the_deliveryman'.tr);
    }else if(identityNumber.isEmpty) {
      showCustomSnackBar('enter_delivery_man_identity_number'.tr);
    }else if(deliverymanController.pickedIdentities.isEmpty) {
      showCustomSnackBar('please_select_identity_image'.tr);
    }else if(customFieldEmpty) {
      if (kDebugMode) {
        print('not provide addition data');
      }
    }else {

      Map<String, String> data = {};

      data.addAll(DeliveryManBodyModel(
        fName: fName, lName: lName, password: password, phone: numberWithCountryCode, email: email,
        identityNumber: identityNumber, identityType: deliverymanController.identityTypeList[deliverymanController.identityTypeIndex],
        earning: deliverymanController.dmTypeIndex == 1 ? '1' : '0', zoneId: deliverymanController.zoneList![deliverymanController.selectedZoneIndex!].id.toString(),
        vehicleId: deliverymanController.vehicles![deliverymanController.vehicleIndex!].id.toString(),
      ).toJson());

      data.addAll({
        'additional_data': jsonEncode(additionalData),
      });

      if (kDebugMode) {
        print('-------final data-- :  $data');
      }

      deliverymanController.registerDeliveryMan(data, additionalDocuments, additionalDocumentsInputType);

    }
  }

  List<DropdownItem<int>> _generateDropDownZoneList(List<ZoneModel>? zoneList) {
    List<DropdownItem<int>> generateZoneList = [];
    if(zoneList != null) {
      for(int index=0; index<zoneList.length; index++) {
        generateZoneList.add(DropdownItem<int>(value: index, child: SizedBox(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('${zoneList[index].name}'.tr),
          ),
        )));
      }
    }
    return generateZoneList;
  }

  List<int> _generateZoneIndexList(List<ZoneModel>? zoneList) {
    List<int> zoneIndexList = [];
    if(zoneList != null) {
      for (int index = 0; index < zoneList.length; index++) {
        zoneIndexList.add(index);
      }
    }
    return zoneIndexList;
  }

  List<DropdownItem<int>> _generateDropDownVehicleList(List<VehicleModel>? vehicles) {
    List<DropdownItem<int>> generateVehicleList = [];
    if(vehicles != null){
      for(int index=0; index<vehicles.length; index++) {
        generateVehicleList.add(DropdownItem<int>(value: index, child: SizedBox(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('${vehicles[index].type}'.tr),
          ),
        )));
      }
    }
    return generateVehicleList;
  }

  List<DropdownItem<int>> _generateDropDownDmTypeList(List<String?> dmTypeList) {
    List<DropdownItem<int>> generateDmTypeList = [];
    for(int index=0; index<dmTypeList.length; index++) {
      generateDmTypeList.add(DropdownItem<int>(value: index, child: SizedBox(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('${dmTypeList[index]?.tr}'),
        ),
      )));
    }
    return generateDmTypeList;
  }

  List<DropdownItem<int>> _generateDropDownIdentityTypeList(List<String> identityList) {
    List<DropdownItem<int>> identityTypeList = [];
    for(int index=0; index<identityList.length; index++) {
      identityTypeList.add(DropdownItem<int>(value: index, child: SizedBox(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(identityList[index].tr),
        ),
      )));
    }
    return identityTypeList;
  }
}
