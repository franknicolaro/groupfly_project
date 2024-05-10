import 'package:flutter/material.dart';
import 'package:groupfly_project/models/Post.dart';

//A simple label that displays the number of posts of the user.
class PostCountLabel extends StatefulWidget{
  List<Post> posts; //List of posts of the user.
  PostCountLabel({required this.posts});
  @override
  State<PostCountLabel> createState() => _PostCountLabelState();
}

class _PostCountLabelState extends State<PostCountLabel>{
  //Obtains the list of posts and uses the length in the label.
  @override
  Widget build(BuildContext context){
    return Text(
      'Posts: ${widget.posts.length}',
      style: TextStyle(
        color: Colors.black,
        fontSize: 18,
        fontWeight: FontWeight.w600,
        fontFamily: 'Mulish',
      )
    );    
  }
}