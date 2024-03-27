import 'package:flutter/material.dart';
import 'package:groupfly_project/widgets/ProfileWidgets/general_profile_widget.dart';

import '../../../models/group_fly_user.dart';

class ProfileSearchResultContainer extends StatefulWidget{
  GroupFlyUser profile;
  ProfileSearchResultContainer({required this.profile});
  @override
  State<ProfileSearchResultContainer> createState() => _ProfileSearchResultContainerState();
}
class _ProfileSearchResultContainerState extends State<ProfileSearchResultContainer>{
  //TODO: make little card that would display a bottom sheet with the user profile
  @override
  Widget build(BuildContext context){
    return OutlinedButton(
      onPressed: (){
        showModalBottomSheet(
          context: context, 
          builder: ((builder) => displayUserProfile())
        );
      },
      //TODO: add some type of action to this to display the bottom sheet.
      child: Container(
        height: MediaQuery.of(context).size.height * 0.12,
        width: MediaQuery.of(context).size.width * 0.25,
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 17, 127, 171),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Row(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              child: CircleAvatar(
                radius: 24,
                backgroundColor: Colors.black45,
                child: CircleAvatar(
                  radius: 22,
                  backgroundImage: NetworkImage((widget.profile.photoURL == null ||widget.profile.photoURL! == "") ? "https://images.vexels.com/media/users/3/180861/isolated/preview/f68f0a8f6f1901015166ae2f9d8a39f8-cute-ladybug-flying-outline.png" : widget.profile.photoURL!),
                )
              )
            ),
            Container(
              child: Text(
                widget.profile.username,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Mulish'
                )
              )
            )
          ],
        )
      )
    );
  }
  Widget displayUserProfile(){
    return Container(
      color: Color.fromARGB(255, 17, 127, 171),
      child:GeneralProfileWidget(user: widget.profile)
    );
  }
}