import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:groupfly_project/models/GroupFlyNotification.dart';
import 'package:groupfly_project/services/repository_service.dart';

import '../../models/group_fly_user.dart';

class FriendRequestWidget extends StatefulWidget{
  GroupFlyNotification notification;
  GroupFlyUser user;
  Function removeNotification;
  FriendRequestWidget({required this.notification, required this.user, required this.removeNotification});

  @override
  State<FriendRequestWidget> createState() => _FriendRequestWidgetState();
}

class _FriendRequestWidgetState extends State<FriendRequestWidget>{
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
            Text("Friend Request",
              style: TextStyle(
                color: Colors.black,
                fontSize: 48,
                fontWeight: FontWeight.w800,
                fontFamily: 'Mulish'
              )
            ),
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