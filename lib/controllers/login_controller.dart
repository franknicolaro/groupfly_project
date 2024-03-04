import 'package:flutter/material.dart';
import 'package:groupfly_project/screens/verify_account_screen.dart';

import '../models/Hobby.dart';
import '../screens/login_screen.dart';
import '../screens/register_screen.dart';

class LoginController extends StatefulWidget {
  const LoginController({super.key});

  @override
  State<LoginController> createState() => _LoginControllerState();
}

class _LoginControllerState extends State<LoginController> {
  String currentPage = "login";
  List<Hobby> selectedHobbies =[];
  void switchView(String page) {
    setState(() => currentPage = page);
  } 
  void setHobbies(List<Hobby> hobbies){
    setState(() => selectedHobbies = hobbies);
  }

  @override
  Widget build(BuildContext context) {
    if(currentPage == "login"){
      return LoginScreen(switchView: switchView);
    }
    else if(currentPage == "register"){
      return RegisterScreen(switchView: switchView, setHobbies: setHobbies);
    }
    else if(currentPage == "verify"){
      return VerifyAccountScreen(switchView: switchView, hobbies: selectedHobbies);
    }
    return Text("Error: Page does not exist.");
  }
}