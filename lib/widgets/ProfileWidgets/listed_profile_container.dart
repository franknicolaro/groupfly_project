import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:groupfly_project/services/authorization_service.dart';
import 'package:groupfly_project/services/repository_service.dart';
import 'package:groupfly_project/widgets/ProfileWidgets/general_profile_widget.dart';

import '../../models/FriendList.dart';
import '../../models/group_fly_user.dart';

//A class that displays a profile in a concise container.
class ListedProfileContainer extends StatefulWidget{
  GroupFlyUser profile;     //The profile that the container pertains to.
  bool isFromOtherPage;     //Boolean passed down from ProfileExplorer, GroupWidget, or UserFriendList.
  Function removeFriend;    //removeFriend function passed from AppController
  ListedProfileContainer({required this.profile, required this.isFromOtherPage, required this.removeFriend});
  @override
  State<ListedProfileContainer> createState() => _ListedProfileContainerState();
}
class _ListedProfileContainerState extends State<ListedProfileContainer>{
  //Authorization service for checking if the profile is friends with the current user.
  final Authorization _auth = Authorization();

  //FriendList for passing into GeneralProfileWidget.
  FriendList? friends;

  //Builds the ListedProfileContainer
  @override
  Widget build(BuildContext context){
    //Button which displays the user profile when clicked.
    return OutlinedButton(
      onPressed: (){
        GetIt.instance<RepositoryService>().getFriendsByUID(widget.profile.uid!).then((value) {
          friends = value;
          showModalBottomSheet(
            isScrollControlled: true,
            context: context, 
            builder: ((builder) => displayUserProfile())
          );
        });
      },
      child: Container(
        height: MediaQuery.of(context).size.height * 0.12,
        width: MediaQuery.of(context).size.width * 0.25,
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 17, 127, 171),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Row(
          children: [
            //Displays profile picture within the profile container
            Container(
              alignment: Alignment.centerLeft,
              child: CircleAvatar(
                radius: 24,
                backgroundColor: Colors.black45,
                child: CircleAvatar(
                  radius: 22,
                  backgroundImage: NetworkImage((widget.profile.photoURL == null ||widget.profile.photoURL! == "") ? "https://images.vexels.com/media/users/3/180861/isolated/preview/f68f0a8f6f1901015166ae2f9d8a39f8-cute-ladybug-flying-outline.png" : widget.profile.photoURL!),
                )
              )
            ),
            //Profile username label
            Container(
              child: Text(
                widget.profile.username,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Mulish'
                )
              )
            )
          ],
        )
      )
    );
  }
  Widget displayUserProfile(){
    return Container(
      color: Color.fromARGB(255, 17, 127, 171),
      child: GeneralProfileWidget(user: widget.profile, isFromOtherPage: widget.isFromOtherPage, isCurrentUserFriend: friends!.friend_uids.contains(_auth.currentUser!.uid), friends: friends!, removeFriend: widget.removeFriend)
    );
  }
}