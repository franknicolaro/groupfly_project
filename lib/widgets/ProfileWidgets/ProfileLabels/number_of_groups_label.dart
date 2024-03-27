
import 'package:flutter/material.dart';

class NumberOfGroupsLabel extends StatefulWidget{
  int numberOfGroups;
  NumberOfGroupsLabel({required this.numberOfGroups});
  @override
  State<NumberOfGroupsLabel> createState() => _NumberOfGroupsLabelState();
}

class _NumberOfGroupsLabelState extends State<NumberOfGroupsLabel>{
  @override
  void initState(){
    super.initState();
    //initGroups();
  }

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