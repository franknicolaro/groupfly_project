import '../models/Group.dart';

abstract class GroupDao{
  Future<List<Group>> getGroupsByMemberUID(String memberUID);
}