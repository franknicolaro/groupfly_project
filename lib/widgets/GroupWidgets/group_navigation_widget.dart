import 'package:flutter/material.dart';

class GroupNavigationWidget extends StatefulWidget{

  @override
  State<GroupNavigationWidget> createState() => _GroupNavigationWidgetState();
}

class _GroupNavigationWidgetState extends State<GroupNavigationWidget>{
  Widget groupExplorer = Text("TODO: Implement Group Explorer");
  Widget myGroups = Text("TODO: Implement My Groups");
  int? _currentGroupWidgetIndex;
  final int DEFAULT_WIDGET = 0;

  @override
  void initState(){
    super.initState();
    _currentGroupWidgetIndex = DEFAULT_WIDGET;
  }
  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 10, 70, 94),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 61, 111, 67),
        title: Text('Group Navigation'),
        actions:[
          TextButton.icon(
            onPressed:(){
              //Display notifications widget
            },
            icon: const Icon(Icons.add_alert_sharp),
            label: const Text("Notifications")
          )
        ]
      ),
      body: IndexedStack(
        index: _currentGroupWidgetIndex,
        children: [
          myGroups,
          groupExplorer
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