import 'package:stackfood_multivendor/features/category/domain/models/category_model.dart';
import 'package:stackfood_multivendor/features/interest/domain/repositories/interest_repository_interface.dart';
import 'package:stackfood_multivendor/features/interest/domain/services/interest_service_interface.dart';
import 'package:flutter/material.dart';

class InterestService implements InterestServiceInterface {
  final InterestRepositoryInterface interestRepositoryInterface;
  InterestService({required this.interestRepositoryInterface});

  @override
  List<bool>? processCategorySelectedList(List<CategoryModel>? categoryList) {
    List<bool>? interestCategorySelectedList;
    if(categoryList != null) {
      interestCategorySelectedList = [];
      for (var category in categoryList) {
        debugPrint(category.name);
        interestCategorySelectedList.add(false);
      }
    }
    return interestCategorySelectedList;
  }

  @override
  Future<bool> saveUserInterests(List<int?> interests) async {
    return await interestRepositoryInterface.saveUserInterests(interests);
  }
}