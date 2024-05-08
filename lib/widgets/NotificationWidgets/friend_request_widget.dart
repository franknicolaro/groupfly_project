import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:groupfly_project/models/GroupFlyNotification.dart';
import 'package:groupfly_project/services/repository_service.dart';

import '../../models/group_fly_user.dart';

//Class for a friend request notification.
class FriendRequestWidget extends StatefulWidget{
  GroupFlyNotification notification;  //The notification
  GroupFlyUser user;                  //The user that the notification refers to.
  Function removeNotification;        //The removeNotification function passed from AppController.
  FriendRequestWidget({required this.notification, required this.user, required this.removeNotification});

  @override
  State<FriendRequestWidget> createState() => _FriendRequestWidgetState();
}

class _FriendRequestWidgetState extends State<FriendRequestWidget>{
  //Builds the FriendRequestWidget.
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromARGB(255, 10, 70, 94),
      child: Center(
        child: Column(
          children: [
            Container(
              //BackButton to remove FriendRequestWidget from display
              alignment: Alignment.topLeft,
              child: BackButton(
                onPressed: (){
                  Navigator.of(context).pop();
                },
              )
            ),
            const SizedBox(height: 15), 
            //Friend Request title label.
            const Text("Friend Request",
              style: TextStyle(
                color: Colors.black,
                fontSize: 48,
                fontWeight: FontWeight.w800,
                fontFamily: 'Mulish'
              )
            ),
            //The name of the user that wants to be the current user's friend.
            Text("${widget.user.username} wants to be your friend.",
              style: TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w500,
                fontFamily: 'Mulish'
              )
            ),
            SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //Accept button, which adds the user as a friend, 
                //then removes the notification and removes the FriendRequestWidget from display.
                ElevatedButton(
                  onPressed: (){
                    GetIt.instance<RepositoryService>().addFriend(widget.notification.requesterUid, widget.notification.requesteeUid).then((_){
                      GetIt.instance<RepositoryService>().removeNotification(widget.notification).then((_){
                        widget.removeNotification(widget.notification);
                        Navigator.of(context).pop();
                      });
                    });
                  }, 
                  child: Text("Accept",
                    style: TextStyle(
                      color: Colors.black
                    )
                  )
                ),
                //Deny button, which denies the request, 
                //then removes the notification and removes the FriendRequestWidget from display.
                ElevatedButton(
                  onPressed: (){
                    GetIt.instance<RepositoryService>().removeNotification(widget.notification).then((_){
                      widget.removeNotification(widget.notification);
                       Navigator.of(context).pop();
                    });
                  }, 
                  child: Text("Deny",
                    style: TextStyle(
                      color: Colors.black
                    )
                  )
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}