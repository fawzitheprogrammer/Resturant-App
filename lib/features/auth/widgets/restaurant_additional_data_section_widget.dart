import 'dart:io';
import 'package:stackfood_multivendor/features/auth/controllers/restaurant_registration_controller.dart';
import 'package:stackfood_multivendor/helper/date_converter.dart';
import 'package:stackfood_multivendor/helper/extensions.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/images.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:stackfood_multivendor/common/widgets/custom_text_field_widget.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RestaurantAdditionalDataSectionWidget extends StatelessWidget {
  final RestaurantRegistrationController restaurantRegiController;
  final ScrollController scrollController;
  const RestaurantAdditionalDataSectionWidget({super.key, required this.restaurantRegiController, required this.scrollController});

  @override
  Widget build(BuildContext context) {

    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: restaurantRegiController.dataList!.length,
      itemBuilder: (context, index) {
        bool showTextField = restaurantRegiController.dataList![index].fieldType == 'text' || restaurantRegiController.dataList![index].fieldType == 'number' || restaurantRegiController.dataList![index].fieldType == 'email' || restaurantRegiController.dataList![index].fieldType == 'phone';
        bool showDate = restaurantRegiController.dataList![index].fieldType == 'date';
        bool showCheckBox = restaurantRegiController.dataList![index].fieldType == 'check_box';
        bool showFile = restaurantRegiController.dataList![index].fieldType == 'file';
        return Padding(
          padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeExtraLarge),
          child: showTextField ? CustomTextFieldWidget(
            hintText: restaurantRegiController.dataList![index].placeholderData ?? '',
            controller: restaurantRegiController.additionalList![index],
            inputType: restaurantRegiController.dataList![index].fieldType == 'number' ? TextInputType.number
                : restaurantRegiController.dataList![index].fieldType == 'phone' ? TextInputType.phone
                : restaurantRegiController.dataList![index].fieldType == 'email' ? TextInputType.emailAddress
                : TextInputType.text,
            isRequired: restaurantRegiController.dataList![index].isRequired == 1,
            capitalization: TextCapitalization.words,
          ) : showDate ? Container(
            height: 50,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                color: Theme.of(context).cardColor,
                border: Border.all(color: Theme.of(context).primaryColor, width: 0.3)
            ),
            padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
            child: Row(children: [
              Expanded(child: Text(
                restaurantRegiController.additionalList![index] ?? 'not_set_yet'.tr,
                style: robotoMedium,
              )),

              IconButton(
                onPressed: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );
                  if (pickedDate != null) {
                    String formattedDate = DateConverter.dateTimeForCoupon(pickedDate);
                    restaurantRegiController.setAdditionalDate(index, formattedDate);
                  }
                },
                icon: const Icon(Icons.date_range_sharp),
              )
            ]),
          ) : showCheckBox ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              restaurantRegiController.dataList![index].inputData?.replaceAll('_', ' ').toTitleCase() ?? '',
              style: robotoMedium,
            ),
            ListView.builder(
              itemCount: restaurantRegiController.dataList![index].checkData!.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              itemBuilder: (context, i) {
                return Row(children: [
                  Checkbox(
                      activeColor: Theme.of(context).primaryColor,
                      value: restaurantRegiController.additionalList![index][i] == restaurantRegiController.dataList![index].checkData![i],
                      onChanged: (bool? isChecked) {
                        restaurantRegiController.setAdditionalCheckData(index, i, restaurantRegiController.dataList![index].checkData![i]);
                      }
                  ),
                  Text(
                    restaurantRegiController.dataList![index].checkData![i],
                    style: robotoRegular,
                  ),
                ]);
              },
            )

          ]) : showFile ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              restaurantRegiController.dataList![index].inputData?.replaceAll('_', ' ').toTitleCase() ?? '',
              style: robotoMedium,
            ),
            const SizedBox(height: Dimensions.paddingSizeSmall),

            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: restaurantRegiController.additionalList![index].length + 1,
              shrinkWrap: true,
              itemBuilder: (context, i) {
                FilePickerResult? file = i == restaurantRegiController.additionalList![index].length ? null : restaurantRegiController.additionalList![index][i];
                bool isImage = false;
                String fileName = '';
                bool canAddMultipleImage = restaurantRegiController.dataList![index].mediaData!.uploadMultipleFiles == 1;
                if(file != null) {
                  if(!GetPlatform.isWeb) {
                    fileName = file.files.single.path!.split('/').last;
                    isImage = file.files.single.path!.contains('jpg') || file.files.single.path!.contains('jpeg') || file.files.single.path!.contains('png');
                  } else {
                    fileName = file.files.first.name;
                    isImage = file.files.first.name.contains('jpg') || file.files.first.name.contains('jpeg') || file.files.first.name.contains('png');
                  }

                }
                if(i == restaurantRegiController.additionalList![index].length && (restaurantRegiController.additionalList![index].length < (canAddMultipleImage ? 6 : 1))) {
                  return InkWell(
                    onTap: () async {
                      await restaurantRegiController.pickFile(index, restaurantRegiController.dataList![index].mediaData!);
                    },
                    child: Container(
                      height: 100, width: 500,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                      ),
                      alignment: Alignment.center,
                      margin: const EdgeInsets.only(bottom: 10),
                      child: Icon(Icons.add, size: 50, color: Theme.of(context).disabledColor),
                    ),
                  );
                }
                return file != null ? Stack(
                  children: [
                    Container(
                      height: 100, width: double.infinity,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                        border: Border.all(color: Theme.of(context).primaryColor, width: 0.3),
                      ),
                      margin: const EdgeInsets.only(bottom: 10),
                      child: Center(
                        child: isImage && !GetPlatform.isWeb ? ClipRRect(
                          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                          child: GetPlatform.isWeb ? Image.network(
                            file.files.single.path!, width: 100, height: 100, fit: BoxFit.cover,
                          ) : Image.file(
                            File(file.files.single.path!), width: 500, height: 100, fit: BoxFit.cover,
                          ),
                        ) : Padding(
                          padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                          child: SizedBox(
                            width: double.infinity,
                            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                              Image.asset(fileName.contains('doc') ? Images.documentIcon : Images.pdfIcon, height: 20, width: 20, fit: BoxFit.contain),
                              const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                              Text(
                                fileName,
                                style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall), textAlign: TextAlign.center,
                              ),
                            ]),
                          ),
                        ),
                      ),
                    ),

                    Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        onPressed: (){
                          restaurantRegiController.removeAdditionalFile(index, i);
                        },
                        icon: const Icon(CupertinoIcons.delete_simple, color: Colors.red),
                      ),
                    )
                  ],
                ) : const SizedBox();
              },
            )
          ])
              : const SizedBox(),
        );
      },
    );
  }
}
