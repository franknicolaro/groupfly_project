import 'package:flutter/material.dart';
import 'package:groupfly_project/models/group_fly_user.dart';
import 'package:groupfly_project/widgets/NotificationWidgets/notification_list.dart';

import '../../models/GroupFlyNotification.dart';
import '../../models/Post.dart';
import '../ProfileWidgets/user_post_list_widget.dart';

class HomeFeedWidget extends StatefulWidget{
  GroupFlyUser user;
  List<Post> mostRecentPosts;
  List<GroupFlyNotification> notifications;
  Function removeNotification;
  HomeFeedWidget({super.key, required this.user, required this.mostRecentPosts, required this.notifications, required this.removeNotification});

  @override
  State<HomeFeedWidget> createState() => _HomeFeedWidgetState();
}

class _HomeFeedWidgetState extends State<HomeFeedWidget>{
  List<Post> posts = [];
  @override
  void initState(){
    super.initState();
    setState(() => posts = widget.mostRecentPosts);
  }

  void removeNotification(GroupFlyNotification notification){
    widget.removeNotification(notification);
  }
  @override
  Widget build(BuildContext context) {
    setState(() {
      
    });
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 10, 70, 94),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 61, 111, 67),
        title: Text('Home Feed'),
        actions:[
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
            const Text("Most recent posts from friends:",
              style: TextStyle(
                color: Colors.black,
                fontSize: 48,
                fontWeight: FontWeight.w700,
                fontFamily: 'Mulish'
              )
            ),
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
  
  Widget displayNotificationList(){
    return NotificationList(notifications: widget.notifications, removeNotification: removeNotification);
  }
}