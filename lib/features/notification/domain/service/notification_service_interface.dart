import 'package:swift_tech_resto/features/notification/domain/models/notification_model.dart';

abstract class NotificationServiceInterface {
  Future<List<NotificationModel>?> getList();
  void saveSeenNotificationCount(int count);
  int? getSeenNotificationCount();
  List<int> getNotificationIdList();
  void addSeenNotificationIdList(List<int> notificationList);
}
