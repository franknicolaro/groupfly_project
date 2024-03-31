import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:groupfly_project/services/authorization_service.dart';

import '../../models/Hobby.dart';
import '../../services/repository_service.dart';

class VerificationWidgetWeb extends StatefulWidget{
  final Function switchView;
  final List<Hobby> hobbies;

  VerificationWidgetWeb({super.key, required this.switchView, required this.hobbies});

  @override
  _VerificationWidgetWebState createState() => _VerificationWidgetWebState();
}

class _VerificationWidgetWebState extends State<VerificationWidgetWeb>{
  final Authorization _auth = Authorization();
  Timer? timer;
  User? user;
  bool emailVerified = false;

  @override
  void initState(){
    super.initState();
    user = _auth.currentUser;
    timer = Timer.periodic(
      const Duration(seconds: 10),
      (timer){
        checkIfVerified();
      }

    );
  }

  Future<void> checkIfVerified() async {
    user = _auth.currentUser;
    await user?.reload();
    if(user != null && user!.emailVerified){
      await GetIt.instance<RepositoryService>().insertHobbies(widget.hobbies);
      timer?.cancel();
    }
  }
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text('Verify Account'),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 35.0),
        child: Column(
          children:[
            const Text("An email has been sent to your email to verify your account."),
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