import 'package:stackfood_multivendor/interface/repository_interface.dart';

abstract class CampaignRepositoryInterface implements RepositoryInterface {
  @override
  Future<dynamic> getList({int? offset, bool basicCampaign = false});
}