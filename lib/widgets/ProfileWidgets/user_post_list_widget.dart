import 'package:flutter/material.dart';
import 'package:groupfly_project/widgets/PostWidgets/post_container.dart';

import '../../models/Post.dart';
import '../../models/group_fly_user.dart';

class UserPostList extends StatefulWidget{
  List<Post> posts;
  GroupFlyUser user;
  UserPostList({required this.posts, required this.user});
  @override
  State<UserPostList> createState() => _UserPostListState();
}

class _UserPostListState extends State<UserPostList>{
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: SingleChildScrollView(
        child: Column(
          children: widget.posts.map((post) => 
            Column(
              children: [
                SizedBox(height: 15,),
                PostContainer(post: post, user: widget.user)
              ],
            ),
          ).toList(),
        ),
      )
    );
  }
        
  
}