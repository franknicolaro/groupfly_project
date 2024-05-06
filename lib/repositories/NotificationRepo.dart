import 'dart:js_util';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:groupfly_project/models/GroupFlyNotification.dart';

import '../DAOs/NotificationDAO.dart';
import '../services/authorization_service.dart';

class NotificationRepo implements NotificationDao{
  final FirebaseFirestore firebaseDB = FirebaseFirestore.instance;
  Authorization _auth = Authorization();

  Future<List<GroupFlyNotification>> _getFriendRequests(String requesteeUid) async {
    List<GroupFlyNotification> friendRequests = [];
    CollectionReference friendReqCol = firebaseDB.collection('friend_request');
    await friendReqCol.where('requestee_uid', isEqualTo: requesteeUid).get().then((result) {
      if(result.docs.isNotEmpty){
        friendRequests = List.generate(result.docs.length, (i) {
          return GroupFlyNotification(
            docId: result.docs[i].id,
            requesteeUid: requesteeUid,
            requesterUid: result.docs[i]['requester_uid'],
            type: "friend_request",
            groupRef: firebaseDB.doc('user/${_auth.currentUser!.uid}') //This won't be utilized anyways, so just get a reference to the user.
          );
        });
      }
    });
    return friendRequests;
  }

  Future<List<GroupFlyNotification>> _getGroupRequests(String requesteeUid) async {
    List<GroupFlyNotification> groupRequests = [];
    CollectionReference groupReqCol = firebaseDB.collection('group_request');
    await groupReqCol.where('requestee_uid', isEqualTo: requesteeUid).get().then((result) {
      if(result.docs.isNotEmpty){
        groupRequests = List.generate(result.docs.length, (i) {
          return GroupFlyNotification(
            docId: result.docs[i].id,
            requesteeUid: requesteeUid,
            requesterUid: result.docs[i]['requester_uid'],
            type: "group_request",
            groupRef: result.docs[i]['group_ref']
          );
        });
      }
    });
    return groupRequests;
  }
  Future<List<GroupFlyNotification>> _getGroupInvites(String requesteeUid) async {
    List<GroupFlyNotification> groupInvites = [];
    CollectionReference groupInvCol = firebaseDB.collection('group_invite');
    await groupInvCol.where('requestee_uid', isEqualTo: requesteeUid).get().then((result) {
      if(result.docs.isNotEmpty){
        groupInvites = List.generate(result.docs.length, (i) {
          return GroupFlyNotification(
            docId: result.docs[i].id,
            requesteeUid: requesteeUid,
            requesterUid: result.docs[i]['requester_uid'],
            type: "group_invite",
            groupRef: result.docs[i]['group_ref']
          );
        });
      }
    });
    return groupInvites;
  }
  @override
  Future<List<GroupFlyNotification>> getAllNotificationsByRequesteeUid(String requesteeUid) async {
    List<GroupFlyNotification> notifications = [];
    notifications.addAll(await _getFriendRequests(requesteeUid));
    notifications.addAll(await _getGroupRequests(requesteeUid));
    notifications.addAll(await _getGroupInvites(requesteeUid));
    return notifications;
  }
  @override
  Future<void> removeNotification(GroupFlyNotification notification)async {
    if(notification.type == "friend_request"){
      firebaseDB.collection("friend_request").doc(notification.docId).delete();
    }
    else if(notification.type == "group_request"){
      firebaseDB.collection("group_request").doc(notification.docId).delete();
    }
    else{
      firebaseDB.collection("group_invite").doc(notification.docId).delete();
    }
  }
  
  @override
  Future<void> sendFriendRequestNotification(String requesterUid, String requesteeUid) async{
    firebaseDB.collection('friend_request').doc().set(
      {
        'requester_uid': requesterUid,
        'requestee_uid': requesteeUid
      }
    ).onError((error, stackTrace) => "Error adding notification to Firestore: $error");
  }
  @override
  Future<void> sendGroupRequestNotification(GroupFlyNotification notification) async{
    firebaseDB.collection('group_request').doc().set(
      {
        'requester_uid': notification.requesterUid,
        'requestee_uid': notification.requesteeUid,
        'group_ref': notification.groupRef
      }
    ).onError((error, stackTrace) => "Error adding notification to Firestore: $error");
  }
  @override
  Future<void> sendGroupInviteNotification(GroupFlyNotification notification) async{
    firebaseDB.collection('group_invite').doc().set(
      {
        'requester_uid': notification.requesterUid,
        'requestee_uid': notification.requesteeUid,
        'group_ref': notification.groupRef
      }
    ).onError((error, stackTrace) => "Error adding notification to Firestore: $error");
  }
}