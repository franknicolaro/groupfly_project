import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:groupfly_project/models/group_fly_user.dart';
import 'package:groupfly_project/services/authorization_service.dart';

import '../../models/PostComment.dart';
import '../../services/repository_service.dart';

//A class that displays the likes and 
//comments of the post that they pertain to.
class LikesAndCommentsWidget extends StatefulWidget{
  List<PostComment> comments;     //List of comments pertaining to the post.
  List<String> likes;             //List of likes pertaining to the post.
  String postId;                  //The id of the document pertaining to the post.
  GroupFlyUser currentUser;       //The current user.
  LikesAndCommentsWidget({required this.comments, required this.likes, required this.postId, required this.currentUser});
  @override
  State<LikesAndCommentsWidget> createState() => _LikesAndCommentsWidgetState();
}

class _LikesAndCommentsWidgetState extends State<LikesAndCommentsWidget>{
  //Authorization service to update the likes.
  final Authorization _auth = Authorization();

  //Controller for entering a comment.
  var _commentController = TextEditingController();

  //Local lists for comments and likes.
  List<PostComment> comments = []; 
  List<String> likes = [];
  
  //Initializes the state and lists of comments and likes.
  @override
  void initState(){
    super.initState();
    comments = widget.comments;
    likes = widget.likes;
  }

  @override
  Widget build(BuildContext context){
    return Row(
      children: <Widget>[
        Row(
          children: [
            //Comments Icon that displays the comments upon clicking 
            Container(
              child: InkWell(
                onTap: (){
                  showModalBottomSheet(
                    context: context, 
                    builder: ((builder) => commentsPopUp())
                  );
                },
                child: Icon(
                  Icons.comment_outlined,
                  color: Colors.black45,
                  size: 30
                )
              )
            ),
            //Label for the number of comments.
            Container(
              child: Text(
                '${comments.length}',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'Mulish'
                ),            
              ),
            )
          ],
        ),
        SizedBox(width: 30),
        Row(
          children: [
            //Icon for the number of likes.
            Container(
              child: InkWell(
                onTap: (){
                  //Removes the like, both from the document in Firestore and the local list, 
                  //if the user is included in the number of likes. Adds the like otherwise.
                  if(likes.contains(_auth.currentUser!.uid)){
                    GetIt.instance<RepositoryService>().removeLike(_auth.currentUser!.uid, widget.postId);
                    setState(() {
                      likes.remove(_auth.currentUser!.uid);
                    });
                  }
                  else{
                    GetIt.instance<RepositoryService>().addLike(_auth.currentUser!.uid, widget.postId);
                    setState(() {
                      likes.add(_auth.currentUser!.uid);
                    });
                  }
                },
                //The icon changes color depending on if the user has liked the post.
                child: Icon(
                  Icons.thumb_up_alt_outlined,
                  color: likes.contains(_auth.currentUser!.uid) ? Colors.blue.shade50 : Colors.black45,
                  size: 30
                )
              )
            ),
            //Label for the number of likes.
            Container(
              child: Text(
                '${likes.length}',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'Mulish'
                ),            
              ),
            )
          ],
        ),
      ],
    );
  }

  //A function that displays the comments.
  Widget commentsPopUp(){
    return Container(
      color: Color.fromARGB(255, 17, 127, 171),
      height: MediaQuery.of(context).size.height * 0.35,
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          //The list of comments, displayed with the username of the user that made the comment.
          SingleChildScrollView(
            child: Column(
              children: comments.map((comment) => 
                Text('${comment.username}: ${comment.text}',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Mulish'
                  )
                )
              ).toList(),
            )
          ),
          //TextField for entering a comment.
          TextField(
            controller: _commentController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: "Enter a comment",
              suffixIcon: IconButton(
                icon: Icon(Icons.send_rounded),
                //Upon clicking the send button, adds the comment to the 
                //local list and to the comment list under the post in Firestore.
                onPressed: () {
                  GetIt.instance<RepositoryService>().addComment(widget.currentUser, _commentController.text, widget.postId);
                  setState(() {
                    comments.add(PostComment(text: _commentController.text, user_uid: widget.currentUser.uid!, username: widget.currentUser.username));
                  });
                  Navigator.pop(context);
                },
              )
            ),
          )
        ],
      )
    );
  }
}