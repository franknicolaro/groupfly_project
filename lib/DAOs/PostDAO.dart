import 'package:groupfly_project/models/group_fly_user.dart';

import '../models/FriendList.dart';
import '../models/Post.dart';

//Post Data Access Object
abstract class PostDao{
  Future<List<Post>> getPostsByUID(String uid);
  Future<List<Post>>getRecentPostsByFriendUIDs(GroupFlyUser user, FriendList friends);
  Future<void> removeLike(String uid, String postId);
  Future<void> addLike(String uid, String postId);
  Future<void> addComment(GroupFlyUser user, String text, String postId);
  Future<void> addPost(Post post);
}