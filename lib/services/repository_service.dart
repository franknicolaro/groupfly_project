import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:groupfly_project/DAOs/UserDAO.dart';
import 'package:groupfly_project/models/GroupFlyNotification.dart';
import 'package:groupfly_project/models/group_fly_user.dart';

import '../DAOs/FriendDAO.dart';
import '../DAOs/GroupDAO.dart';
import '../DAOs/HobbyDAO.dart';
import '../DAOs/NotificationDAO.dart';
import '../DAOs/PostDAO.dart';
import '../models/FriendList.dart';
import '../models/Group.dart';
import '../models/Hobby.dart';
import '../models/Post.dart';

//Service class that connects Flutter to Firestore.

//Abstract class with all methods for retrieving and modifying data.
abstract class RepositoryService{
  Future<GroupFlyUser> getGroupFlyUserByUID(String uid);
  Future<void> insertGroupFlyUser(String email, String password, DateTime? dateOfBirth, String username);
  Future<void> insertHobbies(List<Hobby> selectedHobbies);
  List<Hobby> getAllHobbies();
  Future<FriendList>getFriendsByUID(String uid);
  Future<List<Group>>getGroupsByMemberUID(String memberUID);
  Future<List<Post>>getPostsByUID(String uid);
  Future<List<Post>>getRecentPostsByFriendUIDs(GroupFlyUser user, FriendList friends);
  Future<Group>getGroupByPostReference(DocumentReference ref);
  Future<void> removeLike(String uid, String postId);
  Future<void> addLike(String uid, String postId);
  Future<void> addComment(GroupFlyUser user, String text, String postId);
  Future<void> insertPost(Post post);
  Future<List<GroupFlyUser>> searchProfileByName(String name);
  Future<List<Group>> searchGroupsByName(String title);
  Future<void> removeMember(String memberUID, String groupId);
  Future<void> addMember(String memberUID, String groupId);
  Future<void> disbandGroup(String groupId);
  Future<void> createGroup(Group group);
  Future<void> deactivateUser(String uid);
  Future<void> activateUser(String uid);
  Future<void> initFriendDocument(String uid);
  Future<void> removeFriend(String uid, String frienduid);
  Future<void> addFriend(String uid, String frienduid);
  Future<List<GroupFlyNotification>> getAllNotificationsByRequesteeUid(String requesteeUid);
  Future<void> removeNotification(GroupFlyNotification notification);
  Future<void> sendFriendRequestNotification(String requesterUid, String requesteeUid);
  Future<void> sendGroupRequestNotification(GroupFlyNotification notification);
  Future<void> sendGroupInviteNotification(GroupFlyNotification notification);
}

//Implementation of abstract class. Each of these methods call
//To their the repository which correlates to the data that is being
//retrieved or modified. For this reason, comments explaining each of the methods
//will be placed within their respective Repository classes.
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
  Future<FriendList>getFriendsByUID(String uid){
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
  Future<List<Post>>getRecentPostsByFriendUIDs(GroupFlyUser user, FriendList friends){
    return GetIt.instance<PostDao>().getRecentPostsByFriendUIDs(user, friends);
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
  
  @override
  Future<void> removeMember(String memberUID, String groupId) {
    return GetIt.instance<GroupDao>().removeMember(memberUID, groupId);
  }
  @override
  Future<void> addMember(String memberUID, String groupId) {
    return GetIt.instance<GroupDao>().addMember(memberUID, groupId);
  }

  @override
  Future<void> disbandGroup(String groupId){
    return GetIt.instance<GroupDao>().disbandGroup(groupId);
  }
  
  @override
  Future<void> createGroup(Group group) {
    return GetIt.instance<GroupDao>().createGroup(group);
  }
  
  @override
  Future<void> deactivateUser(String uid) {
    return GetIt.instance<UserDao>().deactivateUser(uid);
  }
  @override
  Future<void> activateUser(String uid) {
    return GetIt.instance<UserDao>().activateUser(uid);
  }
  
  @override
  Future<void> initFriendDocument(String uid){
    return GetIt.instance<FriendDao>().initFriendDocument(uid);
  }
  @override
  Future<void> addFriend(String uid, String frienduid) {
    return GetIt.instance<FriendDao>().addFriend(uid, frienduid);
  }
  
  @override
  Future<void> removeFriend(String uid, String frienduid) {
    return GetIt.instance<FriendDao>().removeFriend(uid, frienduid);
  }
  
  @override
  Future<List<GroupFlyNotification>> getAllNotificationsByRequesteeUid(String requesteeUid) {
    return GetIt.instance<NotificationDao>().getAllNotificationsByRequesteeUid(requesteeUid);
  }
  
  @override
  Future<void> removeNotification(GroupFlyNotification notification) {
    return GetIt.instance<NotificationDao>().removeNotification(notification);
  }
  
  @override
  Future<void> sendFriendRequestNotification(String requesterUid, String requesteeUid) {
    return GetIt.instance<NotificationDao>().sendFriendRequestNotification(requesterUid, requesteeUid);
  }
  
  @override
  Future<void> sendGroupRequestNotification(GroupFlyNotification notification) {
    return GetIt.instance<NotificationDao>().sendGroupRequestNotification(notification);
  }
  @override
  Future<void> sendGroupInviteNotification(GroupFlyNotification notification) {
    return GetIt.instance<NotificationDao>().sendGroupInviteNotification(notification);
  }
}