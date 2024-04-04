
import 'package:cloud_firestore/cloud_firestore.dart';

import 'PostComment.dart';

class Post{
  String postId;
  String imageUrl;
  String description;
  String posterId;
  DateTime datePosted;
  List<PostComment> comments;
  List<String> likesByUid;
  DocumentReference groupRef;
  Post({required this.postId, required this.imageUrl, required this.posterId, required this.description, required this.comments, required this.likesByUid, required this.groupRef, required this.datePosted});

  void setDescription(String newDescription){
    description = newDescription;
  }
}