import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:groupfly_project/services/repository_service.dart';

import '../../../models/Friend.dart';
import '../../../models/group_fly_user.dart';
import '../../../services/authorization_service.dart';

class FriendCountLabel extends StatefulWidget{
  GroupFlyUser user;
  FriendCountLabel({required this.user});
  @override
  State<FriendCountLabel> createState() => _FriendCountLabelState();
}

class _FriendCountLabelState extends State<FriendCountLabel>{
  Authorization _auth = Authorization();
  var friends;

  @override
  void initState(){
    super.initState();
    initFriends();
  }

  void initFriends(){
    friends = GetIt.instance<RepositoryService>().getFriendsByUID(widget.user.uid!);
  }

  @override
  Widget build(BuildContext context){
    return FutureBuilder(
      future: friends,
      builder:(context, snapshot){
        if(snapshot.connectionState == ConnectionState.done){
          if(snapshot.hasError){
            return Center(
              child: Text(
                '${snapshot.error} occurred',
              )
            );
          }
          else if(snapshot.hasData){
            Friend friendList = snapshot.data as Friend;
            return Text(
              'Number of Friends: ${friendList.friend_uids.length}',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w600,
                fontFamily: 'Mulish',
              )
            );
          }
        }
        return const Center(
          child: CircularProgressIndicator()
        );
      }
    );
  }
}