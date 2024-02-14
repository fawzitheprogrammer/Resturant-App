import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:flutter/material.dart';

class CustomLoaderWidget extends StatelessWidget {
  const CustomLoaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: Container(
      height: 100, width: 100,
      decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
      alignment: Alignment.center,
      child: const CircularProgressIndicator(),
    ));
  }
}
