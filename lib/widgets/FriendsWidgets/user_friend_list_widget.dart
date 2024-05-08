import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:groupfly_project/models/group_fly_user.dart';
import 'package:groupfly_project/services/authorization_service.dart';

import '../../models/FriendList.dart';
import '../../services/repository_service.dart';
import '../ProfileWidgets/listed_profile_container.dart';

//A Widget that displays the friend list from the user's profile.
class UserFriendListWidget extends StatefulWidget{
  List<GroupFlyUser> friends; //List of GroupFlyUsers that are friends of the current user.
  FriendList friendList;      //List of UIDs of friends of user.
  GroupFlyUser user;          //The user of the friend list.
  Function removeFriend;      //removeFriend function.
  UserFriendListWidget({super.key, required this.friends, required this.removeFriend, required this.friendList, required this.user});

  @override
  State<UserFriendListWidget> createState() => _UserFriendListWidgetState();
}

class _UserFriendListWidgetState extends State<UserFriendListWidget>{
  //Authorization service to check if the current user is the same user with this friend list.
  Authorization _auth = Authorization();

  //List of friends to refer to instead of calling widget.friends.
  List<GroupFlyUser> friends = [];
  @override
  void initState(){
    super.initState();
    friends.addAll(widget.friends);
  }

  //Refresh function to update the UI.
  void refresh(){
    setState(() {
      
    });
  }
  //Removes the friend locally, then removes the friend from the AppController.
  void removeFriend(String uid){
    setState(() {
      friends.removeWhere((user) => user.uid! == uid);
      widget.removeFriend(uid);
    });
  }
  //Builds the friend list widget.
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromARGB(255, 10, 70, 94),
      child: Center(
        child: Column(
          children: [
            //BackButton to ensure that the FriendList can
            //be properly removed to view whatever it was displayed over.
            Container(
              alignment: Alignment.topLeft,
              child: BackButton(
                onPressed: (){
                  Navigator.of(context).pop();
                },
              ),
            ),
            //Friends Label
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
            //ScrollView containing ListedProfileContainers of all friends of the user.
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
                          //A remove Friend button that is only visible if the friend list
                          //is the same friend list as the user. 
                          Visibility(
                            visible: _auth.currentUser!.uid == widget.user.uid,
                            child: ElevatedButton(
                              onPressed: (){
                                //Removes the friend from both the user's document and the friend's document.
                                //Then, calls removeFriend for that friend's UID.
                                GetIt.instance<RepositoryService>().removeFriend(_auth.currentUser!.uid, friend.uid!).then((_){
                                  GetIt.instance<RepositoryService>().removeFriend(friend.uid!, _auth.currentUser!.uid).then((_) {
                                    removeFriend(friend.uid!);
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