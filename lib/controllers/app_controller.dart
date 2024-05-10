import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:groupfly_project/models/GroupFlyNotification.dart';
import 'package:groupfly_project/services/authorization_service.dart';
import 'package:groupfly_project/widgets/ExplorerWidgets/profile_explorer_widget.dart';
import 'package:groupfly_project/widgets/GroupWidgets/group_navigation_widget.dart';

import '../models/FriendList.dart';
import '../models/Group.dart';
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
  //Authorization service to getting user information.
  Authorization _auth = Authorization();

  //Widgets to be initialized in IndexedStack and BottomNavigationBar.
  Widget? profileExplorer;
  Widget? groupNavigation;
  Widget? homeFeed;
  Widget? currentProfilePage;

  //Global Keys to call state methods from here.
  //GlobalKey<profileExplorer> profileExplorerKey = GlobalKey();

  //Variables for indexing for IndexedStack.
  int? _currentPageIndex;
  final int DEFAULT_PAGE = 2;

  //Current user information
  GroupFlyUser? currentUser;
  FriendList? friends;
  List<Post> mostRecentPosts = [];
  List<GroupFlyUser> friendList = [];
  List<GroupFlyNotification> userNotifications = [];
  List<Group> groups = [];
  

  @override
  void initState(){
    super.initState();
    initUser();
    _currentPageIndex = DEFAULT_PAGE;
  }

  //Initializes user, then calls initInformationRelatedToUser.
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

  //Initalizes information related to the active user. 
  //If the user is inactive, this will not be called until the user reactivates. 
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
            GetIt.instance<RepositoryService>().getGroupsByMemberUID(currentUser!.uid!).then((obtianedGroups) {
              GetIt.instance<RepositoryService>().getAllNotificationsByRequesteeUid(_auth.currentUser!.uid).then((notifications){
                setState(() {
                  groups = obtianedGroups;
                  userNotifications = notifications;
                  mostRecentPosts = posts;
                  currentProfilePage = ProfileScreen(user: currentUser!, friends: friends!, removeFriend: removeFriend, notifications: userNotifications,);
                  homeFeed = HomeFeedWidget(user: currentUser!, mostRecentPosts: mostRecentPosts, notifications: userNotifications, removeNotification: removeNotification,);
                  groupNavigation = GroupNavigationWidget(friends: friendList, notifications: userNotifications, removeFriend: removeFriend, groups: groups, addGroup: addGroup,);
                  profileExplorer = ProfileExplorerWidget(friendList: friends!, notifications: userNotifications, removeFriend: removeFriend,);
                });
              }); 
            },);
          }
        );
      });
    },);
  }

  //Removes the friend from current user's friends based on the uid passed.
  void removeFriend(String uid){
    setState(() {
      friends!.friend_uids.removeWhere((friendUid) => friendUid == uid);
    });
  }

  //Removes the notification from the current user's notifications list.
  void removeNotification(GroupFlyNotification notification){
    setState(() {
      userNotifications.removeWhere((userNotification) => userNotification == notification);
    });
  }

  //Adds the group to the current user's groups.
  void addGroup(Group group){
    setState(() {
      groups.add(group);
    });
  }
  
  @override
  Widget build(BuildContext context) {
    //Scaffold which holds the defined widgets from above
    return Scaffold(
      //The body is defined based on if the user is active. If they are, display the IndexedStack
      //as normal, which displays all defined widgets above.
      body: currentUser == null ? Text("Loading...") : currentUser!.active! ? IndexedStack(
        index: _currentPageIndex,
        children: [
          profileExplorer == null ? Text("Loading...") : profileExplorer!,
          groupNavigation == null ? Text("Loading...") : groupNavigation!,
          homeFeed == null ? Text("Loading...") : homeFeed!,
          currentProfilePage == null ? Text("Loading...") : currentProfilePage!
        ],
      ) : 
      //If the user is not active, then display a Container which confirms if the user would like
      //to reactivate their account. 
      Container(
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
                //Button to confirm reactivation, where the system obtains information related to the
                //user and activates the user.
                ElevatedButton(
                  onPressed: (){
                    GetIt.instance<RepositoryService>().activateUser(currentUser!.uid!).then((value) {
                      setState(() {
                        initInformationRelatedToUser();
                        currentUser!.reactivate();
                      });
                    },);
                  }, 
                  child: const Text("Yes")
                ),
                //Button to deny reactivation, logging out the user.
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
      //BottomNavigationBar which is visible if there is an active user. 
      bottomNavigationBar: Visibility(
        visible: currentUser != null && currentUser!.active!,
        child: BottomNavigationBar(
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.black,
          showUnselectedLabels: true,
          currentIndex: _currentPageIndex!,
          //Each of these show up as buttons to click on in the navigation bar.
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
          //Switch the index of the current page to the new index.
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