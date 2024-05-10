import 'package:flutter/material.dart';
import 'package:groupfly_project/models/GroupFlyNotification.dart';
import 'package:groupfly_project/widgets/NotificationWidgets/listed_notification_container.dart';

//Class for the list of notifications, displayed 
//after clicking the notifications button 
//on the user's home feed.
class NotificationList extends StatefulWidget{
  List<GroupFlyNotification> notifications; //List of notification
  Function removeNotification;              //The removeNotification function, passed from AppController.
  NotificationList({super.key, required this.notifications, required this.removeNotification});

  @override
  State<NotificationList> createState() => _NotificationListState();
}

class _NotificationListState extends State<NotificationList>{
  //Initializes the local list of notifications.
  @override
  void initState() {
    super.initState();
  }

  //Builds the NotificationList
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromARGB(255, 10, 70, 94),
      child: Center(
        child: Column(
          children: [
            //BackButton to remove NotificationList from display
            Container(
              alignment: Alignment.topLeft,
              child: BackButton(
                onPressed: (){
                  Navigator.of(context).pop();
                },
              ),
            ),
            SizedBox(height: 15), 
            //Title label for notifications.
            const Text("Notifications",
              style:TextStyle(
                color: Colors.black,
                fontSize: 48,
                fontWeight: FontWeight.w800,
                fontFamily: 'Mulish',
              )
            ),
            SizedBox(height: 15), 
            //Scroll view of ListedNotificationContainers based on the list of notifications.
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: 
                    widget.notifications.map((notification) =>
                      Center(
                        child: ListedNotificationContainer(notification: notification, removeNotification: widget.removeNotification,)
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