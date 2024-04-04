import '../models/FriendList.dart';

abstract class FriendDao{
  Future<FriendList> getFriendsByUID(String uid);
}