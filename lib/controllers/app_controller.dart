import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:groupfly_project/models/Group.dart';
import 'package:groupfly_project/models/GroupFlyNotification.dart';
import 'package:groupfly_project/services/authorization_service.dart';
import 'package:groupfly_project/widgets/ExplorerWidgets/profile_explorer_widget.dart';
import 'package:groupfly_project/widgets/GroupWidgets/group_navigation_widget.dart';

import '../models/FriendList.dart';
import '../models/Post.dart';
import '../models/group_fly_user.dart';
import '../screens/profile_screen.dart';
import '../services/repository_service.dart';
import '../widgets/HomeFeed/home_feed_widget.dart';

class AppController extends StatefulWidget {
  const AppController({super.key});

  @override
  State<AppController> createState() => _AppControllerState();
}

class _AppControllerState extends State<AppController>{
  Authorization _auth = Authorization();
  Widget? profileExplorer;
  Widget? groupNavigation;
  Widget? homeFeed;
  Widget? currentProfilePage;
  GroupFlyUser? currentUser;
  int? _currentPageIndex;
  FriendList? friends;
  List<Post> mostRecentPosts = [];
  List<GroupFlyUser> friendList = [];
  List<GroupFlyNotification> userNotifications = [];
  final int DEFAULT_PAGE = 2;
  //TODO: get groups & posts of user here.

  @override
  void initState(){
    super.initState();
    initUser();
    _currentPageIndex = DEFAULT_PAGE;
  }

  void initUser() async {
    await GetIt.instance<RepositoryService>().getGroupFlyUserByUID(_auth.currentUser!.uid).then((value) {
      setState(() {
        currentUser = value;
        if(currentUser!.active!){
          initInformationRelatedToUser();
        }
      });
    },);
  }
  void initInformationRelatedToUser() async{
    await GetIt.instance<RepositoryService>().getFriendsByUID(_auth.currentUser!.uid).then((list) {
      setState(() {
        friends = list;
        for(String uid in friends!.friend_uids){
          GetIt.instance<RepositoryService>().getGroupFlyUserByUID(uid).then((friend){
            friendList.add(friend);
          });
        }
        GetIt.instance<RepositoryService>().getRecentPostsByFriendUIDs(currentUser!, friends!).then(
          (posts) {
            GetIt.instance<RepositoryService>().getAllNotificationsByRequesteeUid(_auth.currentUser!.uid).then((notifications){
              setState(() {
                userNotifications = notifications;
                mostRecentPosts = posts;
                currentProfilePage = ProfileScreen(user: currentUser!, friends: friends!, removeFriend: removeFriend, notifications: userNotifications,);
                homeFeed = HomeFeedWidget(user: currentUser!, mostRecentPosts: mostRecentPosts, notifications: userNotifications, removeNotification: removeNotification,);
                groupNavigation = GroupNavigationWidget(friends: friendList, notifications: userNotifications, removeFriend: removeFriend,);
                profileExplorer = ProfileExplorerWidget(friendList: friends!, notifications: userNotifications, removeFriend: removeFriend,);
              });
            }); 
          }
        );
      });
    },);
  }

  void removeFriend(String uid){
    setState(() {
      friends!.friend_uids.removeWhere((friendUid) => friendUid == uid);
    });
  }

  void removeNotification(GroupFlyNotification notification){
    setState(() {
      userNotifications.removeWhere((userNotification) => userNotification == notification);
    });
  }
  
  @override
  Widget build(BuildContext context) {
    /*TODO: Cases:
    *   5: Refactor
    *     b: PUT ALL GENERAL QUERY STUFF HERE (i.e. groups by current user's uid, friends of current user's uid, posts)
    *     b: anything that doesn't look right on web
    *     c: improving the look a little
    */
    return Scaffold(
      body: currentUser == null ? Text("Loading...") : currentUser!.active! ? IndexedStack(
        index: _currentPageIndex,
        children: [
          profileExplorer == null ? Text("Loading...") : profileExplorer!,
          groupNavigation == null ? Text("Loading...") : groupNavigation!,
          homeFeed == null ? Text("Loading...") : homeFeed!,
          currentProfilePage == null ? Text("not yet loaded") : currentProfilePage!
        ],
      ) : Container(
        alignment: Alignment.center,
        color:Color.fromARGB(255, 10, 70, 94),
        child: Column(
          children: [
            const Text("Do you wish to reactivate your account?",
              style: TextStyle(
                color: Colors.black,
                fontSize: 48,
                fontWeight: FontWeight.w800,
                fontFamily: 'Mulish'
              )
            ),
            Row(
              children: [
                ElevatedButton(
                  onPressed: (){
                      initInformationRelatedToUser();
                      GetIt.instance<RepositoryService>().activateUser(currentUser!.uid!).then((value) {
                        setState(() {
                          currentUser!.reactivate();
                        });
                      },);
                  }, 
                  child: const Text("Yes")
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: (){
                    _auth.signOut();
                  }, 
                  child: const Text("No")
                )
              ],
            )
          ],
        )
      ),
      bottomNavigationBar: Visibility(
        visible: currentUser != null && currentUser!.active!,
        child: BottomNavigationBar(
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.black,
          showUnselectedLabels: true,
          currentIndex: _currentPageIndex!,
          items:const [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.accessibility_new_outlined,
                color: Colors.black,
              ), 
              label: "Find People"
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.group,
                color: Colors.black,
              ), 
              label: "Group Navigation"
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.home,
                color: Colors.black,
              ), 
              label: "Home"
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle,
                color: Colors.black,
              ), 
              label: "Profile"
            ),
          ],
          onTap: (newIndex) => setState(() {
            if(_currentPageIndex != newIndex){
              _currentPageIndex = newIndex;
            }
          }),
        ),
      ),
    );
  }
  
}