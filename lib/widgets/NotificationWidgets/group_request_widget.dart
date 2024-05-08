import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../models/group_fly_user.dart';
import '../../models/Group.dart';
import '../../models/GroupFlyNotification.dart';
import '../../services/repository_service.dart';

//Class for a group join request notification
class GroupRequestWidget extends StatefulWidget{
  GroupFlyUser user;                  //The user that sent the request.
  Group group;                        //The group that the notification is in reference to.
  GroupFlyNotification notification;  //The notification that is displayed
  Function removeNotification;        //The removeNotification function passed from AppController.
  GroupRequestWidget({required this.group, required this.user, required this.removeNotification, required this.notification});

  @override
  State<GroupRequestWidget> createState() => _GroupRequestWidgetState();
}

class _GroupRequestWidgetState extends State<GroupRequestWidget>{
  //Builds the GroupRequestWidget
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromARGB(255, 10, 70, 94),
      child: Center(
        child: Column(
          children: [
            //BackButton to remove GroupRequestWidget from display
            Container(
              alignment: Alignment.topLeft,
              child: BackButton(
                onPressed: (){
                  Navigator.of(context).pop();
                },
              )
            ),
            const SizedBox(height: 15), 
            //Group Join Request title label.
            const Text("Group Join Request",
              style: TextStyle(
                color: Colors.black,
                fontSize: 48,
                fontWeight: FontWeight.w800,
                fontFamily: 'Mulish'
              )
            ),
            //Name of the user that wants to join the current user's group.
            Text("${widget.user.username} wants to join your group.",
              style: TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w500,
                fontFamily: 'Mulish'
              )
            ),
            //Title of the group.
            Text("Title: ${widget.group.title}",
              style: TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w500,
                fontFamily: 'Mulish'
              )
            ),
            //Date of the activity of the group.
            Text("Date of Event: ${widget.group.meeting_time}",
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
                //Accept button, which adds the user to the current user's group, 
                //then removes the notification and removes the GroupRequestWidget from display.
                ElevatedButton(
                  onPressed: (){
                    GetIt.instance<RepositoryService>().addMember(widget.notification.requesterUid, widget.group.group_id).then((_){
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
                //Deny button, which denies the request to join the current user's group,
                //then removes the notification and removes the GroupRequestWidget from display.
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