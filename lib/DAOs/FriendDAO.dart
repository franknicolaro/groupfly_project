import '../models/Friend.dart';

abstract class FriendDao{
  Future<List<Friend>> getFriendsByUID(String uid);
}