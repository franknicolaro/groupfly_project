import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:groupfly_project/services/authorization_service.dart';
import 'package:groupfly_project/services/repository_service.dart';
import 'package:groupfly_project/widgets/ProfileWidgets/ProfileLabels/number_of_groups_label.dart';
import 'package:groupfly_project/widgets/ProfileWidgets/ProfileLabels/username_label.dart';
import 'package:groupfly_project/widgets/ProfileWidgets/profile_picture.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

import 'ProfileLabels/friend_count_label.dart';

class UserProfileWidgetWeb extends StatefulWidget {

  @override
  State<UserProfileWidgetWeb> createState() => _UserProfileWidgetWebState();
}

class _UserProfileWidgetWebState extends State<UserProfileWidgetWeb>{
  Authorization _auth = Authorization();
  FirebaseStorage storage = FirebaseStorage.instance;
  PickedFile? _imageFile;
  final ImagePicker _imagePicker = ImagePicker();
  String? userName;
  var user;
  @override
  void initState(){
    super.initState();
    initUser();
  }
  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 10, 70, 94),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 61, 111, 67),
        title: Text('User Profile'),
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
      body: Container(
        child: Column(
          children: [
            Center(
              child: Stack(
                children: <Widget>[
                  ProfilePictureWidget(
                    imageUrl: _auth.currentUser!.photoURL == null ? "https://images.vexels.com/media/users/3/180861/isolated/preview/f68f0a8f6f1901015166ae2f9d8a39f8-cute-ladybug-flying-outline.png" : _auth.currentUser!.photoURL!,
                  ),
                  Positioned(
                    bottom: 20,
                    right: 20,
                    child: InkWell(
                      onTap:(){
                        showModalBottomSheet(
                          context: context, 
                          builder: ((builder) => photoPopUp()),
                        );
                      },
                      child: Icon(
                        Icons.camera_alt,
                        color: Colors.black45,
                        size: 30
                      )
                    ),
                  )
                ]
              ),
            ),
            UsernameLabel(),
            Center(
              child: Row(
                children: [
                  const SizedBox(width: 30),
                  FriendCountLabel(),
                  const SizedBox(width: 100),
                  NumberOfGroupsLabel(),
                  const SizedBox(width: 30),
                ]
              )
            )
            /*IN THIS ORDER FROM TOP TO BOTTOM:
            * Profile with Picture (ImageDecorator..? Also need
            * to figure out how to upload pictures on user's end and
            * system's end).
            * Username (Text/Label)
            * ROW(
            *   Friend count(Text/Label), 
                  Friend Table
                  where clause (uid = the current user's id)
            *   # of groups participated in(Text/Label),
                  Get groups by uid in terms of members.
            *   # of posts(Text/Label)
            * )
            * Profile Settings button(for now a simple button)
            * Posts (SingleChildScrollWheel) TODO: Post model and Post Repo
            * 
            */
          ]
        ),
      ),
    );
  }
  void initUser() {
    user = GetIt.instance<RepositoryService>().getGroupFlyUserByUID(_auth.currentUser!.uid);
  }
  void takePhoto(ImageSource source) async{
    final selectedFile = await _imagePicker.pickImage(
      source: source,
    );
    if(selectedFile != null){
      Reference ref = FirebaseStorage.instance.ref().child("images/${_auth.currentUser!.uid}");
      TaskSnapshot taskSnapshot = await ref.putData(await selectedFile.readAsBytes());
      String url = await taskSnapshot.ref.getDownloadURL();
      await _auth.currentUser!.updatePhotoURL(url);
      setState(() {
        _imageFile = PickedFile(url);
      });
    }
  }
  Widget photoPopUp() {
    return Container(
      height: 75,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        children: [
          Text(
            "How would you like to select your photo?",
            style: TextStyle(
              fontSize: 20
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton.icon(
                icon: Icon(Icons.camera_alt),
                onPressed: (){
                  takePhoto(ImageSource.camera);
                },
                label: Text("Take a photo"),
              ),
              TextButton.icon(
                icon: Icon(Icons.image),
                onPressed:(){
                  takePhoto(ImageSource.gallery);
                },
                label: Text("Choose a photo")
              )
            ]
          )
        ],
      )
    );
  }
}