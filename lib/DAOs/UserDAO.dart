import 'package:groupfly_project/models/group_fly_user.dart';

abstract class UserDao{
  Future<void> insertGroupFlyUser(String email, String address, DateTime? dateOfBirth, String username);
  Future<GroupFlyUser> getGroupFlyUserByUID(String uid);
}