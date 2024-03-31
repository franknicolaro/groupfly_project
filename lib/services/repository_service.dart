import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:groupfly_project/DAOs/UserDAO.dart';
import 'package:groupfly_project/models/group_fly_user.dart';

import '../DAOs/FriendDAO.dart';
import '../DAOs/GroupDAO.dart';
import '../DAOs/HobbyDAO.dart';
import '../DAOs/PostDAO.dart';
import '../models/Friend.dart';
import '../models/Group.dart';
import '../models/Hobby.dart';
import '../models/Post.dart';


abstract class RepositoryService{
  Future<GroupFlyUser> getGroupFlyUserByUID(String uid);
  Future<void> insertGroupFlyUser(String email, String password, DateTime? dateOfBirth, String username);
  Future<void> insertHobbies(List<Hobby> selectedHobbies);
  List<Hobby> getAllHobbies();
  Future<List<Friend>>getFriendsByUID(String uid);
  Future<List<Group>>getGroupsByMemberUID(String memberUID);
  Future<List<Post>>getPostsByUID(String uid);
  Future<Group>getGroupByPostReference(DocumentReference ref);
  Future<void> removeLike(String uid, String postId);
  Future<void> addLike(String uid, String postId);
  Future<void> addComment(GroupFlyUser user, String text, String postId);
  Future<void> insertPost(Post post);
  Future<List<GroupFlyUser>> searchProfileByName(String name);
  Future<List<Group>> searchGroupsByName(String title);
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

  @override
  Future<Group>getGroupByPostReference(DocumentReference ref){
    return GetIt.instance<GroupDao>().getGroupByPostReference(ref);
  }
  
  @override
  Future<List<Post>> getPostsByUID(String uid) {
    return GetIt.instance<PostDao>().getPostsByUID(uid);
  }

  @override
  Future<void> removeLike(String uid, String postId){
    return GetIt.instance<PostDao>().removeLike(uid, postId);
  }
  @override
  Future<void> addLike(String uid, String postId){
    return GetIt.instance<PostDao>().addLike(uid, postId);
  }
  
  @override
  Future<void> addComment(GroupFlyUser user, String text, String postId) {
    return GetIt.instance<PostDao>().addComment(user, text, postId);
  }
  
  @override
  Future<void> insertPost(Post post) {
    return GetIt.instance<PostDao>().addPost(post);
  }
  
  @override
  Future<List<GroupFlyUser>> searchProfileByName(String name) {
    return GetIt.instance<UserDao>().searchProfileByName(name);
  }
  
  @override
  Future<List<Group>> searchGroupsByName(String title) {
    return GetIt.instance<GroupDao>().searchGroupsByName(title);
  }
  
  @override
  List<Hobby> getAllHobbies() {
    return GetIt.instance<HobbyDao>().getAllHobbies();
  }
}