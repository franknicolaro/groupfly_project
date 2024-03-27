import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:groupfly_project/models/group_fly_user.dart';
import 'package:groupfly_project/widgets/ProfileWidgets/user_profile_web.dart';

class ProfileScreen extends StatefulWidget{
  GroupFlyUser user;
  ProfileScreen({required this.user});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>{
  @override
  Widget build(BuildContext context) {
    if(kIsWeb){
      return UserProfileWidgetWeb(user: widget.user);
    }
    else{ 
      return Text("TODO: Implement Mobile Version");
    }
    // TODO: implement widgets for mobile and web ^^^^. 
  }
}
