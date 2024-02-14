import 'dart:convert';

import 'package:stackfood_multivendor/api/api_client.dart';
import 'package:stackfood_multivendor/features/notification/domain/models/notification_model.dart';
import 'package:stackfood_multivendor/features/notification/domain/repository/notification_repository_interface.dart';
import 'package:stackfood_multivendor/util/app_constants.dart';
import 'package:get/get_connect.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationRepository implements NotificationRepositoryInterface {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;
  NotificationRepository({required this.apiClient, required this.sharedPreferences});

  @override
  void saveSeenNotificationCount(int count) {
    sharedPreferences.setInt(AppConstants.notificationCount, count);
  }

  @override
  int? getSeenNotificationCount() {
    return sharedPreferences.getInt(AppConstants.notificationCount);
  }

  @override
  List<int> getNotificationIdList() {
    List<String>? list = [];
    if(sharedPreferences.containsKey(AppConstants.notificationIdList)) {
      list = sharedPreferences.getStringList(AppConstants.notificationIdList);
    }
    List<int> notificationIdList = [];
    for (var id in list!) {
      notificationIdList.add(jsonDecode(id));
    }
    return notificationIdList;
  }

  @override
  void addSeenNotificationIdList(List<int> notificationList) {
    List<String> list = [];
    for (int id in notificationList) {
      list.add(jsonEncode(id));
    }
    sharedPreferences.setStringList(AppConstants.notificationIdList, list);
  }

  @override
  Future add(value) {
    throw UnimplementedError();
  }

  @override
  Future delete(int? id) {
    throw UnimplementedError();
  }

  @override
  Future get(String? id) {
    throw UnimplementedError();
  }

  @override
  Future<List<NotificationModel>?> getList({int? offset}) async {
    List<NotificationModel>? notificationList;
    Response response = await apiClient.getData(AppConstants.notificationUri);
    if (response.statusCode == 200) {
      notificationList = [];
      response.body.forEach((notification) => notificationList!.add(NotificationModel.fromJson(notification)));
    }
    return notificationList;
  }

  @override
  Future update(Map<String, dynamic> body, int? id) {
    throw UnimplementedError();
  }

}