import '../models/FriendList.dart';

abstract class FriendDao{
  Future<void> initFriendDocument(String uid);
  Future<FriendList> getFriendsByUID(String uid);
  Future<void> removeFriend(String uid, String frienduid);
  Future<void> addFriend(String uid, String frienduid);
}