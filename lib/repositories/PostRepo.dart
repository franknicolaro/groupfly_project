import 'package:cloud_firestore/cloud_firestore.dart';

import '../DAOs/PostDAO.dart';
import '../models/FriendList.dart';
import '../models/Post.dart';
import '../models/PostComment.dart';
import '../models/group_fly_user.dart';

//Implementation of PostDAO
class PostRepo implements PostDao{
  //Instance of Firestore
  final FirebaseFirestore firebaseDB = FirebaseFirestore.instance;

  //Gets all posts of a user based on the UID provided.
  @override
  Future<List<Post>> getPostsByUID(String uid) async{
    List<Post> posts = [];
    CollectionReference postCollection = firebaseDB.collection('post');
    await postCollection.where('poster_uid', isEqualTo: uid).get().then((result) {
      if(result.docs.isNotEmpty){
        posts = List.generate(result.docs.length, (i){
          return Post(
            postId: result.docs[i].id,
            posterId: uid,
            groupRef: result.docs[i]['group_ref'],
            description: result.docs[i]['caption'],
            imageUrl: result.docs[i]['image_name'],
            comments: List.generate(result.docs[i]['comments'].length, (j){
              return PostComment(
                text: result.docs[i]['comments'][j]['text'], 
                user_uid: result.docs[i]['comments'][j]['user_uid'],
                username: result.docs[i]['comments'][j]['username']
              );
            }),
            likesByUid: List.from(result.docs[i]['likes_by_uid']),
            datePosted: result.docs[i]['date_posted'].toDate()
          );
        });
      }
    },);
    return posts;
  }

  //Gets all recent posts based on the UIDs provided the FriendList
  @override
  Future<List<Post>>getRecentPostsByFriendUIDs(GroupFlyUser user, FriendList friends) async{
    List<Post> allRecentPosts = [];
    List<Post> friendPosts = [];
    DateTime now = DateTime.now();
    CollectionReference postCollection = firebaseDB.collection('post');
    for (var friendUid in friends.friend_uids) {
        await postCollection.where('poster_uid', isEqualTo: friendUid)
                          .where('date_posted', isGreaterThanOrEqualTo: now.subtract(Duration(days: user.homeFeedRecency!)))
                          .get().then((result) {
        if(result.docs.isNotEmpty){
          friendPosts = List.generate(result.docs.length, (i){
            return Post(
              postId: result.docs[i].id,
              posterId: result.docs[i]['poster_uid'],
              groupRef: result.docs[i]['group_ref'],
              description: result.docs[i]['caption'],
              imageUrl: result.docs[i]['image_name'],
              comments: List.generate(result.docs[i]['comments'].length, (j){
                return PostComment(
                  text: result.docs[i]['comments'][j]['text'], 
                  user_uid: result.docs[i]['comments'][j]['user_uid'],
                  username: result.docs[i]['comments'][j]['username']
                );
              }),
              likesByUid: List.from(result.docs[i]['likes_by_uid']),
              datePosted: result.docs[i]['date_posted'].toDate()
            );
          });
          allRecentPosts.addAll(friendPosts);
          allRecentPosts.sort((postOne, postTwo) => postOne.datePosted.compareTo(postTwo.datePosted));
        }
      },).catchError((error) => print("Error while trying to get friend posts: ${error}"));
    }
    return allRecentPosts;
  }
  
  //Adds a like to the provied postID with the specified UID.
  @override
  Future<void> addLike(String uid, String postId) async {
    firebaseDB.collection('post').doc(postId).update({
      'likes_by_uid': FieldValue.arrayUnion([uid])
    });
  }
  
  //Removes a like to the provied postID with the specified UID.
  @override
  Future<void> removeLike(String uid, String postId) async {
    firebaseDB.collection('post').doc(postId).update({
      'likes_by_uid': FieldValue.arrayRemove([uid])
    });
  }

  //Adds a comment to the provied post with the specified UID.
  @override
  Future<void> addComment(GroupFlyUser user, String text, String postId) async {
    firebaseDB.collection('post').doc(postId).update({
      'comments': FieldValue.arrayUnion([{
        'text': text,
        'user_uid': user.uid,
        'username': user.username
      }])
    });
  }
  
  //Adds a post to post collection.
  @override
  Future<void> addPost(Post post) async {
    firebaseDB.collection('post').doc().set(
      {
        'caption': post.description,
        'comments': post.comments,
        'group_ref': post.groupRef,
        'image_name': post.imageUrl,
        'likes_by_uid': post.likesByUid,
        'poster_uid': post.posterId,
        'date_posted': post.datePosted
      }
    ).onError((error, stackTrace) => "Error adding post to Firestore: $error");
  }
}