import 'package:swift_tech_resto/features/home/domain/models/banner_model.dart';

abstract class HomeServiceInterface {
  Future<BannerModel?> getBannerList();
}
