import 'dart:io';

import 'package:stackfood_multivendor/common/widgets/my_text_field_widget.dart';
import 'package:stackfood_multivendor/features/auth/controllers/auth_controller.dart';
import 'package:stackfood_multivendor/features/profile/controllers/profile_controller.dart';
import 'package:stackfood_multivendor/features/profile/domain/models/userinfo_model.dart';
import 'package:stackfood_multivendor/features/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor/common/models/response_model.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/images.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:stackfood_multivendor/common/widgets/custom_button_widget.dart';
import 'package:stackfood_multivendor/common/widgets/custom_image_widget.dart';
import 'package:stackfood_multivendor/common/widgets/custom_snackbar_widget.dart';
import 'package:stackfood_multivendor/common/widgets/custom_text_field_widget.dart';
import 'package:stackfood_multivendor/common/widgets/footer_view_widget.dart';
import 'package:stackfood_multivendor/common/widgets/menu_drawer_widget.dart';
import 'package:stackfood_multivendor/common/widgets/not_logged_in_screen.dart';
import 'package:stackfood_multivendor/common/widgets/web_menu_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final FocusNode _firstNameFocus = FocusNode();
  final FocusNode _lastNameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _initCall();
  }

  void _initCall(){
    if(Get.find<AuthController>().isLoggedIn() && Get.find<ProfileController>().userInfoModel == null) {
      Get.find<ProfileController>().getUserInfo();
    }
    Get.find<ProfileController>().initData();
  }

  @override
  Widget build(BuildContext context) {
    bool isLoggedIn = Get.find<AuthController>().isLoggedIn();
    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      appBar: ResponsiveHelper.isDesktop(context) ? const WebMenuBar() : AppBar(
        title: Text('update_profile'.tr, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeExtraLarge),),
        centerTitle: true,
        leading: IconButton(
          onPressed: () =>Get.back(),
          icon: Icon(Icons.arrow_back_ios, color: Theme.of(context).textTheme.bodyLarge!.color),
        ),
        elevation: 0, backgroundColor: Theme.of(context).cardColor, actions: const [SizedBox()],),
      endDrawer: const MenuDrawerWidget(), endDrawerEnableOpenDragGesture: false,
      body: Column(
        children: [

          GetBuilder<ProfileController>(builder: (profileController) {
            if(profileController.userInfoModel != null && _phoneController.text.isEmpty) {
              _firstNameController.text = profileController.userInfoModel!.fName ?? '';
              _lastNameController.text = profileController.userInfoModel!.lName ?? '';
              _phoneController.text = profileController.userInfoModel!.phone ?? '';
              _emailController.text = profileController.userInfoModel!.email ?? '';
            }

            return Expanded(
              child: isLoggedIn ? profileController.userInfoModel != null ? ResponsiveHelper.isDesktop(context) ? webView(profileController, isLoggedIn) : Column(children: [

                Center(child: Stack(children: [
                  ClipOval(child: profileController.pickedFile != null ? GetPlatform.isWeb ? Image.network(
                    profileController.pickedFile!.path, width: 100, height: 100, fit: BoxFit.cover,
                  ) : Image.file(
                    File(profileController.pickedFile!.path), width: 100, height: 100, fit: BoxFit.cover,
                  ) : CustomImageWidget(
                    image: '${Get.find<SplashController>().configModel!.baseUrls!.customerImageUrl}/${profileController.userInfoModel!.image}',
                    height: 100, width: 100, fit: BoxFit.cover,
                  )),

                  Positioned(
                    bottom: 0, right: 0, top: 0, left: 0,
                    child: InkWell(
                      onTap: () => profileController.pickImage(),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.3), shape: BoxShape.circle,
                          border: Border.all(width: 1, color: Theme.of(context).primaryColor),
                        ),
                        child: Container(
                          margin: const EdgeInsets.all(25),
                          decoration: BoxDecoration(
                            border: Border.all(width: 2, color: Colors.white),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.camera_alt, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ])),

                Expanded(child: Scrollbar(child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                  child: Center(child: SizedBox(width: Dimensions.webMaxWidth, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                    Text(
                      'first_name'.tr,
                      style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
                    ),
                    const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                    MyTextFieldWidget(
                      hintText: 'first_name'.tr,
                      controller: _firstNameController,
                      focusNode: _firstNameFocus,
                      nextFocus: _lastNameFocus,
                      inputType: TextInputType.name,
                      capitalization: TextCapitalization.words,
                    ),
                    const SizedBox(height: Dimensions.paddingSizeLarge),

                    Text(
                      'last_name'.tr,
                      style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
                    ),
                    const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                    MyTextFieldWidget(
                      hintText: 'last_name'.tr,
                      controller: _lastNameController,
                      focusNode: _lastNameFocus,
                      nextFocus: _emailFocus,
                      inputType: TextInputType.name,
                      capitalization: TextCapitalization.words,
                    ),
                    const SizedBox(height: Dimensions.paddingSizeLarge),

                    Text(
                      'email'.tr,
                      style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
                    ),
                    const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                    MyTextFieldWidget(
                      hintText: 'email'.tr,
                      controller: _emailController,
                      focusNode: _emailFocus,
                      inputAction: TextInputAction.done,
                      inputType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: Dimensions.paddingSizeLarge),

                    Row(children: [
                      Text(
                        'phone'.tr,
                        style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
                      ),
                      const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                      Text('(${'non_changeable'.tr})', style: robotoRegular.copyWith(
                        fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).colorScheme.error,
                      )),
                    ]),
                    const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                    MyTextFieldWidget(
                      hintText: 'phone'.tr,
                      controller: _phoneController,
                      focusNode: _phoneFocus,
                      inputType: TextInputType.phone,
                      isEnabled: false,
                    ),

                  ]))),
                ))),

                SafeArea(
                  child: CustomButtonWidget(
                    isLoading: profileController.isLoading,
                    onPressed: () => _updateProfile(profileController),
                    margin: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                    buttonText: 'update'.tr,
                  ),
                ),

              ]) : const Center(child: CircularProgressIndicator()) : NotLoggedInScreen(callBack: (value){
                _initCall();
                setState(() {});
              }),
            );
          }),
        ],
      ),
    );
  }

  Widget webView(ProfileController profileController, bool isLoggedIn) {
    return SingleChildScrollView(
      controller: scrollController,
      child: Center(
        child: FooterViewWidget(
          child: SizedBox(
            width: Dimensions.webMaxWidth,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

              SizedBox(
                height: 243,
                child: Stack(
                  children: [
                    Container(
                      height: 162,
                      width: Dimensions.webMaxWidth,
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor.withOpacity(0.10),
                          image: const DecorationImage(image: AssetImage(Images.profileBackground), fit: BoxFit.fitWidth)
                      ),
                      child: Align(
                          alignment: Alignment.topCenter,
                          child: Padding(
                              padding: const EdgeInsets.only(top: Dimensions.paddingSizeDefault),
                              child: Text('edit_profile'.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge)))),
                    ),

                    Positioned(
                      top: 95, left: 0, right: 0,
                      child: Stack(children: [
                        Center(
                          child: ClipOval(child: profileController.pickedFile != null ? GetPlatform.isWeb ? Image.network(
                            profileController.pickedFile!.path, width: 100, height: 100, fit: BoxFit.cover,
                          ) : Image.file(
                            File(profileController.pickedFile!.path), width: 100, height: 100, fit: BoxFit.cover,
                          ) : CustomImageWidget(
                            image: '${Get.find<SplashController>().configModel!.baseUrls!.customerImageUrl}/${profileController.userInfoModel!.image}',
                            height: 100, width: 100, fit: BoxFit.cover,
                          )),
                        ),
                        Positioned(
                          bottom: 0, right: 0, top: 0, left: 0,
                          child: InkWell(
                            onTap: () => profileController.pickImage(),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.3), shape: BoxShape.circle,
                                border: Border.all(width: 1, color: Theme.of(context).primaryColor),
                              ),
                              child: Container(
                                margin: const EdgeInsets.all(25),
                                decoration: BoxDecoration(
                                  border: Border.all(width: 2, color: Colors.white),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.camera_alt, color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ]),
                    ),

                  ],
                ),
              ),
              const SizedBox(height: Dimensions.paddingSizeLarge),

              Row(children: [
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(
                    'first_name'.tr,
                    style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeDefault),
                  CustomTextFieldWidget(
                    hintText: 'first_name'.tr,
                    controller: _firstNameController,
                    focusNode: _firstNameFocus,
                    nextFocus: _lastNameFocus,
                    inputType: TextInputType.name,
                    capitalization: TextCapitalization.words,
                  ),
                ])),
                const SizedBox(width: Dimensions.paddingSizeLarge),

                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(
                    'last_name'.tr,
                    style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeDefault),
                  CustomTextFieldWidget(
                    hintText: 'last_name'.tr,
                    controller: _lastNameController,
                    focusNode: _lastNameFocus,
                    nextFocus: _emailFocus,
                    inputType: TextInputType.name,
                    capitalization: TextCapitalization.words,
                  ),
                ])),
              ]),
              const SizedBox(height: Dimensions.paddingSizeExtraLarge),

              Text(
                'email'.tr,
                style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
              ),
              const SizedBox(height: Dimensions.paddingSizeDefault),
              CustomTextFieldWidget(
                hintText: 'email'.tr,
                controller: _emailController,
                focusNode: _emailFocus,
                inputAction: TextInputAction.done,
                inputType: TextInputType.emailAddress,
              ),
              const SizedBox(height: Dimensions.paddingSizeExtraLarge),

              Row(children: [
                Text(
                  'phone'.tr,
                  style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
                ),
                const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                Text('(${'non_changeable'.tr})', style: robotoRegular.copyWith(
                  fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).colorScheme.error,
                )),
              ]),
              const SizedBox(height: Dimensions.paddingSizeDefault),

              CustomTextFieldWidget(
                hintText: 'phone'.tr,
                controller: _phoneController,
                focusNode: _phoneFocus,
                inputType: TextInputType.phone,
                isEnabled: false,
              ),
              const SizedBox(height: Dimensions.paddingSizeDefault),

              Row(children: [
                const Expanded(child: SizedBox()),

                CustomButtonWidget(
                  width: 200,
                  buttonText: 'update_profile'.tr,
                  onPressed: () => _updateProfile(profileController),
                )
              ])
            ]),
          ),
        ),
      ),
    );
  }

  void _updateProfile(ProfileController profileController) async {
    String firstName = _firstNameController.text.trim();
    String lastName = _lastNameController.text.trim();
    String email = _emailController.text.trim();
    String phoneNumber = _phoneController.text.trim();
    if (profileController.userInfoModel!.fName == firstName &&
        profileController.userInfoModel!.lName == lastName && profileController.userInfoModel!.phone == phoneNumber &&
        profileController.userInfoModel!.email == _emailController.text && profileController.pickedFile == null) {
      showCustomSnackBar('change_something_to_update'.tr);
    }else if (firstName.isEmpty) {
      showCustomSnackBar('enter_your_first_name'.tr);
    }else if (lastName.isEmpty) {
      showCustomSnackBar('enter_your_last_name'.tr);
    }else if (email.isEmpty) {
      showCustomSnackBar('enter_email_address'.tr);
    }else if (!GetUtils.isEmail(email)) {
      showCustomSnackBar('enter_a_valid_email_address'.tr);
    }else if (phoneNumber.isEmpty) {
      showCustomSnackBar('enter_phone_number'.tr);
    }else if (phoneNumber.length < 6) {
      showCustomSnackBar('enter_a_valid_phone_number'.tr);
    } else {
      UserInfoModel updatedUser = UserInfoModel(fName: firstName, lName: lastName, email: email, phone: phoneNumber);
      ResponseModel responseModel = await profileController.updateUserInfo(updatedUser, Get.find<AuthController>().getUserToken());
      if(responseModel.isSuccess) {
        showCustomSnackBar('profile_updated_successfully'.tr, isError: false);
      }else {
        showCustomSnackBar(responseModel.message);
      }
    }
  }
}
