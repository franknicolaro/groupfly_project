
import 'package:flutter/material.dart';

//A simple label which displays the number of groups that the user participated in.
class NumberOfGroupsLabel extends StatefulWidget{
  int numberOfGroups;     //number of groups
  NumberOfGroupsLabel({required this.numberOfGroups});
  @override
  State<NumberOfGroupsLabel> createState() => _NumberOfGroupsLabelState();
}

class _NumberOfGroupsLabelState extends State<NumberOfGroupsLabel>{
  //Builds the label, which takes the number of groups participated in.
  @override
  Widget build(BuildContext context){
    return Text(
      'Number of Groups Participated in: ${widget.numberOfGroups}',
        style: TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          fontFamily: 'Mulish',
        )
      );
  }
}