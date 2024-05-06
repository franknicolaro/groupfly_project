import 'package:flutter/material.dart';

import '../../../models/FriendList.dart';
import '../../../services/authorization_service.dart';

class FriendCountLabel extends StatefulWidget{
  //GroupFlyUser user;
  FriendList friends;
  FriendCountLabel({required this.friends});
  @override
  State<FriendCountLabel> createState() => _FriendCountLabelState();
}

class _FriendCountLabelState extends State<FriendCountLabel>{
  Authorization _auth = Authorization();
  var friends;

  @override
  void initState(){
    super.initState();
  }

  void initFriends(){
    //friends = GetIt.instance<RepositoryService>().getFriendsByUID(widget.user.uid!);
  }

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