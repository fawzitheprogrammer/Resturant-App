import 'package:stackfood_multivendor/features/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor/common/models/product_model.dart';
import 'package:stackfood_multivendor/features/product/controllers/product_controller.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:stackfood_multivendor/common/widgets/custom_app_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class ImageViewerScreenWidget extends StatefulWidget {
  final Product product;
  const ImageViewerScreenWidget({super.key, required this.product});

  @override
  State<ImageViewerScreenWidget> createState() => _ImageViewerScreenWidgetState();
}

class _ImageViewerScreenWidgetState extends State<ImageViewerScreenWidget> {
  final PageController _pageController = PageController();

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Get.find<ProductController>().setImageIndex(0, false);
    List<String?> imageList = [];
    imageList.add(widget.product.image);

    return Scaffold(
      appBar: CustomAppBarWidget(title: 'product_images'.tr),
      body: SafeArea(
        child: GetBuilder<ProductController>(builder: (productController) {
          return Column(children: [

            Expanded(child:  PhotoViewGallery.builder(
              scrollPhysics: const BouncingScrollPhysics(),
              backgroundDecoration: BoxDecoration(color: ResponsiveHelper.isDesktop(context) ? Theme.of(context).canvasColor : Theme.of(context).cardColor),
              itemCount: imageList.length,
              pageController: _pageController,
              builder: (BuildContext context, int index) {
                return PhotoViewGalleryPageOptions(
                  imageProvider: NetworkImage('${Get.find<SplashController>().configModel!.baseUrls!.productImageUrl}/${imageList[index]}'),
                  initialScale: PhotoViewComputedScale.contained,
                  heroAttributes: PhotoViewHeroAttributes(tag: index.toString()),
                );
              },
              loadingBuilder: (context, event) => Center(child: SizedBox(width: 20.0, height: 20.0, child: CircularProgressIndicator(
                value: event == null ? 0 : event.cumulativeBytesLoaded / event.expectedTotalBytes!,
              ))),
              onPageChanged: (int index) => productController.setImageIndex(index, true)),
            ),

          ]);
        }),
      ),
    );
  }
}