import 'package:flutter/material.dart';
import 'package:groupfly_project/models/Post.dart';

class PostCountLabel extends StatefulWidget{
  List<Post> posts;
  PostCountLabel({required this.posts});
  @override
  State<PostCountLabel> createState() => _PostCountLabelState();
}

class _PostCountLabelState extends State<PostCountLabel>{
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