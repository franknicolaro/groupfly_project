import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:groupfly_project/services/authorization_service.dart';
import 'package:groupfly_project/widgets/ExplorerWidgets/profile_explorer_widget.dart';
import 'package:groupfly_project/widgets/GroupWidgets/group_navigation_widget.dart';

import '../models/group_fly_user.dart';
import '../screens/profile_screen.dart';
import '../services/repository_service.dart';

class AppController extends StatefulWidget {
  const AppController({super.key});

  @override
  State<AppController> createState() => _AppControllerState();
}

class _AppControllerState extends State<AppController>{
  Authorization _auth = Authorization();
  Widget profileExplorer = ProfileExplorerWidget();
  Widget groupNavigation = GroupNavigationWidget();
  Widget pageThree = Text("3: TODO: Implement Home Page with User Feed");
  Widget? currentProfilePage;
  GroupFlyUser? currentUser;
  int? _currentPageIndex;
  final int DEFAULT_PAGE = 2;
  //TODO: get groups of user here.

  @override
  void initState(){
    super.initState();
    initUser();
    _currentPageIndex = DEFAULT_PAGE;
  }

  void initUser() {
    GetIt.instance<RepositoryService>().getGroupFlyUserByUID(_auth.currentUser!.uid).then((value) {
      setState(() {
        currentProfilePage = ProfileScreen(user: value);
      });
    },);
  }
  @override
  Widget build(BuildContext context) {
    /*TODO: Cases:
    *   1: Home page
    *     a: User feed
    *   2: Account/Profile Navigation 
    *     a: Settings page within account tab
    *     c: friends page
    *   3: Group Navigation
    *     a: Group Explorer
    *     b: My Groups
    *   4: Notifications Widget
    *     a: displaying all notifications
    *     b: Accept invite/request pages(widgets?)
    */
    return Scaffold(
      body: IndexedStack(
        index: _currentPageIndex,
        children: [
          profileExplorer,
          groupNavigation,
          pageThree,
          currentProfilePage == null ? Text("not yet loaded") : currentProfilePage!
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
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
    );
  }
  
}