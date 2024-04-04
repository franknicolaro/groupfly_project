import 'package:flutter/material.dart';
import 'package:groupfly_project/models/group_fly_user.dart';
import 'package:groupfly_project/widgets/ProfileWidgets/general_profile_widget.dart';

import '../SettingsWidgets/settings_widget.dart';

class UserProfileWidgetWeb extends StatefulWidget {
  GroupFlyUser user;
  UserProfileWidgetWeb({required this.user});
  @override
  State<UserProfileWidgetWeb> createState() => _UserProfileWidgetWebState();
}

class _UserProfileWidgetWebState extends State<UserProfileWidgetWeb>{
  @override
  void initState(){
    super.initState();
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
          TextButton.icon(
            onPressed:(){
              //Display notifications widget
            },
            icon: const Icon(Icons.add_alert_sharp),
            label: const Text("Notifications")
          )
        ]
      ),
      body: GeneralProfileWidget(user: widget.user, isFromGroupPage: false,)
    );
  }

  Widget settingsPopUp(){
    return SettingsWidget();
  }
}