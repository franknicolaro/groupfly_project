import 'package:flutter/material.dart';

import '../../../models/group_fly_user.dart';

//A simple label that displays the username of the profile.
class UsernameLabel extends StatefulWidget{
  GroupFlyUser user;  //The user to provide the username for.
  UsernameLabel({required this.user});
  @override
  State<UsernameLabel> createState() => _UsernameLabelState();
}

class _UsernameLabelState extends State<UsernameLabel>{
  //Obtains the user passed through and puts the username into the label.
  @override
  Widget build(BuildContext context){
    return Text(
      widget.user.username,
      style: TextStyle(
        color: Colors.black,
        fontSize: 24,
        fontWeight: FontWeight.w800,
        fontFamily: 'Mulish',
      ),
    );
  }
}