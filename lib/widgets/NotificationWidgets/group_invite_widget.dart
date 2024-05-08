import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:groupfly_project/models/GroupFlyNotification.dart';
import 'package:groupfly_project/services/repository_service.dart';

import '../../models/Group.dart';
import '../../models/group_fly_user.dart';

//Class that displays a group invite notification
class GroupInviteWidget extends StatefulWidget{
  GroupFlyUser user;                  //The user that is inviting the current user.
  Group group;                        //The group that the invite is in reference to.
  GroupFlyNotification notification;  //The notification of the group invite.
  Function removeNotification;        //The removeNotification function passed from AppController.
  GroupInviteWidget({required this.group, required this.user, required this.removeNotification, required this.notification});

  @override
  State<GroupInviteWidget> createState() => _GroupInviteWidgetState();
}

class _GroupInviteWidgetState extends State<GroupInviteWidget>{
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromARGB(255, 10, 70, 94),
      child: Center(
        child: Column(
          children: [
            //Back button to remove GroupInviteWidget from display
            Container(
              alignment: Alignment.topLeft,
              child: BackButton(
                onPressed: (){
                  Navigator.of(context).pop();
                },
              )
            ),
            SizedBox(height: 15), 
            //Group Invite title text.
            const Text("Group Invite",
              style: TextStyle(
                color: Colors.black,
                fontSize: 48,
                fontWeight: FontWeight.w800,
                fontFamily: 'Mulish'
              )
            ),
            //Message indicating that a user wants to invite the current user to their group.
            Text("${widget.user.username} wants to invite you to their group.",
              style: TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w500,
                fontFamily: 'Mulish'
              )
            ),
            //Title of the group
            Text("Title: ${widget.group.title}",
              style: TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w500,
                fontFamily: 'Mulish'
              )
            ),
            //Date of the event.
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
                //Accept button, which adds the current user to the group, 
                //then removes the notification and removes the GroupInviteWidget from display.
                ElevatedButton(
                  onPressed: (){
                    GetIt.instance<RepositoryService>().addMember(widget.notification.requesteeUid, widget.group.group_id).then((_){
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
                //Deny button, which denies the invite,  
                //then removes the notification and removes the GroupInviteWidget from display.
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