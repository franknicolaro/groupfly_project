import 'package:flutter/material.dart';
import 'package:groupfly_project/models/group_fly_user.dart';
import 'package:groupfly_project/widgets/ExplorerWidgets/group_explorer_widget.dart';
import 'package:groupfly_project/widgets/GroupWidgets/my_groups_widget.dart';

import '../../models/GroupFlyNotification.dart';

class GroupNavigationWidget extends StatefulWidget{
  List<GroupFlyUser> friends;
  List<GroupFlyNotification> notifications;
  Function removeFriend;
  GroupNavigationWidget({required this.friends, required this.notifications, required this.removeFriend});
  @override
  State<GroupNavigationWidget> createState() => _GroupNavigationWidgetState();
}

class _GroupNavigationWidgetState extends State<GroupNavigationWidget>{
  Widget? groupExplorer;
  Widget? myGroups;
  int? _currentGroupWidgetIndex;
  final int DEFAULT_WIDGET = 0;

  @override
  void initState(){
    super.initState();
    _currentGroupWidgetIndex = DEFAULT_WIDGET;
    myGroups = MyGroupsWidget(friends: widget.friends, removeFriend: widget.removeFriend,);
    groupExplorer = GroupExplorerWidget(friendList: widget.friends, removeFriend: widget.removeFriend);
  }
  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 10, 70, 94),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 61, 111, 67),
        title: Text('Group Navigation'),
      ),
      body: IndexedStack(
        index: _currentGroupWidgetIndex,
        children: [
          myGroups == null ? Text("Loading...") : myGroups!,
          groupExplorer == null ? Text("Loading...") : groupExplorer!
        ]
      ),
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
        onTap: (newIndex) => setState(() {
          if(_currentGroupWidgetIndex != newIndex){
            _currentGroupWidgetIndex = newIndex;
          }
        })
      ),
    );
  }
}