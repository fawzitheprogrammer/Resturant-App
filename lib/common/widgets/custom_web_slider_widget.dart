import 'package:flutter/material.dart';
class CustomWebSliderWidget extends StatefulWidget {
  final double height;
  final double weight;
  final List<int> productList;
  final int? showCount;
  final Function(int i, Widget c)  child;
  final NullableIndexedWidgetBuilder indexCallBack;
  const CustomWebSliderWidget({super.key, required this.height, required this.productList, this.showCount = 4, required this.child, required this.weight, required this.indexCallBack});

  @override
  State<CustomWebSliderWidget> createState() => _CustomWebSliderWidgetState();
}

class _CustomWebSliderWidgetState extends State<CustomWebSliderWidget> {

  final PageController pageController = PageController();
  int currentIndex = 0;

  void changeIndex(int index) {
    currentIndex = index;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return  SizedBox(
      height: widget.height, width: widget.weight,
      child: Stack(
        clipBehavior: Clip.none,
        fit: StackFit.expand,
        children: [
          PageView.builder(
            controller: pageController,
            itemCount: (widget.productList.length/widget.showCount!).ceil(),
            onPageChanged: (int index) => changeIndex(index),
            itemBuilder: (context, index1) {

              return ListView.builder(
                shrinkWrap: true,
                itemCount: widget.showCount!,
                  scrollDirection: Axis.horizontal,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index2) {
                  index2 = (index1 * widget.showCount!) + index1;

                return Flexible(child: index2 < widget.productList.length ? InkWell(
                  // onTap: () => widget.indexCallBack(index2),
                  child: widget.indexCallBack(context, index2)!
                ) : const SizedBox());
              });
            },
          ),

          currentIndex != 0 ? Positioned(
            top: 0, bottom: 0, left: 0,
            child: InkWell(
              onTap: () => pageController.previousPage(duration: const Duration(seconds: 1), curve: Curves.easeInOut),
              child: Container(
                height: 40, width: 40, alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle, color: Theme.of(context).cardColor,
                ),
                child: const Icon(Icons.arrow_back_ios),
              ),
            ),
          ) : const SizedBox(),

          currentIndex != ((widget.productList.length/widget.showCount!).ceil()-1) ? Positioned(
            top: 0, bottom: 0, right: 0,
            child: InkWell(
              onTap: () => pageController.nextPage(duration: const Duration(seconds: 1), curve: Curves.easeInOut),
              child: Container(
                height: 40, width: 40, alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle, color: Theme.of(context).cardColor,
                ),
                child: const Icon(Icons.arrow_forward_ios_sharp),
              ),
            ),
          ) : const SizedBox(),
        ],
      ),
    );
  }
}

class BannerCallbackModel {
  Widget child;
  int index;
  BannerCallbackModel({required this.index, required this.child});
}