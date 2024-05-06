import 'package:flutter/material.dart';
import 'package:groupfly_project/models/GroupFlyNotification.dart';
import 'package:groupfly_project/models/group_fly_user.dart';
import 'package:groupfly_project/widgets/ProfileWidgets/general_profile_widget.dart';

import '../../models/FriendList.dart';
import '../SettingsWidgets/settings_widget.dart';

class UserProfileWidgetWeb extends StatefulWidget {
  GroupFlyUser user;
  FriendList friends;
  Function removeFriend;
  List<GroupFlyNotification> notifications;
  UserProfileWidgetWeb({required this.user, required this.friends, required this.removeFriend, required this.notifications});
  @override
  State<UserProfileWidgetWeb> createState() => _UserProfileWidgetWebState();
}

class _UserProfileWidgetWebState extends State<UserProfileWidgetWeb>{
  @override
  void initState(){
    super.initState();
  }

  void refresh(){
    setState(() {
      
    });
  }
  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 10, 70, 94),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 61, 111, 67),
        title: Text('User Profile'),
        actions:[
          TextButton.icon(
            onPressed:(){
              showModalBottomSheet(
                isScrollControlled: true,
                context: context,
                builder: ((builder) => settingsPopUp()),
              );
            },
            icon: const Icon(Icons.settings_sharp),
            label: const Text("Settings")
          ),
        ]
      ),
      body: GeneralProfileWidget(user: widget.user, isFromOtherPage: false, isCurrentUserFriend: false, friends: widget.friends, removeFriend: widget.removeFriend,)
    );
  }

  Widget settingsPopUp(){
    return SettingsWidget();
  }
}