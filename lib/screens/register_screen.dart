import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:groupfly_project/widgets/RegisterWidgets/register_widget_web.dart';

//A screen that displays the registration form.
class RegisterScreen extends StatefulWidget{
  //Functions provided from LoginController.
  final Function switchView;
  final Function setHobbies;
  RegisterScreen({super.key, required this.switchView, required this.setHobbies});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>{
  //Displays the RegisterWidget based on the platform.
  @override
  Widget build(BuildContext context) {
    if(kIsWeb){
      return RegisterWidgetWeb(switchView: widget.switchView, setHobbies: widget.setHobbies,);
    }
    else{ 
      return Text("TODO: Mobile version of RegisterWidget.");
    }
  }
}