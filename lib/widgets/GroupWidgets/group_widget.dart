import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:groupfly_project/models/group_fly_user.dart';
import 'package:groupfly_project/services/authorization_service.dart';
import 'package:groupfly_project/services/repository_service.dart';
import 'package:groupfly_project/widgets/ProfileWidgets/listed_profile_container.dart';

import '../../models/Group.dart';

class GroupWidget extends StatefulWidget{
  Group group;
  final Function notifyWidget;
  GroupWidget({required this.group, required this.notifyWidget});

  @override
  State<GroupWidget> createState() => _GroupWidgetState();
}

class _GroupWidgetState extends State<GroupWidget>{
  Authorization _auth = Authorization();
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
  GroupFlyUser? findMemberWithUID(String uid){
    GroupFlyUser? result;
    members.forEach((member) {
      if(member.uid == uid){
        result = member;
      }
    });
    return result;
  }
  @override
  Widget build(BuildContext context){
    return Container(
      color: Color.fromARGB(255, 17, 127, 171),
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
            ],
          ),
          const Text("Members:",
            style: TextStyle(
              color: Colors.black,
              fontSize: 24,
              fontWeight: FontWeight.w700,
              fontFamily: 'Mulish'
            )
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.45,
            height: MediaQuery.of(context).size.height * 0.33,
            color: Color.fromARGB(255, 10, 70, 94),
            child: memberList(),
          ),
          _auth.currentUser!.uid != owner!.uid ? 
          Visibility(
            visible: findMemberWithUID(_auth.currentUser!.uid) == null,
            child: ElevatedButton(
              onPressed: (){
                //Send join request notification to owner of group
              }, 
              child: const Text("Request to join group",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Mulish'
                )
              ),
            ),
          ) : 
          ElevatedButton(
            onPressed: (){
              //Invite friends to group
            }, 
            child: const Text("Invite friends to Group",
              style: TextStyle(
                color: Colors.black,
                fontSize: 12,
                fontWeight: FontWeight.w700,
                fontFamily: 'Mulish'
              )
            )
          ),
          _auth.currentUser!.uid != owner!.uid ? 
          Visibility(
            visible: findMemberWithUID(_auth.currentUser!.uid) != null,
            child: ElevatedButton(
              onPressed: (){
                //TODO: add confirmation dialog
                GetIt.instance<RepositoryService>().removeMember(_auth.currentUser!.uid, widget.group.group_id).then((_) {
                  setState(() {
                    members.removeWhere((member) =>
                      member.uid == _auth.currentUser!.uid
                    );
                    widget.group.member_uids.remove(_auth.currentUser!.uid);
                    widget.notifyWidget();
                  });
                });
                Navigator.of(context).pop();
              }, 
              child: const Text("Leave Group",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Mulish'
                )
              ),
            ),
          ) : 
          ElevatedButton(
            onPressed: (){
              //TODO: add confirmation dialog
              GetIt.instance<RepositoryService>().disbandGroup(widget.group.group_id).then((_) {
                setState(() {
                  widget.group.isActive = false;
                });
                widget.notifyWidget();
                Navigator.of(context).pop();
              });
            }, 
            child: const Text("Disband Group",
              style: TextStyle(
                color: Colors.black,
                fontSize: 12,
                fontWeight: FontWeight.w700,
                fontFamily: 'Mulish'
              )
            )
          ),
        ]
      ),
    );
  }
  Widget memberList(){
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: members.map((profile) =>
          Row(
            children: [
              ListedProfileContainer(profile: profile, isFromGroupPage: true,),
              SizedBox(width: 5),
              (_auth.currentUser!.uid != profile.uid && _auth.currentUser!.uid == owner!.uid) ?
              ElevatedButton(
                onPressed: (){
                  //TODO: add confirmation dialog
                  GetIt.instance<RepositoryService>().removeMember(profile.uid!, widget.group.group_id).then((_) {
                  setState(() {
                    members.removeWhere((member) =>
                      member.uid == profile.uid!
                    );
                    widget.group.member_uids.remove(profile.uid!);
                  });
                  widget.notifyWidget();
                });
                }, 
                child: const Text("Remove",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Mulish'
                  )
                )
              ) : Container()
            ],
          )
        ).toList(),
      ),
    );
  }
}