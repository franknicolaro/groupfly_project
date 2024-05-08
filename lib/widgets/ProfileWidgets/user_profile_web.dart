import 'package:flutter/material.dart';
import 'package:groupfly_project/models/GroupFlyNotification.dart';
import 'package:groupfly_project/models/group_fly_user.dart';
import 'package:groupfly_project/widgets/ProfileWidgets/general_profile_widget.dart';

import '../../models/FriendList.dart';
import '../SettingsWidgets/settings_widget.dart';

//A class which displays the current user's profile page.
class UserProfileWidgetWeb extends StatefulWidget {
  GroupFlyUser user;                        //The current user.
  FriendList friends;                       //The current user's FriendList
  Function removeFriend;                    //The removeFriend function from AppController.
  UserProfileWidgetWeb({required this.user, required this.friends, required this.removeFriend});
  @override
  State<UserProfileWidgetWeb> createState() => _UserProfileWidgetWebState();
}

class _UserProfileWidgetWebState extends State<UserProfileWidgetWeb>{
  //Refreshes the UI by calling setState().
  void refresh(){
    setState(() {
      
    });
  }

  //Builds UserProfileWidgetWeb
  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 10, 70, 94),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 61, 111, 67),
        title: Text('User Profile'),
        actions:[
          //Icon that displays the Settings when clicked on.
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
      //Holds the current user's GeneralProfileWidget as the body of the Scaffold.
      body: GeneralProfileWidget(user: widget.user, isFromOtherPage: false, isCurrentUserFriend: false, friends: widget.friends, removeFriend: widget.removeFriend,)
    );
  }

  //Returns the SettingsWidget.
  Widget settingsPopUp(){
    return SettingsWidget();
  }
}