import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:groupfly_project/models/FriendList.dart';
import 'package:groupfly_project/models/group_fly_user.dart';
import 'package:groupfly_project/widgets/ProfileWidgets/listed_profile_container.dart';

import '../../models/GroupFlyNotification.dart';
import '../../services/repository_service.dart';

class ProfileExplorerWidget extends StatefulWidget{
  FriendList friendList;
  List<GroupFlyNotification> notifications;
  Function removeFriend;
  ProfileExplorerWidget({super.key, required this.friendList, required this.notifications, required this.removeFriend});
  @override
  State<ProfileExplorerWidget> createState() => _ProfileExplorerWidgetState();
}

class _ProfileExplorerWidgetState extends State<ProfileExplorerWidget>{
  List<GroupFlyUser> profiles = [];
  var _profileExplorerController = TextEditingController();

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
        title: Text('Profile Explorer'),
      ),
      body: Center(
        child: Column(
          children: [
            TextField(
              controller: _profileExplorerController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Search for Profiles",
                suffixIcon: IconButton(
                  icon: Icon(Icons.search_rounded),
                  onPressed: (){
                    if(_profileExplorerController.text.isNotEmpty){
                      GetIt.instance<RepositoryService>().searchProfileByName(_profileExplorerController.text).then((value) {
                        setState(() {
                          profiles = value;
                          _profileExplorerController.clear();
                        });
                      });
                    }
                  },
                )
              )
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children:
                    profiles.map((profile) =>
                      ListedProfileContainer(profile: profile, isFromOtherPage: false, removeFriend: widget.removeFriend,)
                    ).toList(),
                )
              ),
            )
          ]
        )
      )
    );
  }
}