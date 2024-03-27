import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:groupfly_project/models/group_fly_user.dart';
import 'package:groupfly_project/services/authorization_service.dart';

import '../../models/PostComment.dart';
import '../../services/repository_service.dart';

class LikesAndCommentsWidget extends StatefulWidget{
  List<PostComment> comments;
  List<String> likes;
  String postId;
  GroupFlyUser currentUser;
  LikesAndCommentsWidget({required this.comments, required this.likes, required this.postId, required this.currentUser});
  @override
  State<LikesAndCommentsWidget> createState() => _LikesAndCommentsWidgetState();
}

class _LikesAndCommentsWidgetState extends State<LikesAndCommentsWidget>{
  Authorization _auth = Authorization();
  var _commentController = TextEditingController();
  List<PostComment> comments = []; 
  List<String> likes = [];
  String? username;
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
            Container(
              child: InkWell(
                onTap: (){
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
                child: Icon(
                  Icons.thumb_up_alt_outlined,
                  color: likes.contains(_auth.currentUser!.uid) ? Colors.blue.shade50 : Colors.black45,
                  size: 30
                )
              )
            ),
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

  Widget commentsPopUp(){
    return Container(
      color: Color.fromARGB(255, 17, 127, 171),
      height: MediaQuery.of(context).size.height * 0.35,
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
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
          TextField(
            controller: _commentController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: "Enter a comment",
              suffixIcon: IconButton(
                icon: Icon(Icons.send_rounded),
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