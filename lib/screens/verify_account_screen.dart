import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../models/Hobby.dart';
import '../widgets/VerificationWidgets/VerificationWidgetWeb.dart';

//A screen that displays an account verification widget.
class VerifyAccountScreen extends StatefulWidget{
  final Function switchView;  //Function provided from LoginController
  final List<Hobby> hobbies;  //A list of Hobbies provided from LoginController

  VerifyAccountScreen({super.key, required this.switchView, required this.hobbies});

  @override
  _VerifyAccountScreenState createState() => _VerifyAccountScreenState();
}

class _VerifyAccountScreenState extends State<VerifyAccountScreen>{
  //Displays the VerificationWidget based on the platform.
  @override
  Widget build(BuildContext context){
    if(kIsWeb){
      return VerificationWidgetWeb(switchView: widget.switchView, hobbies: widget.hobbies);
    }
    else{
      return Text("TODO: implement VerificationWidgetMobile");
    }
  }
}