import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:groupfly_project/widgets/RegisterWidgets/register_widget_web.dart';

import '../widgets/RegisterWidgets/register_widget_mobile.dart';

class RegisterScreen extends StatefulWidget{
  final Function switchView;
  final Function setHobbies;
  RegisterScreen({super.key, required this.switchView, required this.setHobbies});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>{
  //TODO: class for handling signing in and registering will go here. 
  @override
  Widget build(BuildContext context) {
    if(kIsWeb){
      return RegisterWidgetWeb(switchView: widget.switchView, setHobbies: widget.setHobbies,);
    }
    else{ 
      return RegisterWidgetMobile(switchView: widget.switchView);
    }
    // TODO: add setHobbies to Mobile version. 
  }
}