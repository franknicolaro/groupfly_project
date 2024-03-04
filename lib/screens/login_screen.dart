import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:groupfly_project/widgets/LoginWidgets/login_widget_web.dart';

import '../widgets/LoginWidgets/login_widget_mobile.dart';

class LoginScreen extends StatefulWidget{
  final Function switchView;
  LoginScreen({super.key, required this.switchView});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>{
  //TODO: class for handling signing in and registering will go here. 
  @override
  Widget build(BuildContext context) {
    if(kIsWeb){
      return LoginWidgetWeb(switchView: widget.switchView);
    }
    else{ 
      return LoginWidgetMobile(switchView: widget.switchView);
    }
    // TODO: implement widgets for mobile and web ^^^^. 
  }
}