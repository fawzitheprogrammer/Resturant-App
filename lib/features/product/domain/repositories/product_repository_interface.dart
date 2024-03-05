import 'package:swift_tech_resto/common/models/product_model.dart';
import 'package:swift_tech_resto/interface/repository_interface.dart';

abstract class ProductRepositoryInterface implements RepositoryInterface {
  @override
  Future<List<Product>?> getList({int? offset, String? type});
}
