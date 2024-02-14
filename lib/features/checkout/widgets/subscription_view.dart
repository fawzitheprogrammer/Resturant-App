import 'package:stackfood_multivendor/features/checkout/controllers/checkout_controller.dart';
import 'package:stackfood_multivendor/features/checkout/widgets/custom_date_picker.dart';
import 'package:stackfood_multivendor/helper/date_converter.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:stackfood_multivendor/common/widgets/custom_dropdown_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SubscriptionView extends StatelessWidget {
  final CheckoutController checkoutController;
  const SubscriptionView({super.key, required this.checkoutController});

  @override
  Widget build(BuildContext context) {
    List<String> weekDays = ['monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday', 'sunday'];
    List<String> typeList = ['daily', 'weekly', 'monthly'];

    List<DropdownItem<int>> subscriptionTypeList = [];

    for(int index=0; index<typeList.length; index++) {
      subscriptionTypeList.add(DropdownItem<int>(value: index, child: SizedBox(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(typeList[index].tr),
        ),
      )));
    }

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [


      const SizedBox(height: Dimensions.paddingSizeLarge),

      Row(children: [
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('subscription_type'.tr, style: robotoMedium),
            const SizedBox(height: Dimensions.paddingSizeSmall),

            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                  color: Theme.of(context).cardColor,
                  border: Border.all(color: Theme.of(context).primaryColor, width: 0.3)
              ),
              child: CustomDropdown<int>(
                onChange: (int? value, int index) {
                  checkoutController.setSubscriptionType(typeList[index], index);
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
                items: subscriptionTypeList,
                child: Text(typeList[checkoutController.subscriptionTypeIndex].tr),
              ),
            ),
          ]),
        ),
        SizedBox(width: ResponsiveHelper.isDesktop(context) ? Dimensions.radiusDefault : 0),

        ResponsiveHelper.isDesktop(context) ? Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('subscription_date'.tr, style: robotoMedium),
          const SizedBox(height: Dimensions.paddingSizeSmall),

          CustomDatePicker(
            hint: 'choose_subscription_date'.tr,
            range: checkoutController.subscriptionRange,
            onDatePicked: (DateTimeRange range) => checkoutController.setSubscriptionRange(range),
          ),
        ])) : const SizedBox(),
      ]),
      SizedBox(height: ResponsiveHelper.isDesktop(context) ? 0 : Dimensions.paddingSizeLarge),

      !ResponsiveHelper.isDesktop(context) ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('subscription_date'.tr, style: robotoMedium),
        const SizedBox(height: Dimensions.paddingSizeSmall),

        CustomDatePicker(
          hint: 'choose_subscription_date'.tr,
          range: checkoutController.subscriptionRange,
          onDatePicked: (DateTimeRange range) => checkoutController.setSubscriptionRange(range),
        ),
      ]) : const SizedBox(),

      const SizedBox(height: Dimensions.paddingSizeLarge),

      checkoutController.subscriptionType != 'daily' ? Text('days'.tr, style: robotoMedium) : Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text('subscription_schedule'.tr, style: robotoMedium),
        InkWell(
          onTap: () async {
            TimeOfDay? time = await showTimePicker(context: context, initialTime: TimeOfDay.now());
            if(time != null) {
              checkoutController.addDay(0, time);
            }
          },
          child: Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
              border: Border.all(color: Theme.of(context).primaryColor, width: 0.3),
            ),
            child: Text(
              checkoutController.selectedDays[0] != null ? DateConverter.dateToTimeOnly(checkoutController.selectedDays[0]!) : 'choose_time'.tr,
              style: robotoRegular,
            ),
          ),
        ),
      ]),
      SizedBox(height: checkoutController.subscriptionType != 'daily' ? Dimensions.paddingSizeSmall : 0),

      checkoutController.subscriptionType != 'daily' ? SizedBox(child: GridView.builder(
          key: UniqueKey(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisSpacing: Dimensions.paddingSizeSmall,
            mainAxisSpacing: Dimensions.paddingSizeSmall,
            childAspectRatio: ResponsiveHelper.isDesktop(context) ? 2 : 1.5,
            crossAxisCount: ResponsiveHelper.isDesktop(context) ? 7 : 5,
          ),
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: checkoutController.subscriptionType == 'weekly' ? 7
              : checkoutController.subscriptionType == 'monthly' ? 31 : 0,
          itemBuilder: (context, index) {
            bool isSelected = checkoutController.selectedDays[index] != null;

            return InkWell(
              onTap: () async {
                if(checkoutController.selectedDays[index] != null) {
                  checkoutController.addDay(index, null);
                }else {
                  TimeOfDay? time = await showTimePicker(context: context, initialTime: const TimeOfDay(hour: 0, minute: 0));
                  if(time != null) {
                    checkoutController.addDay(index, time);
                  }
                }
              },
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.isDesktop(context) ? Dimensions.paddingSizeExtraSmall : 1),
                decoration: BoxDecoration(
                  color: isSelected ? Theme.of(context).primaryColor : Theme.of(context).colorScheme.background,
                  borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                ),
                child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text(
                    checkoutController.subscriptionType == 'monthly' ? '${'day'.tr} : ${index + 1}'
                        : checkoutController.subscriptionType == 'weekly' ? weekDays[index].tr : '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: robotoRegular.copyWith(color: isSelected ? Colors.white : Theme.of(context).hintColor, fontSize: Dimensions.fontSizeSmall),
                  ),
                  SizedBox(height: isSelected ? 2 : 0),
                  isSelected ? Text(
                    DateConverter.dateToTimeOnly(checkoutController.selectedDays[index]!),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: robotoRegular.copyWith(color: isSelected ? Colors.white : Theme.of(context).hintColor, fontSize: Dimensions.fontSizeExtraSmall),
                  ) : const SizedBox(),
                ]),
              ),
            );
          }),
      ) : const SizedBox(),
    ]);
  }
}
