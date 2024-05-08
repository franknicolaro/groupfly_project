import 'package:flutter/material.dart';
import 'package:groupfly_project/widgets/PostWidgets/post_container.dart';

import '../../models/Post.dart';
import '../../models/group_fly_user.dart';

//A class that displays the list of posts in the user's profile page.
class UserPostList extends StatefulWidget{
  List<Post> posts;       //Posts of the user that the list pertains to.
  GroupFlyUser user;      //The user that the list pertains to.
  UserPostList({required this.posts, required this.user});
  @override
  State<UserPostList> createState() => _UserPostListState();
}

class _UserPostListState extends State<UserPostList>{
  //Builds the UserPostList
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      //ScrollView containing a column of listed posts.
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