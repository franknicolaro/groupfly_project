import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:groupfly_project/models/FriendList.dart';
import 'package:groupfly_project/models/group_fly_user.dart';
import 'package:groupfly_project/widgets/ProfileWidgets/listed_profile_container.dart';

import '../../models/GroupFlyNotification.dart';
import '../../services/repository_service.dart';

//A search bar widget for profiles.
class ProfileExplorerWidget extends StatefulWidget{
  FriendList friendList;                    //The list of friendUIDs
  List<GroupFlyNotification> notifications; //List of notifications
  Function removeFriend;                    //removeFriend function from AppController.
  ProfileExplorerWidget({super.key, required this.friendList, required this.notifications, required this.removeFriend});

  @override
  State<ProfileExplorerWidget> createState() => _ProfileExplorerWidgetState();
}

class _ProfileExplorerWidgetState extends State<ProfileExplorerWidget>{
  //List of profiles as a result.
  List<GroupFlyUser> profiles = [];

  //Controller for the profile search bar.
  var _profileExplorerController = TextEditingController();

  //Refresh method to update the UI.
  void refresh(){
    setState(() {
      
    });
  }

  //Builds the Scaffold for the Profile Explorer.
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
            //TextField to search for profiles.
            TextField(
              controller: _profileExplorerController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Search for Profiles",
                suffixIcon: IconButton(
                  icon: Icon(Icons.search_rounded),
                  onPressed: (){
                    //Checks if the controller field isn't empty, then searched for profiles
                    //By the name entered. Then clears the controller.
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
            //List of Profile containers, returned from searching.
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