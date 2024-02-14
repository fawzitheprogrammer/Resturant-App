import 'package:stackfood_multivendor/interface/repository_interface.dart';

abstract class FavouriteRepositoryInterface<Response> implements RepositoryInterface<Response> {
  @override
  Future<Response> add(dynamic a, {bool isRestaurant = false, int? id});
  @override
  Future<Response> delete(int? id, {bool isRestaurant = false});
}