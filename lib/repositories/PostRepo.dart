
import 'package:cloud_firestore/cloud_firestore.dart';

import '../DAOs/PostDAO.dart';
import '../models/Post.dart';
import '../models/PostComment.dart';
import '../models/group_fly_user.dart';

class PostRepo implements PostDao{
  final FirebaseFirestore firebaseDB = FirebaseFirestore.instance;

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
          );
        });
      }
    },);
    return posts;
  }
  
  @override
  Future<void> addLike(String uid, String postId) async {
    firebaseDB.collection('post').doc(postId).update({
      'likes_by_uid': FieldValue.arrayUnion([uid])
    });
  }
  
  @override
  Future<void> removeLike(String uid, String postId) async {
    firebaseDB.collection('post').doc(postId).update({
      'likes_by_uid': FieldValue.arrayRemove([uid])
    });
  }

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
  
  @override
  Future<void> addPost(Post post) async {
    firebaseDB.collection('post').doc().set(
      {
        'caption': post.description,
        'comments': post.comments,
        'group_ref': post.groupRef,
        'image_name': post.imageUrl,
        'likes_by_uid': post.likesByUid,
        'poster_uid': post.posterId
      }
    ).onError((error, stackTrace) => "Error adding post to Firestore: $error");
  }
}