import 'package:stackfood_multivendor/features/auth/controllers/restaurant_registration_controller.dart';
import 'package:stackfood_multivendor/features/auth/widgets/min_max_time_picker_widget.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:stackfood_multivendor/common/widgets/custom_button_widget.dart';
import 'package:stackfood_multivendor/common/widgets/custom_snackbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class CustomTimePickerWidget extends StatelessWidget {
  const CustomTimePickerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> time = [];
    for(int i = 1; i <= 60 ; i++){
      time.add(i.toString());
    }
    List<String> unit = ['minute', 'hours', 'days'];

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusExtraLarge)),
      insetPadding: const EdgeInsets.all(30),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Container(
        width: 500,
        padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
        child: GetBuilder<RestaurantRegistrationController>(
          builder: (restaurantRegiController) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('estimated_delivery_time'.tr , style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge)),
                const SizedBox(height: Dimensions.paddingSizeSmall),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                  child: Text(
                    'this_item_will_be_shown_in_the_user_app_website'.tr,
                    style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeLarge,color: Theme.of(context).disabledColor),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: Dimensions.paddingSizeLarge),

                Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                  SizedBox(
                    width: 70,
                    child: Text(
                      'minimum'.tr,
                      style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeLarge,color: Theme.of(context).disabledColor),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(),

                  SizedBox(
                    width: 70,
                    child: Text(
                      'maximum'.tr,
                      style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeLarge,color: Theme.of(context).disabledColor),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    width: 70,
                    child: Text(
                      'unit'.tr,
                      style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeLarge,color: Theme.of(context).disabledColor),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ]),
                const SizedBox(height: Dimensions.paddingSizeDefault),

                Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [

                  MinMaxTimePickerWidget(
                    times: time, onChanged: (int index)=> restaurantRegiController.minTimeChange(time[index]),
                    initialPosition: 10,
                  ),

                  Text(':', style: robotoBold),

                  MinMaxTimePickerWidget(
                    times: time, onChanged: (int index)=> restaurantRegiController.maxTimeChange(time[index]),
                    initialPosition: 10,
                  ),

                  MinMaxTimePickerWidget(
                    times: unit, onChanged: (int index) => restaurantRegiController.timeUnitChange(unit[index]),
                    initialPosition: 1,
                  ),

                ]),

                Padding(
                  padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeLarge),
                  child: Text(
                    '${restaurantRegiController.storeMinTime} - ${restaurantRegiController.storeMaxTime} ${restaurantRegiController.storeTimeUnit}',
                    style: robotoBold.copyWith(fontSize: Dimensions.fontSizeExtraLarge),
                  ),
                ),

                CustomButtonWidget(
                  width: 200,
                  buttonText: 'save'.tr,
                  onPressed: (){
                    int min = int.parse(restaurantRegiController.storeMinTime);
                    int max = int.parse(restaurantRegiController.storeMaxTime);
                    if(min < max){
                      Get.back();
                    }else{
                      showCustomSnackBar('maximum_delivery_time_can_not_be_smaller_then_minimum_delivery_time'.tr);
                    }
                  },
                ),

              ],
            );
          }
        ),
      ),
    );
  }
}
