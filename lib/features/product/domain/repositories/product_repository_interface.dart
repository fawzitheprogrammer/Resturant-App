import 'package:stackfood_multivendor/common/models/product_model.dart';
import 'package:stackfood_multivendor/interface/repository_interface.dart';

abstract class ProductRepositoryInterface implements RepositoryInterface {

  @override
  Future<List<Product>?> getList({int? offset, String? type});
}