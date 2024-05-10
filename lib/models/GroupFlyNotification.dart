import 'package:cloud_firestore/cloud_firestore.dart';

//GroupFlyNotification model.
class GroupFlyNotification{
  String docId;
  String requesterUid;
  String requesteeUid;
  String type;
  DocumentReference groupRef;

  GroupFlyNotification({required this.docId, required this.requesterUid, required this.requesteeUid, required this.type, required this.groupRef});
}