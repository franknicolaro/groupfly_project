import 'package:flutter/material.dart';

import '../../models/Group.dart';

class PostCreationGroupContainer extends StatefulWidget{
  Group group;
  PostCreationGroupContainer({required this.group});
  @override
  State<PostCreationGroupContainer> createState() => _PostCreationGroupContainer();
}

class _PostCreationGroupContainer extends State<PostCreationGroupContainer>{
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.15,
        width: MediaQuery.of(context).size.width * 0.17,
        child: Text(widget.group.title,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            fontFamily: 'Mulish'
          )
        )
      )
    );
  }

}