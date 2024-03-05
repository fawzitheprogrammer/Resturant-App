import 'package:swift_tech_resto/interface/repository_interface.dart';

abstract class CampaignRepositoryInterface implements RepositoryInterface {
  @override
  Future<dynamic> getList({int? offset, bool basicCampaign = false});
}
