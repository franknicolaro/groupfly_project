import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:groupfly_project/models/GroupFlyNotification.dart';
import 'package:groupfly_project/models/group_fly_user.dart';
import 'package:groupfly_project/widgets/ProfileWidgets/user_profile_web.dart';

import '../models/FriendList.dart';

class ProfileScreen extends StatefulWidget{
  GroupFlyUser user;
  FriendList friends;
  Function removeFriend;
  List<GroupFlyNotification> notifications;
  ProfileScreen({required this.user, required this.friends, required this.removeFriend, required this.notifications});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>{
  @override
  Widget build(BuildContext context) {
    if(kIsWeb){
      return UserProfileWidgetWeb(user: widget.user, friends: widget.friends, removeFriend: widget.removeFriend, notifications: widget.notifications,);
    }
    else{ 
      return Text("TODO: Implement Mobile Version");
    }
    // TODO: implement widgets for mobile and web ^^^^. 
  }
}
