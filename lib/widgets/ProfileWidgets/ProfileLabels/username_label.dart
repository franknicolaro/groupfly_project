import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../../models/group_fly_user.dart';
import '../../../services/authorization_service.dart';
import '../../../services/repository_service.dart';

class UsernameLabel extends StatefulWidget{
  GroupFlyUser user;
  UsernameLabel({required this.user});
  @override
  State<UsernameLabel> createState() => _UsernameLabelState();
}

class _UsernameLabelState extends State<UsernameLabel>{
  Authorization _auth = Authorization();
  var user;

  @override
  void initState(){
    super.initState();
    initUser();
  }
  void initUser() {
    user = GetIt.instance<RepositoryService>().getGroupFlyUserByUID(widget.user.uid!);
  }
  @override
  Widget build(BuildContext context){
    return FutureBuilder(
      future: user,
      builder: (context, snapshot){
        if(snapshot.connectionState == ConnectionState.done){
          if(snapshot.hasError){
            return Center(
              child: Text(
                '${snapshot.error} occurred',
              )
            );
          }
          else if(snapshot.hasData){
            GroupFlyUser tmp = snapshot.data as GroupFlyUser;
            return Text(
              tmp.username,
              style: TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.w800,
                fontFamily: 'Mulish',
              ),
            );
          }
        }
        return const Center(
          child: CircularProgressIndicator()
        );
      }
    );
  }
}