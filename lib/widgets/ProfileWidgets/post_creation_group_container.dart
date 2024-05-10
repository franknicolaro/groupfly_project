import 'package:flutter/material.dart';

import '../../models/Group.dart';

//A class that holds the container for groups in the post creation form.
class PostCreationGroupContainer extends StatefulWidget{
  Group group;
  PostCreationGroupContainer({required this.group});
  @override
  State<PostCreationGroupContainer> createState() => _PostCreationGroupContainer();
}

class _PostCreationGroupContainer extends State<PostCreationGroupContainer>{
  //Builds the PostCreationGroupContainer, which is a container holding 
  //the title of the group.
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        color: Color.fromARGB(255, 10, 70, 94),
        height: MediaQuery.of(context).size.height * 0.15,
        width: MediaQuery.of(context).size.width * 0.17,
        child: Text(widget.group.title,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black,
            fontSize: 12,
            fontWeight: FontWeight.w700,
            fontFamily: 'Mulish'
          )
        )
      )
    );
  }
}