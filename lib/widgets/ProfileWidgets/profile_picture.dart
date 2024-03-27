import 'package:flutter/material.dart';

class ProfilePictureWidget extends StatefulWidget{

  String imageUrl;
  ProfilePictureWidget({required this.imageUrl});

  @override
  State<ProfilePictureWidget> createState() => _ProfilePictureWidgetState();
}

class _ProfilePictureWidgetState extends State<ProfilePictureWidget>{
  @override
  Widget build(BuildContext context){
    return CircleAvatar(
      radius: 80,
      backgroundColor: Colors.black45,
      child: CircleAvatar(
        radius: 77,
        backgroundImage: NetworkImage(widget.imageUrl),
      )
    );
  }
}