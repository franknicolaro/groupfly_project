import 'package:flutter/material.dart';

import '../../../models/FriendList.dart';

//A label for the number of friends of the user.
class FriendCountLabel extends StatefulWidget{
  FriendList friends;       //The FriendList of the user, which holds a list of friend uids.
  FriendCountLabel({required this.friends});
  @override
  State<FriendCountLabel> createState() => _FriendCountLabelState();
}

class _FriendCountLabelState extends State<FriendCountLabel>{
  //Builds the label by passing the FriendList through and using the length of the list.
  @override
  Widget build(BuildContext context){
    return Text(
      'Number of Friends: ${widget.friends.friend_uids.length}',
      style: TextStyle(
        color: Colors.black,
        fontSize: 18,
        fontWeight: FontWeight.w600,
        fontFamily: 'Mulish',
      )
    );
  }
}