import 'package:flutter/material.dart';
import 'package:groupfly_project/models/group_fly_user.dart';
import 'package:groupfly_project/widgets/NotificationWidgets/notification_list.dart';

import '../../models/GroupFlyNotification.dart';
import '../../models/Post.dart';
import '../ProfileWidgets/user_post_list_widget.dart';

//Class that displays the home feed, which includes the notifications button
//and a list of the most recent posts of friends.
class HomeFeedWidget extends StatefulWidget{
  GroupFlyUser user;                        //The current GroupFlyUser.
  List<Post> mostRecentPosts;               //The most recent posts from the AppController.
  List<GroupFlyNotification> notifications; //Notifications of the user.
  Function removeNotification;              //removeNotification function passed through from AppController.
  HomeFeedWidget({super.key, required this.user, required this.mostRecentPosts, required this.notifications, required this.removeNotification});

  @override
  State<HomeFeedWidget> createState() => _HomeFeedWidgetState();
}

class _HomeFeedWidgetState extends State<HomeFeedWidget>{
  //A local list of most recent posts.
  List<Post> posts = [];

  @override
  void initState(){
    super.initState();
    setState(() => posts = widget.mostRecentPosts);
  }

  //Removes the specified notification the notification list in the AppController.
  void removeNotification(GroupFlyNotification notification){
    widget.removeNotification(notification);
  }

  //Builds the HomeFeedWidget.
  @override
  Widget build(BuildContext context) {
    //Updates the UI before returning the Scaffold.
    setState(() {
      
    });
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 10, 70, 94),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 61, 111, 67),
        title: Text('Home Feed'),
        actions:[
          //Button that displays the list of notifications.
          TextButton.icon(
            onPressed:(){
              showModalBottomSheet(
                isScrollControlled: true,
                context: context, 
                builder: ((builder) => displayNotificationList())
              );
            },
            icon: const Icon(Icons.add_alert_sharp),
            label: const Text("Notifications")
          )
        ]
      ),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          children: [
            //Label explaining the list of posts.
            const Text("Most recent posts from friends:",
              style: TextStyle(
                color: Colors.black,
                fontSize: 48,
                fontWeight: FontWeight.w700,
                fontFamily: 'Mulish'
              )
            ),
            //Container holding the UserPostList (see user_post_list_widget.dart)
            Container(
              color: Color.fromARGB(255, 17, 127, 171),
              height: MediaQuery.of(context).size.height * 0.65,
              width: MediaQuery.of(context).size.width * 0.60,
              child: UserPostList(posts: posts, user: widget.user,)
            ),
          ],
        ),
      ),
    );
  }
  
  //Displays a NotificationList(see notification_list.dart)
  Widget displayNotificationList(){
    return NotificationList(notifications: widget.notifications, removeNotification: removeNotification);
  }
}