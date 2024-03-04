import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:groupfly_project/services/authorization_service.dart';
import 'package:provider/provider.dart';
import 'package:groupfly_project/models/group_fly_user.dart';

import 'controllers/app_controller.dart';
import 'controllers/login_controller.dart';

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