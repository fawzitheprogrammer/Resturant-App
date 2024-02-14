import 'package:stackfood_multivendor/features/notification/domain/models/notification_model.dart';
import 'package:stackfood_multivendor/features/notification/domain/service/notification_service_interface.dart';
import 'package:get/get.dart';

class NotificationController extends GetxController implements GetxService {
  final NotificationServiceInterface notificationServiceInterface;
  NotificationController({required this.notificationServiceInterface});

  List<NotificationModel>? _notificationList;
  List<NotificationModel>? get notificationList => _notificationList;

  bool _hasNotification = false;
  bool get hasNotification => _hasNotification;

  Future<int> getNotificationList(bool reload) async {
    if(_notificationList == null || reload) {
      _notificationList = await notificationServiceInterface.getList();
      if(_notificationList != null) {
        _hasNotification = _notificationList!.length != getSeenNotificationCount();
      }
      update();
    }
    return _notificationList!.length;
  }

  void saveSeenNotificationCount(int count) {
    notificationServiceInterface.saveSeenNotificationCount(count);
  }

  int? getSeenNotificationCount() {
    return notificationServiceInterface.getSeenNotificationCount();
  }

  void clearNotification() {
    _notificationList = null;
  }

  void addSeenNotificationId(int id) {
    List<int> idList = [];
    idList.addAll(notificationServiceInterface.getNotificationIdList());
    idList.add(id);
    notificationServiceInterface.addSeenNotificationIdList(idList);
    update();
  }

  List<int>? getSeenNotificationIdList() {
    return notificationServiceInterface.getNotificationIdList();
  }

}