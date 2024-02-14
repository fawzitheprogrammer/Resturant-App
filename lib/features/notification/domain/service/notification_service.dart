import 'package:stackfood_multivendor/features/notification/domain/models/notification_model.dart';
import 'package:stackfood_multivendor/features/notification/domain/repository/notification_repository_interface.dart';
import 'package:stackfood_multivendor/features/notification/domain/service/notification_service_interface.dart';
import 'package:stackfood_multivendor/helper/date_converter.dart';

class NotificationService implements NotificationServiceInterface {
  final NotificationRepositoryInterface notificationRepositoryInterface;
  NotificationService({required this.notificationRepositoryInterface});

  @override
  Future<List<NotificationModel>?> getList() async {
    List<NotificationModel>? notificationList = await notificationRepositoryInterface.getList();
    if(notificationList != null) {
      notificationList.sort((a, b) {
        return DateConverter.isoStringToLocalDate(a.updatedAt!).compareTo(DateConverter.isoStringToLocalDate(b.updatedAt!));
      });
      Iterable iterable = notificationList.reversed;
      notificationList = iterable.toList() as List<NotificationModel>?;
    }
    return notificationList;
  }

  @override
  void saveSeenNotificationCount(int count) {
    return notificationRepositoryInterface.saveSeenNotificationCount(count);
  }

  @override
  int? getSeenNotificationCount() {
    return notificationRepositoryInterface.getSeenNotificationCount();
  }

  @override
  List<int> getNotificationIdList() {
    return notificationRepositoryInterface.getNotificationIdList();
  }

  @override
  void addSeenNotificationIdList(List<int> notificationList) {
    notificationRepositoryInterface.addSeenNotificationIdList(notificationList);
  }

}