import 'dart:io';

import 'package:flutter/material.dart';

import '../../services/authorization_service.dart';

class ProfilePictureWidget extends StatefulWidget{

  String imageUrl;
  ProfilePictureWidget({required this.imageUrl});

  @override
  State<ProfilePictureWidget> createState() => _ProfilePictureWidgetState();
}

class _ProfilePictureWidgetState extends State<ProfilePictureWidget>{
  Authorization _auth = Authorization();
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