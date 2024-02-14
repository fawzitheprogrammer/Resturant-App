import 'package:stackfood_multivendor/features/address/domain/models/address_model.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
class AddressDetailsWidget extends StatelessWidget {
  final AddressModel? addressDetails;
  const AddressDetailsWidget({super.key, required this.addressDetails,});

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        addressDetails!.address ?? '',
        style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall), maxLines: 4, overflow: TextOverflow.ellipsis,
      ),
      const SizedBox(height: 5),

      Wrap(children: [
        (addressDetails!.road != null && addressDetails!.road!.isNotEmpty) ? Text('${'street_number'.tr}: ${addressDetails!.road!}${(addressDetails!.house != null && addressDetails!.house!.isNotEmpty) ?',' : ' '}',
          style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall), maxLines: 2, overflow: TextOverflow.ellipsis,
        ) : const SizedBox(),

        (addressDetails!.house != null && addressDetails!.house!.isNotEmpty) ? Text('${'house'.tr}: ${addressDetails!.house!}${(addressDetails!.floor != null && addressDetails!.floor!.isNotEmpty) ?',' : ' '}',
          style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall), maxLines: 2, overflow: TextOverflow.ellipsis,
        ) : const SizedBox(),

        (addressDetails!.floor != null && addressDetails!.floor!.isNotEmpty) ? Text('${'floor'.tr}: ${addressDetails!.floor!}' ,
          style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall), maxLines: 2, overflow: TextOverflow.ellipsis,
        ) : const SizedBox(),

      ]),
    ]);
  }
}

