import 'package:swift_tech_resto/common/models/product_model.dart';
import 'package:swift_tech_resto/features/product/domain/models/basic_campaign_model.dart';
import 'package:swift_tech_resto/features/product/domain/repositories/campaign_repository_interface.dart';
import 'package:swift_tech_resto/features/product/domain/services/campaign_service_interface.dart';

class CampaignService implements CampaignServiceInterface {
  final CampaignRepositoryInterface campaignRepositoryInterface;

  CampaignService({required this.campaignRepositoryInterface});

  @override
  Future<List<BasicCampaignModel>?> getBasicCampaignList() async {
    return await campaignRepositoryInterface.getList(basicCampaign: true);
  }

  @override
  Future<List<Product>?> getItemCampaignList() async {
    return await campaignRepositoryInterface.getList();
  }

  @override
  Future<BasicCampaignModel?> getCampaignDetails(String campaignID) async {
    return await campaignRepositoryInterface.get(campaignID);
  }
}
