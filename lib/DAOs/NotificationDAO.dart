import '../models/GroupFlyNotification.dart';

//Notification Data Access Object
abstract class NotificationDao{
  Future<List<GroupFlyNotification>> getAllNotificationsByRequesteeUid(String requesteeUid);
  Future<void> removeNotification(GroupFlyNotification notification);
  Future<void> sendFriendRequestNotification(String requesterUid, String requesteeUid);
  Future<void> sendGroupRequestNotification(GroupFlyNotification notification);
  Future<void> sendGroupInviteNotification(GroupFlyNotification notification);
}