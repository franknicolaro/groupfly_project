import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:groupfly_project/models/group_fly_user.dart';
import 'package:groupfly_project/services/authorization_service.dart';
import 'package:groupfly_project/services/validation_service.dart';
import 'package:groupfly_project/widgets/GroupWidgets/listed_group_container.dart';

import '../../models/Group.dart';
import '../../models/Hobby.dart';
import '../../services/repository_service.dart';

class MyGroupsWidget extends StatefulWidget{
  //TODO: REFACTOR: Pass groups through here
  List<GroupFlyUser> friends;
  Function removeFriend;
  MyGroupsWidget({super.key, required this.friends, required this.removeFriend});

  @override
  State<MyGroupsWidget> createState() => _MyGroupsWidgetState();
}

class _MyGroupsWidgetState extends State<MyGroupsWidget>{
  final Authorization _auth = Authorization();
  final ValidationService _validation = ValidationService();
  List<Group> groups = [];
  final _formKey = GlobalKey<FormState>();
  List<Hobby> selectableHobbies = [];

  /*Needs:
    Title
    Hobby
    Location
    Date
    Max Capacity
    Other Notes
  */
  String title = '';
  String? hobbyName;
  String location = '';
  DateTime? meetingTime;
  DateTime? meetingTimeToDisplay;
  int maxCapacity = 0;
  String otherNotes = '';
  
  @override
  void initState(){
    super.initState();
    initGroups();
    selectableHobbies = GetIt.instance<RepositoryService>().getAllHobbies();
  }

  void initGroups(){
    GetIt.instance<RepositoryService>().getGroupsByMemberUID(_auth.currentUser!.uid).then((userGroups) {
      setState(() {
        groups = userGroups;
      });
    });
  }
  /*Column:
      Label saying "My Groups"
      Container()
        SingleChildScroll of all groups user is a part of
      Create Group Button
        opens bottom modal sheel to create group
          provide a form maybe for all of the details 
          of the group instead of separate input fields.
          might make it look cleaner.
  */
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text("My Groups",
            style: TextStyle(
              color: Colors.black,
              fontSize: 24,
              fontWeight: FontWeight.w800,
              fontFamily: 'Mulish'
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.5,
            height: MediaQuery.of(context).size.height * 0.4,
            child: SingleChildScrollView(
              child: Column(
                children: groups.map((group) =>
                  group.isActive ? ListedGroupContainer(group: group, friends: widget.friends, removeFriend: widget.removeFriend,) : Container()
                ).toList()
              )
            )
          ),
          ElevatedButton(
            onPressed: (){
              showModalBottomSheet(
                isScrollControlled: true,
                context: context,
                builder: ((builder) => displayGroupCreation())
              );
            }, 
            child: Text("Create a Group",
              style: TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.w800,
                fontFamily: 'Mulish'
              ),
            )
          )
        ],
      ),
    );
  }

  Future<DateTime> _showDatePicker()async {
    DateTime selectedDate = DateTime.now();
    await showDatePicker(
      context: context, 
      initialDate: DateTime.now(), 
      firstDate: DateTime.now(), 
      lastDate: DateTime(DateTime.now().year + 2),
    ).then((date) async {
      if(date != null){
        await showTimePicker(
          context: context,
          initialTime: TimeOfDay.fromDateTime(date)
        ).then((time) {
          if(time != null){
            selectedDate = DateTime(
              date.year,
              date.month,
              date.day,
              time.hour,
              time.minute,
            );
          }
        });
      }
    });
    return selectedDate;
  }

  /*Needs:
    Title
    Hobby
    Location
    Date
    Max Capacity
    Other Notes
  */
  Widget displayGroupCreation(){
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
          Form(
            key: _formKey,
            child: Column(
              children: [
                const Text("Title", 
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Mulish',
                  )
                ),
                TextFormField(
                  validator: (value) => value!.isEmpty ? 'Enter a title' : null,
                  onChanged: (value){
                    setState(() {
                      title = value;
                    });
                  }
                ),
                Text(hobbyName == null ? "Hobby (Shift + scroll if using a mouse)" : "Selected Hobby: ${hobbyName}", 
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Mulish',
                  )
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: selectableHobbies.map((hobby) =>
                      OutlinedButton(
                        onPressed: (){
                          setState(() {
                            hobbyName = hobby.hobbyName;
                          });
                        },
                        child: Container(
                          color: Color.fromARGB(255, 10, 70, 94),
                          height: MediaQuery.of(context).size.height * 0.15,
                          width: MediaQuery.of(context).size.width * 0.17,
                          child: Text(hobby.hobbyName,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Mulish'
                            )
                          )
                        )
                      )
                    ).toList()
                  )
                ),
                const Text("Location (Address or Landmark Title)", 
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Mulish',
                  )
                ),
                TextFormField(
                  validator: (value) => value!.isEmpty ? 'Enter a location' : null,
                  onChanged: (value){
                    setState(() {
                      location = value;
                    });
                  }
                ),
                const Text("Date and Time", 
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Mulish',
                  )
                ),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () async { 
                        meetingTimeToDisplay = await _showDatePicker();
                        setState(() {
                          meetingTime = meetingTimeToDisplay;
                        });
                      },
                      child: const Text(
                        "Choose Date",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Mulish'
                        )
                      ),
                    ),
                    SizedBox(width: 15,),
                    Text("SelectedDate: ${meetingTimeToDisplay != null ? meetingTimeToDisplay.toString() : "None"}",
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Mulish'
                      )
                    )
                  ],
                ),
                const Text("Maximum Capacity", 
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Mulish',
                  )
                ),
                TextFormField(
                  validator: (value) => !_validation.validMaxCapacity(value!) ? 'Enter a number greater than 1' : null,
                  onChanged: (value){
                    setState(() {
                      maxCapacity = int.parse(value);
                    });
                  }
                ),
                const Text("Other Notes", 
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Mulish',
                  )
                ),
                TextFormField(
                  validator: (value) => value!.isEmpty ? 'Enter some type of notes' : null,
                  onChanged: (value){
                    otherNotes = value;
                  }
                ),
                ElevatedButton(
                  onPressed: () async {
                    _formKey.currentState!.save();
                    if(_formKey.currentState!.validate() && hobbyName != null && meetingTime != null){
                      Group groupToInsert = Group(
                        group_id: '', 
                        hobbyName: hobbyName!, 
                        isActive: true, 
                        location: location, 
                        maxCapacity: maxCapacity, 
                        meeting_time: meetingTime!, 
                        member_uids: [(_auth.currentUser!.uid)], 
                        notes: otherNotes, 
                        owner_uid: _auth.currentUser!.uid, 
                        title: title
                      );
                      GetIt.instance<RepositoryService>().createGroup(groupToInsert).then((_) {
                        setState(() {
                          groups.add(groupToInsert);
                        });
                      });
                      setState(() {
                        hobbyName = null;
                        location = '';
                        maxCapacity = 0;
                        meetingTime = null;
                        meetingTimeToDisplay = null;
                        otherNotes = '';
                        title = '';
                      });
                      Navigator.of(context).pop();
                    }
                  }, 
                  child: const Text("Complete Group Creation", 
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Mulish',
                    )
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}