import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../models/Hobby.dart';
import '../widgets/VerificationWidgets/VerificationWidgetWeb.dart';

class VerifyAccountScreen extends StatefulWidget{
  final Function switchView;
  final List<Hobby> hobbies;

  VerifyAccountScreen({super.key, required this.switchView, required this.hobbies});

  @override
  _VerifyAccountScreenState createState() => _VerifyAccountScreenState();
}

class _VerifyAccountScreenState extends State<VerifyAccountScreen>{
  @override
  Widget build(BuildContext context){
    if(kIsWeb){
      return VerificationWidgetWeb(switchView: widget.switchView, hobbies: widget.hobbies);
      //return Text("TODO: implement VerificationWidgetWeb");
    }
    else{
      //return VerificationWidgetMobile(switchView: widget.switchView);
      return Text("TODO: implement VerificationWidgetMobile");
    }
  }
}