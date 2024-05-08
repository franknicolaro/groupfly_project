import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:groupfly_project/services/authorization_service.dart';

import '../../models/Hobby.dart';
import '../../services/repository_service.dart';

class VerificationWidgetWeb extends StatefulWidget{
  //Function and list of hobbies passed through from LoginController.
  final Function switchView;
  final List<Hobby> hobbies;

  VerificationWidgetWeb({super.key, required this.switchView, required this.hobbies});

  @override
  _VerificationWidgetWebState createState() => _VerificationWidgetWebState();
}

class _VerificationWidgetWebState extends State<VerificationWidgetWeb>{
  //Authorization service to verify the user account.
  final Authorization _auth = Authorization();

  //initialization of other vairables used.
  Timer? timer;
  User? user;
  bool emailVerified = false;

  @override
  void initState(){
    super.initState();
    user = _auth.currentUser;
    //Timer to check if the current user is verified.
    timer = Timer.periodic(
      const Duration(seconds: 10),
      (timer){
        checkIfVerified();
      }
    );
  }

  //Function to confirm if the user is verified. If it is, then 
  //stop the timer, activate the user,and initialize
  //the user's friends document and hobbies document.
  Future<void> checkIfVerified() async {
    user = _auth.currentUser;
    await user?.reload();
    if(user != null && user!.emailVerified){
      await GetIt.instance<RepositoryService>().activateUser(user!.uid);
      await GetIt.instance<RepositoryService>().initFriendDocument(user!.uid);
      await GetIt.instance<RepositoryService>().insertHobbies(widget.hobbies);
      setState(() {});
      timer?.cancel();
    }
  }
  @override
  Widget build(BuildContext context){
    //Scaffold for Account Verification.
    return Scaffold(
      //Simple AppBar with title
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text('Verify Account'),
      ),
      //Container for email verification.
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 35.0),
        child: Column(
          children:[
            const Text("An email has been sent to your email to verify your account."),
            //Button which sends user back to login and calls signOut in Authorization service.
            ElevatedButton(
              onPressed: () {
                _auth.signOut();
                widget.switchView("login");
              },
              child: const Text('Back to Login',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Mulish',
                )
              )
            ),
            //Button which re-sends an email verification to the user's email.
            ElevatedButton(
              onPressed: () {
                user?.sendEmailVerification();
              },
              child: const Text('Re-Send email verification',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Mulish',
                )
              )
            )
          ]
        )
      )
    );
  }
}