import 'package:flutter/material.dart';
import 'package:groupfly_project/models/group_fly_user.dart';
import 'package:groupfly_project/widgets/ExplorerWidgets/group_explorer_widget.dart';
import 'package:groupfly_project/widgets/GroupWidgets/my_groups_widget.dart';

import '../../models/Group.dart';
import '../../models/GroupFlyNotification.dart';

//The navigation for the two group pages.
class GroupNavigationWidget extends StatefulWidget{
  //List of friends, groups and notifications.
  List<GroupFlyUser> friends;
  List<GroupFlyNotification> notifications;
  List<Group> groups;
  //removeFriend and addGroup functions from AppController.
  Function removeFriend;
  Function addGroup;
  GroupNavigationWidget({required this.friends, required this.notifications, required this.removeFriend, required this.groups, required this.addGroup});
  @override
  State<GroupNavigationWidget> createState() => _GroupNavigationWidgetState();
}

class _GroupNavigationWidgetState extends State<GroupNavigationWidget>{
  //Widgets to be utilized in IndexedStack.
  Widget? groupExplorer;
  Widget? myGroups;

  //Index variables.
  int? _currentGroupWidgetIndex;
  final int DEFAULT_WIDGET = 0;

  //Initializes the current index as well as the widgets in the Indexed Stack
  @override
  void initState(){
    super.initState();
    _currentGroupWidgetIndex = DEFAULT_WIDGET;
    myGroups = MyGroupsWidget(friends: widget.friends, removeFriend: widget.removeFriend, groups: widget.groups, addGroup: widget.addGroup,);
    groupExplorer = GroupExplorerWidget(friendList: widget.friends, removeFriend: widget.removeFriend);
  }

  //Builds the GroupNavigation widget.
  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 10, 70, 94),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 61, 111, 67),
        title: Text('Group Navigation'),
      ),
      //IndexedStack that determines which widget is displayed.
      body: IndexedStack(
        index: _currentGroupWidgetIndex,
        children: [
          myGroups == null ? Text("Loading...") : myGroups!,
          groupExplorer == null ? Text("Loading...") : groupExplorer!
        ]
      ),
      //BottomNavigationBar with the My Groups and Group Explorer icons.
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black,
        showUnselectedLabels: true,
        currentIndex: _currentGroupWidgetIndex!,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.groups_sharp,
              color: Colors.black
            ),
            label: "My Groups"
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.group,
              color: Colors.black
            ),
            label: "Group Explorer"
          ),
        ],
        //Sets the current index to the new index depending on what was tapped.
        onTap: (newIndex) => setState(() {
          if(_currentGroupWidgetIndex != newIndex){
            _currentGroupWidgetIndex = newIndex;
          }
        })
      ),
    );
  }
}