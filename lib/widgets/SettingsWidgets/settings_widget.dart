import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../services/authorization_service.dart';
import '../../services/repository_service.dart';
import 'change_password_widget.dart';

//A class that holds the account settings for the user.
class SettingsWidget extends StatefulWidget{
  SettingsWidget({super.key});

  @override
  State<SettingsWidget> createState() => _SettingsWidgetState();
}

class _SettingsWidgetState extends State<SettingsWidget>{
  //Authorization service for signing out and deactivating account.
  final Authorization _auth = Authorization();

  //Builds the SettingsWidget
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromARGB(255, 10, 70, 94),
      child: Column(
        children: [
          //BackButton to remove SettingsWidget from display
          Container(
            alignment: Alignment.topLeft,
            child: BackButton(
              onPressed: (){
                Navigator.of(context).pop();
              },
            )
          ),
          SizedBox(height: 10),
          //Settings Title label
          const Text("Settings",
            style: TextStyle(
              color: Colors.black,
              fontSize: 48,
              fontWeight: FontWeight.w700,
              fontFamily: 'Mulish'
            )
          ),
          SizedBox(height: 10),
          //Log out button
          ElevatedButton(
            onPressed: (){
              //Logs the user out and removes The SettingsWidget from the display, resulting in the login form being displayed.
              _auth.signOut();
              Navigator.of(context).pop();
            }, 
            child: const Text("Log Out",
              style: TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.w800,
                fontFamily: 'Mulish'
              )
            )
          ),
          SizedBox(height: 10),
          //Change password button.
          ElevatedButton(
            onPressed: (){
              //Displays a widget using changePasswordPopup()
              showModalBottomSheet(
                context: context,
                builder: ((builder) => changePasswordPopup()),
              );
            }, 
            child: const Text("Change Password",
              style: TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.w800,
                fontFamily: 'Mulish'
              )
            )
          ),
          SizedBox(height: 10),
          //Deactivate account button.
          ElevatedButton(
            onPressed: (){
              //Displays an alert dialog using _dialogBuilder()
              _dialogBuilder(context);
            }, 
            child: const Text("Deactivate account",
              style: TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.w800,
                fontFamily: 'Mulish'
              )
            )
          ),
        ],
      ),
    );
  }

  //Returns a ChangePasswordWidget
  Widget changePasswordPopup(){
    return ChangePasswordWidget();
  }

  //Returns an alert dialog confirming if the user would like to deactivate their account.
  //If the user confirms, the user is deactivated and promptly logged out. Then, the system removes the
  //alert dialog and the SettingsWidget from display, resulting in looking at the login form. 
  Future<void> _dialogBuilder(BuildContext context){
    return showDialog<void>(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          //Title for alert dialog
          title: const Text("Are you sure you would like to deactivate your account?",
            style: TextStyle(
              fontSize: 20, 
              fontWeight: FontWeight.w600,
              fontFamily: 'Mulish'
            ),
          ),
          actions: [
            //Yes button
            ElevatedButton(
              onPressed: () {
                //Sets the current user's "active" field in Firestore to false, then proceeds to sign the current
                //user out, and removes the alert dialog and the SettingsWidget from display.
                GetIt.instance<RepositoryService>().deactivateUser(_auth.currentUser!.uid).then((value) {
                  _auth.signOut();
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                });
              },
              child: const Text("Yes"),
            ),
            //No Button
            ElevatedButton(
              onPressed: () {
                //Removes the alert dialog from the display.
                Navigator.of(context).pop();
              },
              child: const Text("No"),
            )
          ],
        );
      }
    );
  }
}