import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/common/widgets/custom_image_widget.dart';
import 'package:flutter/material.dart';

class ImageDialogWidget extends StatelessWidget {
  final String imageUrl;
  const ImageDialogWidget({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
      child: SizedBox(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),

              Container(
                margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Theme.of(context).primaryColor.withOpacity(0.20)),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CustomImageWidget(
                    image: imageUrl, fit: BoxFit.contain, height: MediaQuery.of(context).size.width - 130, width: MediaQuery.of(context).size.width,
                  ),
                ),
              ),
              const SizedBox(height: Dimensions.paddingSizeLarge),
            ]),
        ),
      ),
    );
  }
}