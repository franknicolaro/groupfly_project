import '../models/Friend.dart';

abstract class FriendDao{
  Future<Friend> getFriendsByUID(String uid);
}