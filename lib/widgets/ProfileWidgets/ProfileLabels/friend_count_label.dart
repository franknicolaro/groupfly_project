import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:groupfly_project/services/repository_service.dart';

import '../../../models/Friend.dart';
import '../../../services/authorization_service.dart';

class FriendCountLabel extends StatefulWidget{
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
    friends = GetIt.instance<RepositoryService>().getFriendsByUID(_auth.currentUser!.uid);
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
            List<Friend> friendList = snapshot.data as List<Friend>;
            return Text(
              'Number of Friends: ${friendList.length}',
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