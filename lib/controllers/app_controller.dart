import 'package:flutter/material.dart';

import '../screens/profile_screen.dart';

class AppController extends StatefulWidget {
  const AppController({super.key});

  @override
  State<AppController> createState() => _AppControllerState();
}

class _AppControllerState extends State<AppController>{
  Widget pageOne = Text("1: TODO: Implement Profile Explorer");
  Widget pageTwo = Text("2: TODO: Implement Group Navigation");
  Widget pageThree = Text("3: TODO: Implement Home Page with User Feed");
  Widget profilePage = ProfileScreen();//Text("4: TODO: Implement Account Navigation");
  int? _currentPageIndex;
  final int DEFAULT_PAGE = 2;

  @override
  void initState(){
    super.initState();
    _currentPageIndex = DEFAULT_PAGE;
  }
  @override
  Widget build(BuildContext context) {
    /*TODO: Cases:
    *   1: Home page
    *     a: User feed
    *   2: Account/Profile Navigation
    *     a: Settings page within account tab
    *     b: profile with posts
    *     c: friends page
    *   3: Group Navigation
    *     a: Group Explorer
    *     b: My Groups
    *   4: Notifications Widget
    *     a: displaying all notifications
    *     b: Accept invite/request pages(widgets?)
    *   5: Profile Explorer 
    */
    return Scaffold(
      body: IndexedStack(
        index: _currentPageIndex,
        children: [
          pageOne,
          pageTwo,
          pageThree,
          profilePage
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