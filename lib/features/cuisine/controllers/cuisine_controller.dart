import 'package:stackfood_multivendor/features/cuisine/domain/models/cuisine_model.dart';
import 'package:stackfood_multivendor/features/cuisine/domain/models/cuisine_restaurants_model.dart';
import 'package:stackfood_multivendor/features/cuisine/domain/services/cuisine_service_interface.dart';
import 'package:get/get.dart';

class CuisineController extends GetxController implements GetxService {
  final CuisineServiceInterface cuisineServiceInterface;
  CuisineController({required this.cuisineServiceInterface});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  CuisineModel? _cuisineModel;
  CuisineModel? get cuisineModel => _cuisineModel;

  CuisineRestaurantModel? _cuisineRestaurantsModel;
  CuisineRestaurantModel?  get cuisineRestaurantsModel => _cuisineRestaurantsModel;

  List<int>? _selectedCuisines;
  List<int>? get selectedCuisines => _selectedCuisines;

  int _currentIndex = 0;
  int get currentIndex => _currentIndex;

  void setCurrentIndex(int index, bool notify) {
    _currentIndex = index;
    if(notify) {
      update();
    }
  }

  void initialize(){
    _cuisineRestaurantsModel = null;
  }

  Future<List<int?>> getCuisineList() async {
    _selectedCuisines = [];
    _cuisineModel = await cuisineServiceInterface.getCuisineList();
    List<int?> cuisineIds = cuisineServiceInterface.generateCuisineIds(_cuisineModel);
    update();
    return cuisineIds;
  }

  Future<void> getCuisineRestaurantList(int cuisineId, int offset, bool reload) async {
    if(reload) {
      _cuisineRestaurantsModel = null;
      update();
    }
    CuisineRestaurantModel? restaurantModel = await cuisineServiceInterface.getRestaurantList(offset, cuisineId);
    if (restaurantModel != null) {
      if (offset == 1) {
        _cuisineRestaurantsModel = restaurantModel;
      }else {
        _cuisineRestaurantsModel!.totalSize = restaurantModel.totalSize;
        _cuisineRestaurantsModel!.offset = restaurantModel.offset;
        _cuisineRestaurantsModel!.restaurants!.addAll(restaurantModel.restaurants!);
      }
    }
    _isLoading = false;
    update();
  }

  void setSelectedCuisineIndex(int index, bool notify) {
    if(!_selectedCuisines!.contains(index)) {
      _selectedCuisines!.add(index);
      if(notify) {
        update();
      }
    }
  }

  void removeCuisine(int index) {
    _selectedCuisines!.removeAt(index);
    update();
  }
}