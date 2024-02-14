import 'package:stackfood_multivendor/features/product/domain/models/basic_campaign_model.dart';
import 'package:stackfood_multivendor/common/models/product_model.dart';
import 'package:stackfood_multivendor/features/product/domain/services/campaign_service_interface.dart';
import 'package:get/get.dart';

class CampaignController extends GetxController implements GetxService {
  final CampaignServiceInterface campaignServiceInterface;
  CampaignController({required this.campaignServiceInterface});

  List<BasicCampaignModel>? _basicCampaignList;
  List<BasicCampaignModel>? get basicCampaignList => _basicCampaignList;

  BasicCampaignModel? _campaign;
  BasicCampaignModel? get campaign => _campaign;

  List<Product>? _itemCampaignList;
  List<Product>? get itemCampaignList => _itemCampaignList;

  int _currentIndex = 0;
  int get currentIndex => _currentIndex;

  void setCurrentIndex(int index, bool notify) {
    _currentIndex = index;
    if(notify) {
      update();
    }
  }

  Future<void> getBasicCampaignList(bool reload) async {
    if(_basicCampaignList == null || reload) {
      _basicCampaignList = await campaignServiceInterface.getBasicCampaignList();
      update();
    }
  }

  Future<void> getBasicCampaignDetails(int? campaignID) async {
    _campaign = null;
    _campaign = await campaignServiceInterface.getCampaignDetails(campaignID.toString());
    update();
  }

  Future<void> getItemCampaignList(bool reload) async {
    if(_itemCampaignList == null || reload) {
      _itemCampaignList = await campaignServiceInterface.getItemCampaignList();
      update();
    }
  }

}