import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../models/group_fly_user.dart';
import '../../models/Group.dart';
import '../../models/GroupFlyNotification.dart';
import '../../services/repository_service.dart';

class GroupRequestWidget extends StatefulWidget{
  GroupFlyUser user;
  Group group;
  GroupFlyNotification notification;
  Function removeNotification;
  GroupRequestWidget({required this.group, required this.user, required this.removeNotification, required this.notification});

  @override
  State<GroupRequestWidget> createState() => _GroupRequestWidgetState();
}

class _GroupRequestWidgetState extends State<GroupRequestWidget>{
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromARGB(255, 10, 70, 94),
      child: Center(
        child: Column(
          children: [
            Container(
              alignment: Alignment.topLeft,
              child: BackButton(
                onPressed: (){
                  Navigator.of(context).pop();
                },
              )
            ),
            SizedBox(width: 15), //TODO: just get rid of this. it doesn't do anything bc of width.
            Text("Group Join Request",
              style: TextStyle(
                color: Colors.black,
                fontSize: 48,
                fontWeight: FontWeight.w800,
                fontFamily: 'Mulish'
              )
            ),
            Text("${widget.user.username} wants to join your group.",
              style: TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w500,
                fontFamily: 'Mulish'
              )
            ),
            Text("Title: ${widget.group.title}",
              style: TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w500,
                fontFamily: 'Mulish'
              )
            ),
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