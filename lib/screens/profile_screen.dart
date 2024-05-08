import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:groupfly_project/models/GroupFlyNotification.dart';
import 'package:groupfly_project/models/group_fly_user.dart';
import 'package:groupfly_project/widgets/ProfileWidgets/user_profile_web.dart';

import '../models/FriendList.dart';

//A screen that displays the profile screen.
class ProfileScreen extends StatefulWidget{
  GroupFlyUser user;                        //The user that the profile widget refers to.
  FriendList friends;                       //The list of friends of the user.
  Function removeFriend;                    //A function which removes a specific friend from the user's friendList.
  List<GroupFlyNotification> notifications; //List of notifications for the user's profile page.
  ProfileScreen({required this.user, required this.friends, required this.removeFriend, required this.notifications});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>{
  //Displays the ProfileWidget based on the platform.
  @override
  Widget build(BuildContext context) {
    if(kIsWeb){
      return UserProfileWidgetWeb(user: widget.user, friends: widget.friends, removeFriend: widget.removeFriend, notifications: widget.notifications,);
    }
    else{ 
      return Text("TODO: Implement Mobile Version");
    }
  }
}
