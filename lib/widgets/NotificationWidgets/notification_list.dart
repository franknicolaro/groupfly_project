import 'package:flutter/material.dart';
import 'package:groupfly_project/models/GroupFlyNotification.dart';
import 'package:groupfly_project/widgets/NotificationWidgets/listed_notification_container.dart';

class NotificationList extends StatefulWidget{
  List<GroupFlyNotification> notifications;
  Function removeNotification;
  NotificationList({super.key, required this.notifications, required this.removeNotification});

  @override
  State<NotificationList> createState() => _NotificationListState();
}

class _NotificationListState extends State<NotificationList>{
  List<GroupFlyNotification> notifList = [];
  @override
  void initState() {
    super.initState();
    notifList.addAll(widget.notifications);
  }
  void removeNotification(GroupFlyNotification notification){
    widget.removeNotification(notification);
    setState(() {
      
    });
  }
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
              ),
            ),
            SizedBox(width: 15), //TODO: just get rid of this. it doesn't do anything bc of width.
            Text("Notifications",
              style:TextStyle(
                color: Colors.black,
                fontSize: 48,
                fontWeight: FontWeight.w800,
                fontFamily: 'Mulish',
              )
            ),
            SizedBox(width: 15), //TODO: just get rid of this. it doesn't do anything bc of width.
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: 
                    widget.notifications.map((notification) =>
                      Center(
                        child: ListedNotificationContainer(notification: notification, removeNotification: removeNotification,)
                      )
                    ).toList(),
                )
              )
            )
          ]
        )
      ),
    );
  }
}