import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:groupfly_project/widgets/ProfileWidgets/user_profile_web.dart';

class ProfileScreen extends StatefulWidget{

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>{
  @override
  Widget build(BuildContext context) {
    if(kIsWeb){
      return UserProfileWidgetWeb();
    }
    else{ 
      return Text("TODO: Implement Mobile Version");
    }
    // TODO: implement widgets for mobile and web ^^^^. 
  }
}
