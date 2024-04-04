import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../services/authorization_service.dart';
import '../../services/repository_service.dart';
import 'change_password_widget.dart';

class SettingsWidget extends StatefulWidget{
  SettingsWidget({super.key});

  @override
  State<SettingsWidget> createState() => _SettingsWidgetState();
}

class _SettingsWidgetState extends State<SettingsWidget>{
  Authorization _auth = Authorization();

  //Settings label
  //Change Password Button
  //Logout Button
  //Deactivate Account Button. 
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromARGB(255, 10, 70, 94),
      child: Column(
        children: [
          Container(
            alignment: Alignment.topLeft,
            child: BackButton(
              onPressed: (){
                Navigator.of(context).pop();
              },
            )
          ),
          SizedBox(height: 10),
          const Text("Settings",
            style: TextStyle(
              color: Colors.black,
              fontSize: 48,
              fontWeight: FontWeight.w700,
              fontFamily: 'Mulish'
            )
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: (){
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
          ElevatedButton(
            onPressed: (){
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
          ElevatedButton(
            onPressed: (){
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

  Widget changePasswordPopup(){
    return ChangePasswordWidget();
  }
  Future<void> _dialogBuilder(BuildContext context){
    return showDialog<void>(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          title: const Text("Are you sure you would like to deactivate your account?",
            style: TextStyle(
              fontSize: 20, 
              fontWeight: FontWeight.w600,
              fontFamily: 'Mulish'
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () async{
                await GetIt.instance<RepositoryService>().deactivateUser(_auth.currentUser!.uid).then((value) {
                  _auth.signOut();
                  Navigator.of(context).pop();
                });
              },
              child: const Text("Yes"),
            )
          ],
        );
      }
    );
  }
}