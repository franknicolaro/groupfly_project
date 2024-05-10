import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:groupfly_project/models/GroupFlyNotification.dart';

import '../../models/Group.dart';
import '../../models/group_fly_user.dart';
import '../../services/repository_service.dart';
import 'friend_request_widget.dart';
import 'group_invite_widget.dart';
import 'group_request_widget.dart';

//A class to display a listed notification.
class ListedNotificationContainer extends StatefulWidget{
  //The notification, along with the removeNotification function passed from the AppController.
  GroupFlyNotification notification;
  Function removeNotification;
  ListedNotificationContainer({required this.notification, required this.removeNotification});

  @override
  State<ListedNotificationContainer> createState() => _ListedNotificationContainerState();
}

class _ListedNotificationContainerState extends State<ListedNotificationContainer>{
  //The user that is requesting the current user in the notification
  GroupFlyUser? requester;

  //The group in reference to the notification (if necessary).
  Group? referencedGroup;
  @override
  void initState(){
    super.initState();
    initVariables();
  }
  //Initialize the requester and the group that the 
  //notification is in reference to (if necessary)
  void initVariables(){
    if(widget.notification.type =="friend_request"){
      GetIt.instance<RepositoryService>().getGroupFlyUserByUID(widget.notification.requesterUid).then((user){
        setState(() {
          requester = user;
        });
      });
    }
    else{
      GetIt.instance<RepositoryService>().getGroupByPostReference(widget.notification.groupRef).then((group){
        GetIt.instance<RepositoryService>().getGroupFlyUserByUID(widget.notification.requesterUid).then((user){
          setState(() {
            referencedGroup = group;
            requester = user;
          });
        });
      });
    }
  }
  //Builds the ListedNotificationContainer.
  @override
  Widget build(BuildContext context) {
    //Button which displays the notification, based on the notification's type.
    return OutlinedButton(
      onPressed: (){
        widget.notification.type == "friend_request" ? 
        showModalBottomSheet(
          isScrollControlled: true,
          context: context, 
          builder: ((builder)  => displayFriendRequest())
        ) : 
        widget.notification.type == "group_request" ? showModalBottomSheet(
          isScrollControlled: true,
          context: context, 
          builder: ((builder) => displayGroupRequest())
        ) :
        showModalBottomSheet(
          isScrollControlled: true,
          context: context, 
          builder: ((builder) => displayGroupInvite())
        );
      }, 
      //Displays a label, with the title depending on the notification.
      child: Container(
        height: MediaQuery.of(context).size.height * 0.12,
        width: MediaQuery.of(context).size.width * 0.25,
        decoration: BoxDecoration(
          color: Color.fromARGB(255,17,127,171),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Row(
          children: [
            Container(
              child: Text(
                widget.notification.type == "friend_request" ? "Friend Request: " : 
                widget.notification.type == "group_request" ? "Group Join Request: " :
                "Group Invite: ",
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Mulish',
                  fontWeight: FontWeight.w700,
                  fontSize: 14
                )
              )
            )
          ],
        ),
      )
    );
  }
  //Displays the FriendRequestWidget, initializing the variables if necessary.
  Widget displayFriendRequest(){
    if(requester == null){
      setState(() {
        initVariables();
      });
    }
    return FriendRequestWidget(notification: widget.notification, user: requester!, removeNotification: widget.removeNotification);
  }
  //Displays the GroupRequestWidget, intializing the variables if necessary.
  Widget displayGroupRequest(){
    if(requester == null || referencedGroup == null){
      setState(() {
        initVariables();
      });
    }
    return GroupRequestWidget(user: requester!, group: referencedGroup!, notification: widget.notification, removeNotification: widget.removeNotification);
  }
  //Displays the GroupInviteWidget, intializing the variables if necessary.
  Widget displayGroupInvite(){
    if(requester == null || referencedGroup == null){
      setState(() {
        initVariables();
      });
    }
    return GroupInviteWidget(user: requester!, group: referencedGroup!, notification: widget.notification, removeNotification: widget.removeNotification);
  }
}