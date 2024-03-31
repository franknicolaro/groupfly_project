import 'package:flutter/material.dart';

import '../../models/Group.dart';

class ListedGroupContainer extends StatefulWidget{
  Group group;
  ListedGroupContainer({required this.group});
  @override
  State<ListedGroupContainer> createState() => _ListedGroupContainerState();
}

class _ListedGroupContainerState extends State<ListedGroupContainer>{
  @override
  Widget build(BuildContext context){
    return Column(
      children: [
        SizedBox(height: 18),
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
                Container(
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.fromLTRB(5, 5, 0, 0),
                  child: Text(
                    widget.group.title,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Mulish'
                    ),
                  )
                ),
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    "Members: ${widget.group.member_uids.length}/${widget.group.maxCapacity}",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Mulish'
                    )
                  )
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(0, 0, 5, 5),
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    "Hobby: ${widget.group.hobbyName}",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Mulish'
                    )
                  )
                )
              ],
            )
          )
        ),
        SizedBox(height: 18),
      ],
    );
  }
  Widget displayGroupPage(){
    return Container(
      color: Color.fromARGB(255, 17, 127, 171),
      child: Text("TODO: Group Widget")//GroupWidget(group: widget.group)
    );
  }
}