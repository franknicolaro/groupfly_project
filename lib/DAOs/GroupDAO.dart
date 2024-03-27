import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/Group.dart';

abstract class GroupDao{
  Future<List<Group>> getGroupsByMemberUID(String memberUID);
  Future<Group> getGroupByPostReference(DocumentReference groupRef);
}