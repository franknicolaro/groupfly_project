import 'package:flutter/material.dart';

//A class intended to create the profile picture on the GeneralProfileWidget.
class ProfilePictureWidget extends StatefulWidget{
  String imageUrl;    //URL of the profile picture.
  ProfilePictureWidget({required this.imageUrl});

  @override
  State<ProfilePictureWidget> createState() => _ProfilePictureWidgetState();
}

class _ProfilePictureWidgetState extends State<ProfilePictureWidget>{

  //Builds the ProfilePictureWidget.
  @override
  Widget build(BuildContext context){
    //Outer CircleAvatar for a border, followed by an
    //inner Circle Avatar to display the image.
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