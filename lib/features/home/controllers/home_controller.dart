import 'package:stackfood_multivendor/features/home/domain/models/banner_model.dart';
import 'package:stackfood_multivendor/features/home/domain/services/home_service_interface.dart';
import 'package:stackfood_multivendor/helper/responsive_helper.dart';
import 'package:get/get.dart';

class HomeController extends GetxController implements GetxService {
  final HomeServiceInterface homeServiceInterface;

  HomeController({required this.homeServiceInterface});

  List<String?>? _bannerImageList;
  List<dynamic>? _bannerDataList;
  int _currentIndex = 0;

  List<String?>? get bannerImageList => _bannerImageList;
  List<dynamic>? get bannerDataList => _bannerDataList;
  int get currentIndex => _currentIndex;

  Future<void> getBannerList(bool reload) async {
    if(_bannerImageList == null || reload) {
      BannerModel? responseBanner = await homeServiceInterface.getBannerList();
      if (responseBanner != null) {
        _bannerImageList = [];
        _bannerDataList = [];
        for (var campaign in responseBanner.campaigns!) {
          _bannerImageList!.add(campaign.image);
          _bannerDataList!.add(campaign);
        }
        for (var banner in responseBanner.banners!) {
          _bannerImageList!.add(banner.image);
          if(banner.food != null) {
            _bannerDataList!.add(banner.food);
          }else {
            _bannerDataList!.add(banner.restaurant);
          }
        }
        if(ResponsiveHelper.isDesktop(Get.context) && _bannerImageList!.length % 2 != 0){
          _bannerImageList!.add(_bannerImageList![0]);
          _bannerDataList!.add(_bannerDataList![0]);
        }
      }
      update();
    }
  }

  void setCurrentIndex(int index, bool notify) {
    _currentIndex = index;
    if(notify) {
      update();
    }
  }

}