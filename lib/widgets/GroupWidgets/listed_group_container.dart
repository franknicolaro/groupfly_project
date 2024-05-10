import 'package:flutter/material.dart';
import 'package:groupfly_project/models/group_fly_user.dart';

import '../../models/Group.dart';
import 'group_widget.dart';

//Displays a simple container of basic information of the group.
class ListedGroupContainer extends StatefulWidget{
  Group group;                //The group that correlates to the Widget to be displayed.
  List<GroupFlyUser> friends; //The list of friends
  Function removeFriend;      //removeFriend from AppController
  ListedGroupContainer({required this.group, required this.friends, required this.removeFriend});
  @override
  State<ListedGroupContainer> createState() => _ListedGroupContainerState();
}

class _ListedGroupContainerState extends State<ListedGroupContainer>{
  //A method which updates the UI of the container.
  void refresh(){
    setState(() {});
  }

  //Builds the ListedGroupContainer.
  @override
  Widget build(BuildContext context){
    return Column(
      children: [
        SizedBox(height: 18),
        //Button which calls to a method which displays the 
        //GroupWidget (see group_widget.dart) over the page that 
        //this ListedGroupContainer is on.
        OutlinedButton(
          onPressed: (){
            showModalBottomSheet(
              isScrollControlled: true,
              context: context, 
              builder: ((builder) => displayGroupPage())
            );
          },
          child: Container(
            padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
            height: MediaQuery.of(context).size.height * 0.15,
            width: MediaQuery.of(context).size.width * 0.33,
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 17, 127, 171),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Group Title
                Expanded(
                  child: Container(
                    alignment: Alignment.topLeft,
                    padding: EdgeInsets.fromLTRB(5, 5, 0, 0),
                    child: Text(
                      widget.group.title,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Mulish'
                      ),
                    )
                  ),
                ),
                //Member Capacity
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      "Members: ${widget.group.member_uids.length}/${widget.group.maxCapacity}",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Mulish'
                      )
                    )
                  ),
                ),
                //Hobby pertained to the group.
                Expanded(
                  child: Container(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      "Hobby: ${widget.group.hobbyName}",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Mulish'
                      )
                    )
                  ),
                )
              ],
            )
          )
        ),
        SizedBox(height: 18),
      ],
    );
  }
  //Displays the GroupWidget, pertaining to the group of the ListedGroupContainer
  Widget displayGroupPage(){
    return Container(
      color: Color.fromARGB(255, 17, 127, 171),
      child: GroupWidget(group: widget.group, notifyWidget: refresh, friends: widget.friends, removeFriend: widget.removeFriend,)
    );
  }
}