import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:groupfly_project/widgets/LoginWidgets/login_widget_web.dart';

//A screen that displays the login form.
class LoginScreen extends StatefulWidget{
  //Function provided from LoginController
  final Function switchView;
  LoginScreen({super.key, required this.switchView});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>{
  //Displays the LoginWidget based on the platform.
  @override
  Widget build(BuildContext context) {
    if(kIsWeb){
      return LoginWidgetWeb(switchView: widget.switchView);
    }
    else{ 
      return Text("TODO: Mobile Version Implementation");
    }
  }
}