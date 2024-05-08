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
  String currentPage = "login";     //Keeps track of the current page, which determines what is displayed.
  List<Hobby> selectedHobbies =[];  //Holds the selected hobbies, which is passed through to the VerifyAccountScreen.

  //Sets the currentPage to the page String that was passed through from the current displayed screen.
  void switchView(String page) {
    setState(() => currentPage = page);
  } 

  //Sets the selectedHobbies to a List of Hobbies, which is to be inserted upon verification of the user.
  void setHobbies(List<Hobby> hobbies){
    setState(() => selectedHobbies = hobbies);
  }

  @override
  Widget build(BuildContext context) {
    //Displays a screen based on the following logic:
    //  1) "login": LoginScreen
    //  2) "register": RegisterScreen
    //  3) "verify": VerifyAccountScreen
    //  4) Otherwise, display an error Text.
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