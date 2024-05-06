import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:groupfly_project/models/group_fly_user.dart';
import 'package:groupfly_project/services/authorization_service.dart';

import '../../models/FriendList.dart';
import '../../services/repository_service.dart';
import '../ProfileWidgets/listed_profile_container.dart';

class UserFriendListWidget extends StatefulWidget{
  List<GroupFlyUser> friends;
  FriendList friendList;
  GroupFlyUser user;
  Function removeFriend;
  UserFriendListWidget({super.key, required this.friends, required this.removeFriend, required this.friendList, required this.user});

  @override
  State<UserFriendListWidget> createState() => _UserFriendListWidgetState();
}

class _UserFriendListWidgetState extends State<UserFriendListWidget>{
  Authorization _auth = Authorization();
  List<GroupFlyUser> friends = [];
  @override
  void initState(){
    super.initState();
    friends.addAll(widget.friends);
  }
  void refresh(){
    setState(() {
      
    });
  }
  void removeFriend(String uid){
    setState(() {
      friends.removeWhere((user) => user.uid! == uid);
      widget.removeFriend(uid);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromARGB(255, 10, 70, 94),
      child: Center(
        child: Column(
          children: [
            Container(
              alignment: Alignment.topLeft,
              child: BackButton(
                onPressed: (){
                  Navigator.of(context).pop();
                },
              ),
            ),
            SizedBox(width: 15),
            Text("Friends",
              style:TextStyle(
                color: Colors.black,
                fontSize: 48,
                fontWeight: FontWeight.w800,
                fontFamily: 'Mulish',
              )
            ),
            SizedBox(width: 15),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: 
                    friends.map((friend) =>
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ListedProfileContainer(profile: friend, isFromOtherPage: true, removeFriend: removeFriend,),
                          SizedBox(width: 15),
                          Visibility(
                            visible: _auth.currentUser!.uid == widget.user.uid,
                            child: ElevatedButton(
                              onPressed: (){
                                GetIt.instance<RepositoryService>().removeFriend(_auth.currentUser!.uid, friend.uid!).then((_){
                                  GetIt.instance<RepositoryService>().removeFriend(friend.uid!, _auth.currentUser!.uid).then((_) {
                                    setState(){
                                      friends.remove(friend);
                                      widget.removeFriend(friend);
                                    };
                                  },);
                                });
                              },
                              child: const Text("Remove",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'Mulish'
                                )
                              ),
                            ),
                          ),
                        ],
                      )
                    ).toList(),
                )
              )
            )
          ]
        )
      ),
    );
  }
}