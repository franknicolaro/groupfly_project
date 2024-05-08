import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:groupfly_project/models/group_fly_user.dart';
import 'package:groupfly_project/services/authorization_service.dart';
import 'package:groupfly_project/services/validation_service.dart';
import 'package:groupfly_project/widgets/GroupWidgets/listed_group_container.dart';

import '../../models/Group.dart';
import '../../models/Hobby.dart';
import '../../services/repository_service.dart';

//Displays the groups of the user and allows 
//for the user to create groups.
class MyGroupsWidget extends StatefulWidget{
  //List of friends and removeFriend function from AppController
  List<GroupFlyUser> friends;
  Function removeFriend;
  MyGroupsWidget({super.key, required this.friends, required this.removeFriend});

  @override
  State<MyGroupsWidget> createState() => _MyGroupsWidgetState();
}

class _MyGroupsWidgetState extends State<MyGroupsWidget>{
  //Authorization service to get the groups of the owner.
  final Authorization _auth = Authorization();

  //Validation service for group creation.
  final ValidationService _validation = ValidationService();
  List<Group> groups = [];                //Groups that the user is a member of.
  final _formKey = GlobalKey<FormState>();//Key for the group creation form.
  List<Hobby> selectableHobbies = [];     //List of Hobbies that are selectable for the group creation form.

  //Other variables for the group creation form.
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

  //Initializes the groups based on the current user's UID.
  void initGroups(){
    GetIt.instance<RepositoryService>().getGroupsByMemberUID(_auth.currentUser!.uid).then((userGroups) {
      setState(() {
        groups = userGroups;
      });
    });
  }

  //Builds the MyGroupsWidget
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          //Title for MyGroupsWidget.
          Text("My Groups",
            style: TextStyle(
              color: Colors.black,
              fontSize: 24,
              fontWeight: FontWeight.w800,
              fontFamily: 'Mulish'
            ),
          ),
          //List of ListedGroupContainers.
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
          //Button to create a group. Upon 
          //clicking, the group creation form is displayed.
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

  //Displays a DatePicker, which is a more clean way to retrieve the date.
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

  //Returns the group creation form. 
  Widget displayGroupCreation(){
    return Container(
      color: Color.fromARGB(255, 10, 70, 94),
      child: Column(
        children: [
          //Back button to remove the group creation form from display.
          Container(
            alignment: Alignment.topLeft,
            child: BackButton(
              onPressed: (){
                Navigator.of(context).pop();
              },
            )
          ),
          //Form for group creation
          Form(
            key: _formKey,
            child: Column(
              children: [
                //Title field with label
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
                //Hobby field with a selection scroll view.
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
                          //Take the button clicked and set hobbyName to the selected hobby.
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
                //Location label with TextField
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
                //Date and Time label
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
                    //Button to choose the Date and time.
                    ElevatedButton(
                      onPressed: () async { 
                        meetingTimeToDisplay = await _showDatePicker();
                        //After displaying the date picker and selecting a time, set the meeting time to the display.
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
                    //Label to display the selected date.
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
                //Maximum Capacity label with its respective TextField.
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
                //Other notes label with its respective TextField
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
                //Button to create the group.
                ElevatedButton(
                  onPressed: () async {
                    _formKey.currentState!.save();
                    //If the group is validated, create a
                    //Group object and insert the Group into Firestore.
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
                      //Reset all variables and remove the creation form from the display
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