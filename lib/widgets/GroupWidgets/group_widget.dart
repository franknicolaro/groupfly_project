import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:groupfly_project/models/group_fly_user.dart';
import 'package:groupfly_project/services/repository_service.dart';

import '../../models/Group.dart';

class GroupWidget extends StatefulWidget{
  Group group;
  GroupWidget({required this.group});

  @override
  State<GroupWidget> createState() => _GroupWidgetState();
}

class _GroupWidgetState extends State<GroupWidget>{
  List<GroupFlyUser> members = [];
  GroupFlyUser? owner;

  /*TODO: Column:
    Obligatory back button (trademarked) (copyright)
    Title of the group
    Row(Owner username, Number of members, Button to showModalSideSheet())
      showModalSideSheet():
        List of Rows(ListedProfileContainer, Add Friend Button(save this for later))
    ChatContainer(worry about this after getting everything else done)
      message logs, textfield with button to send message.
    Join Group button if available spot is open, Leave Group if user is a part of group.
      RequestButton could be done later
      Same with InviteButton if user is owner. 
      Also same with DisbandGroupButton.

    Overall Execution:
      - get the group owner first by uid.
      - get other members by uid and add each into the list (ignore the owner's uid this time).
      - store group owner at index 0 so they appear at the top of the side sheet list.
      - update document in Firebase when a user joins or leaves the group. 

    Holy fucking shit this is a lot and idk if i have the time for this
    just don't panic frank
    it's okay  
  */ 
  @override
  void initState(){
    super.initState();
    initUsers();
  }
  void initUsers() async{
    await GetIt.instance<RepositoryService>().getGroupFlyUserByUID(widget.group.owner_uid).then((user) {
        setState(() {
          owner = user;
        });
      },);
    widget.group.member_uids.forEach((uid) async{ 
      await GetIt.instance<RepositoryService>().getGroupFlyUserByUID(uid).then((user) {
        setState(() {
          if(user.uid != owner!.uid){
            members.add(user);
          }
        });
      },);
    });
    setState(() {
      members.insert(0, owner!);
    });
  }
  @override
  Widget build(BuildContext context){
    return Column(
      children: [
        Container(
          alignment: Alignment.topLeft,
          child: BackButton(
            onPressed: (){
              Navigator.of(context).pop();
            },
          )
        ),
        Text(widget.group.title,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 48,
            fontWeight: FontWeight.w700,
            fontFamily: 'Mulish'
          )
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Group owner: ${owner!.username}",
              style: const TextStyle(
                color: Colors.black,
                fontSize: 12,
                fontWeight: FontWeight.w700,
                fontFamily: 'Mulish'
              )
            ),
            const SizedBox(width: 50),
            Text("Number of Members: ${members.length}/${widget.group.maxCapacity}",
              style: const TextStyle(
                color: Colors.black,
                fontSize: 12,
                fontWeight: FontWeight.w700,
                fontFamily: 'Mulish'
              )
            ),
            const SizedBox(width: 15),
            ElevatedButton(
              onPressed: () {
                /*showModalSideSheet(

                );*/
                //showModalSideSheet
              }, 
              child: const Text("Show Members",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Mulish'
                )
              )
            )
          ],
        )
      ]
    );
  }
}