import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:groupfly_project/models/GroupFlyNotification.dart';
import 'package:groupfly_project/models/group_fly_user.dart';
import 'package:groupfly_project/services/authorization_service.dart';
import 'package:groupfly_project/services/repository_service.dart';
import 'package:groupfly_project/widgets/ProfileWidgets/listed_profile_container.dart';

import '../../models/Group.dart';

//A Widget that displays Group information
class GroupWidget extends StatefulWidget{
  Group group;                  //The group which has information to display
  final Function notifyWidget;  //A function to notify the widget that this GroupWidget comes from.
  List<GroupFlyUser> friends;   //List of the current user's friends.
  Function removeFriend;        //removeFriend function from AppController.
  GroupWidget({required this.group, required this.notifyWidget, required this.friends, required this.removeFriend});

  @override
  State<GroupWidget> createState() => _GroupWidgetState();
}

class _GroupWidgetState extends State<GroupWidget>{
  //Authorization service, to confirm if the user is the owner of the group
  Authorization _auth = Authorization();

  //Members of the Group, incluign the group owner.
  List<GroupFlyUser> members = [];

  //Owner of the group.
  GroupFlyUser? owner;

  @override
  void initState(){
    super.initState();
    initUsers();
  }

  //Initializes the owner and members of the group to display.
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

  //Looks for the member in the group by the member's UID.
  //Returns a nullable GroupFlyUser, regardless of if the user exists in the
  //group or not.
  GroupFlyUser? findMemberWithUID(String uid){
    GroupFlyUser? result;
    members.forEach((member) {
      if(member.uid == uid){
        result = member;
      }
    });
    return result;
  }

  //Updates the UI by calling setState((){})
  void refresh(){
    setState(() {
      
    });
  }

  //Builds the GroupWidget
  @override
  Widget build(BuildContext context){
    return Container(
      color: Color.fromARGB(255, 17, 127, 171),
      child: Column(
        children: [
          //BackButton to remove the widget and display what was originially displayed.
          Container(
            alignment: Alignment.topLeft,
            child: BackButton(
              onPressed: (){
                Navigator.of(context).pop();
              },
            )
          ),
          //Text display the title of the group.
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
              //Group Owner Label
              Text("Group owner: ${owner!.username}",
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Mulish'
                )
              ),
              const SizedBox(width: 50),
              //Number of members label.
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
          //The list of members, both with the label and the memberList()
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
          //If the current user is not the owner, then display a request to join group button.
          _auth.currentUser!.uid != owner!.uid ? 
          Visibility(
            visible: findMemberWithUID(_auth.currentUser!.uid) == null,
            child: ElevatedButton(
              //Creates a Group Request notification and stores it into firebase.
              onPressed: (){
                DocumentReference refToGroup = FirebaseFirestore.instance.doc("group/${widget.group.group_id}");
                GroupFlyNotification notificationToInsert = GroupFlyNotification(requesteeUid: owner!.uid!, requesterUid: _auth.currentUser!.uid, groupRef: refToGroup, type: 'group_request', docId: "");
                GetIt.instance<RepositoryService>().sendGroupRequestNotification(notificationToInsert);
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
          //Button to invite friends to the group, but only if the user is the group owner
          ElevatedButton(
            onPressed: (){
              //Displays a widget that allows for the inviting of friends to the group.
              showModalBottomSheet(
                isScrollControlled: true,
                context: context,
                builder: ((builder) => inviteFriendsPopUp())
              ); 
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
          //Leave Group button, only if the user isn't the owner of the Group.
          Visibility(
            visible: findMemberWithUID(_auth.currentUser!.uid) != null,
            child: ElevatedButton(
              onPressed: (){
                //Remove the member from both the group in the Firestore document
                //and from the group in Flutter. Then, removes the GroupWidget from the display.
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
          //Disband Group button, only if the user is the owner of the Group.
          ElevatedButton(
            onPressed: (){
              //Disband the group, which sets the group's active bool to false.
              //Then, removes the GroupWidget from the display.
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

  //Displays the list of members within a Container.
  Widget memberList(){
    return Container(
      color: Color.fromARGB(255, 10, 70, 94),
      //A scroll view that contains information about each member.
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: members.map((profile) =>
            Row(
              children: [
                //A profile container for the member that it pertains to (see listed_profile_container.dart)
                ListedProfileContainer(profile: profile, isFromOtherPage: true, removeFriend: widget.removeFriend,),
                SizedBox(width: 5),
                (_auth.currentUser!.uid != profile.uid && _auth.currentUser!.uid == owner!.uid) ?
                //Remove Button, but only if the user is the owner and the
                //user isn't "profile" when being mapped.
                ElevatedButton(
                  onPressed: (){
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
                ) : Container()//Display a Container if the member in question is the user who is the group owner.
              ],
            )
          ).toList(),
        ),
      ),
    );
  }

  //Displays a Widget that allows the group owner to invite friends.
  Widget inviteFriendsPopUp(){
    return Container(
      color:Color.fromARGB(255, 10, 70, 94),
      child: Column(
        children: [
          //BackButton which removes the GroupWidget from the display.
          Container(
            alignment: Alignment.topLeft,
            child: BackButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          //Invite Friends Label
          Text("Invite Friends",
            style: TextStyle(
              fontFamily: "Mulish",
              fontSize: 48,
              fontWeight: FontWeight.w900,
              color: Colors.black
            )
          ),
          //Scroll View which displays friends of the group owner.
          SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              //Maps each friend to a Row of widgets.
              children: widget.friends.map((friend) =>
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //A profile container for the member that it pertains to (see listed_profile_container.dart)
                    ListedProfileContainer(profile: friend, isFromOtherPage: true, removeFriend: widget.removeFriend,),
                    //Invite button which stores a group invite notification into Firestore.
                    ElevatedButton(
                      onPressed: (){
                        DocumentReference groupRef = FirebaseFirestore.instance.doc("group/${widget.group.group_id}");
                        GroupFlyNotification notification = GroupFlyNotification(docId: '', requesterUid: _auth.currentUser!.uid, requesteeUid: friend.uid!, type: "group_invite", groupRef: groupRef);
                        GetIt.instance<RepositoryService>().sendGroupInviteNotification(notification);
                      }, 
                      child: const Text("Invite",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Mulish'
                        )
                      )
                    )
                  ]
                )
              ,).toList(),
            ),
          ),
        ],
      ),
    );
  }
}