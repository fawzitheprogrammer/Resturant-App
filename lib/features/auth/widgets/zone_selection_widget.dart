import 'package:stackfood_multivendor/features/auth/controllers/restaurant_registration_controller.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/common/widgets/custom_dropdown_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ZoneSelectionWidget extends StatelessWidget {
  final RestaurantRegistrationController restaurantRegController;
  final List<DropdownItem<int>> zoneList;
  const ZoneSelectionWidget({super.key, required this.restaurantRegController, required this.zoneList});

  @override
  Widget build(BuildContext context) {
    return restaurantRegController.zoneIds != null ? Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        color: Theme.of(context).cardColor,
        border: Border.all(color: Theme.of(context).primaryColor, width: 0.3)
      ),
      child: CustomDropdown<int>(
        onChange: (int? value, int index) {
          restaurantRegController.setZoneIndex(value);
        },
        dropdownButtonStyle: DropdownButtonStyle(
          height: 50,
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
        child: Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Text(restaurantRegController.zoneList![restaurantRegController.selectedZoneIndex!].name!.tr),
        ),
      ),
    ) : Center(child: Text('service_not_available_in_this_area'.tr));
  }
}