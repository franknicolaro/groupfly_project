import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/Group.dart';

abstract class GroupDao{
  Future<List<Group>> getGroupsByMemberUID(String memberUID);
  Future<Group> getGroupByPostReference(DocumentReference groupRef);
  Future<List<Group>> searchGroupsByName(String title);
  Future<void> removeMember(String memberUID, String groupId);
  Future<void> disbandGroup(String groupId);
  Future<void> createGroup(Group group);
}