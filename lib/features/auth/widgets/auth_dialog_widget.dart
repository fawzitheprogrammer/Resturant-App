import 'package:stackfood_multivendor/features/auth/widgets/sign_in_widget.dart';
import 'package:stackfood_multivendor/features/auth/widgets/sign_up_widget.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';
import 'package:stackfood_multivendor/util/images.dart';
import 'package:stackfood_multivendor/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthDialogWidget extends StatefulWidget {
  final bool exitFromApp;
  final bool backFromThis;
  const AuthDialogWidget({super.key, required this.exitFromApp, required this.backFromThis});

  @override
  AuthDialogWidgetState createState() => AuthDialogWidgetState();
}

class AuthDialogWidgetState extends State<AuthDialogWidget>  with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<Tab> _tabs = <Tab>[ Tab(text: 'login'.tr), Tab(text: 'sign_up'.tr) ];
  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: _tabController.index == 1 ? 720 : 720, width: 550,
        margin:  const EdgeInsets.all(Dimensions.paddingSizeDefault),
        decoration: context.width > 700 ? BoxDecoration(
          color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
          boxShadow: null,
        ) : null,
        child: SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.center, children: [
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                onPressed: () => Get.back(),
                icon: const Icon(Icons.clear),
              ),
            ),

            Image.asset(Images.logo, width: 60),
            const SizedBox(height: Dimensions.paddingSizeSmall),
            Image.asset(Images.logoName, width: 80),
            const SizedBox(height: Dimensions.paddingSizeExtraLarge),



            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeOverLarge),
              child: Align(
                alignment: Alignment.topLeft,
                child: TabBar(
                  controller: _tabController,
                  indicatorColor: Theme.of(context).primaryColor,
                  indicatorWeight: 3,
                  labelColor: Theme.of(context).primaryColor,
                  unselectedLabelColor: Theme.of(context).disabledColor,
                  unselectedLabelStyle: robotoRegular.copyWith(color: Theme.of(context).disabledColor, fontSize: Dimensions.fontSizeSmall),
                  labelStyle: robotoBold.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).primaryColor),
                  labelPadding: const EdgeInsets.symmetric(horizontal: Dimensions.radiusDefault, vertical: 0 ),
                  isScrollable: true,
                  indicatorSize: TabBarIndicatorSize.tab,
                  tabs: _tabs,
                  physics: const NeverScrollableScrollPhysics(),
                  onTap: (int ? value) {
                    setState(() {});
                  },
                ),
              ),
            ),

            Padding(
              padding : const EdgeInsets.symmetric(horizontal : Dimensions.paddingSizeOverLarge),
              child: Column( children: [
                SizedBox (
                  height : _tabController.index == 1 ? 520 : 520,
                  child: TabBarView(
                    controller: _tabController,
                    children: const [
                      SignInWidget(exitFromApp: true, backFromThis: true),
                      SingleChildScrollView(child: SignUpWidget()),
                    ],
                  ),
                ),
              ]
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
