import 'package:flutter/material.dart';
import 'package:groupfly_project/services/authorization_service.dart';
import 'package:provider/provider.dart';
import 'package:groupfly_project/models/group_fly_user.dart';

import 'controllers/app_controller.dart';
import 'controllers/login_controller.dart';

//Determines which Controller should be displayed. The rules are as follows:
//  1) If there is no user, or if the user is not verified, the LoginController displays
//  2) Otherwise, the AppController displays.
class ControllerSelector extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<GroupFlyUser?>(context);
    final userAsFirestoreUser = Authorization().currentUser;
    if(user == null || !userAsFirestoreUser!.emailVerified){
      return const LoginController();
    }
    else{
      return const AppController();
    }
  }
  
}