import 'package:get_it/get_it.dart';
import 'package:groupfly_project/DAOs/UserDAO.dart';
import 'package:groupfly_project/models/group_fly_user.dart';

import '../DAOs/FriendDAO.dart';
import '../DAOs/GroupDAO.dart';
import '../DAOs/HobbyDAO.dart';
import '../models/Friend.dart';
import '../models/Group.dart';
import '../models/Hobby.dart';


abstract class RepositoryService{
  Future<GroupFlyUser> getGroupFlyUserByUID(String uid);
  Future<void> insertGroupFlyUser(String email, String password, DateTime? dateOfBirth, String username);
  Future<void> insertHobbies(List<Hobby> selectedHobbies);
  Future<List<Friend>>getFriendsByUID(String uid);
  Future<List<Group>>getGroupsByMemberUID(String memberUID);
}

class RepositoryServiceImpl implements RepositoryService{
  @override
  Future<GroupFlyUser> getGroupFlyUserByUID(String uid) {
    return GetIt.instance<UserDao>().getGroupFlyUserByUID(uid);
  }

  @override
  Future<void> insertGroupFlyUser(String email, String password, DateTime? dateOfBirth, String username) {
    return GetIt.instance<UserDao>().insertGroupFlyUser(email, password, dateOfBirth, username);
  }
  
  @override
  Future<void> insertHobbies(List<Hobby> selectedHobbies) {
    return GetIt.instance<HobbyDao>().insertHobbies(selectedHobbies);
  }

  @override
  Future<List<Friend>>getFriendsByUID(String uid){
    return GetIt.instance<FriendDao>().getFriendsByUID(uid);
  }

  @override
  Future<List<Group>>getGroupsByMemberUID(String memberUID){
    return GetIt.instance<GroupDao>().getGroupsByMemberUID(memberUID);
  }
}