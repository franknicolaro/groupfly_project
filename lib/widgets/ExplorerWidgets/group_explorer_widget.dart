import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:groupfly_project/models/group_fly_user.dart';

import '../../models/Group.dart';
import '../../models/Hobby.dart';
import '../../services/repository_service.dart';
import '../GroupWidgets/listed_group_container.dart';

//A widget that displays the search bar and filters for 
//Finding a group.
class GroupExplorerWidget extends StatefulWidget{
  List<GroupFlyUser> friendList;  //Current user's friendList.
  Function removeFriend;          //Function from AppController.
  GroupExplorerWidget({super.key, required this.friendList, required this.removeFriend});
  @override
  State<GroupExplorerWidget> createState() => _GroupExplorerWidgetState();
}

class _GroupExplorerWidgetState extends State<GroupExplorerWidget>{
  //Searched goups, groups to be removed based on filters,
  //and the former search results before the filters were applied.
  List<Group> groups = [];
  List<Group> formerSearchResults = [];
  List<Group> groupsToRemove = [];

  //Filter variables to be applied to searched groups.
  String? hobbyFilter;
  String? locationFilter;
  DateTime? meetingTimeFilter;
  late int maxCapacityFilter;

  //Temporary variables to keep track of labels.
  DateTime? tempDate;
  DateTime? tempDateToDisplay;
  String? selectedHobby;

  //Constants for default variables.
  final int DEFAULT_MAX_CAPACITY = -1;
  final String DEFAULT_HOBBY = '';
  final DateTime DEFAULT_DATE = DateTime.now();
  final String DEFAULT_LOCATION = '';

  //Text controllers
  var _groupExplorerController = TextEditingController();
  var _locationController = TextEditingController();
  var _maxCapacityController = TextEditingController();

  //Selectable Hobbies.
  List<Hobby> selectableHobbies = [];

  //Initializes the filters and selectable hobbies.
  @override
  void initState(){
    super.initState();
    maxCapacityFilter = DEFAULT_MAX_CAPACITY;
    meetingTimeFilter = DEFAULT_DATE;
    hobbyFilter = DEFAULT_HOBBY;
    locationFilter = DEFAULT_LOCATION;
    selectableHobbies = GetIt.instance<RepositoryService>().getAllHobbies();
  }

  //Calls to removeFriend from AppController.
  void removeFriend(String uid){
    widget.removeFriend(uid);
  }

  //Returns a search bar for Groups, and a resultant list of groups in a scroll view.
  @override
  Widget build(BuildContext context){
    return Center(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //Search bar for Groups
              Container(
                width: MediaQuery.of(context).size.width * 0.45,
                child: TextField(
                  controller: _groupExplorerController, 
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Search for Groups",
                    suffixIcon: IconButton(
                      icon: Icon(Icons.search_rounded),
                      onPressed: (){
                        //Checks if the groupExplorerController is not empty.
                        //If it is not empty, search for groups that are equivalent to what was entered.
                        //For each group that is returned, add that to the groups that
                        //are displayed (implemented below). After this, add all groups
                        //to the former search results before applying filters and clear the controller.
                        if(_groupExplorerController.text.isNotEmpty){
                          GetIt.instance<RepositoryService>().searchGroupsByName(_groupExplorerController.text).then((value) {
                            setState(() {
                              value.forEach((group) {
                                groups.add(group);
                              });
                              formerSearchResults.addAll(groups);
                              _groupExplorerController.clear();
                            });
                          });
                        }
                      },
                    )
                  )
                ),
              ),
              SizedBox(width: 10),
              //Filters button that displays a Filters Widget
              ElevatedButton(
                onPressed:() {
                  showModalBottomSheet(
                    isScrollControlled: true,
                    context: context, 
                    builder: ((builder) => displayFiltersWidget())
                  );
                }, 
                child: const Text('Filters',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Mulish' 
                  )
                )
              ),
              SizedBox(width: 10),
              //Button to clear the filters that were applied, and resets the groups
              //variable to normal if necessary.
              ElevatedButton(
                onPressed:() {
                  setState(() {
                    maxCapacityFilter = DEFAULT_MAX_CAPACITY;
                    meetingTimeFilter = DEFAULT_DATE;
                    hobbyFilter = DEFAULT_HOBBY;
                    locationFilter = DEFAULT_LOCATION;
                    groups.addAll(groupsToRemove);
                    groupsToRemove = [];
                  });
                }, 
                child: const Text('Clear Filters',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Mulish' 
                  )
                )
              )
            ],
          ),
          //The resulting groups from performing the search.
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children:  
                  groups.map((group) =>
                    group.isActive ? ListedGroupContainer(group: group, friends: widget.friendList, removeFriend: removeFriend,) : Container()
                  ).toList(),
              ),
            )
          )
        ]
      ),
    );
  }
  //Checks for each group if the filters apply to that group.
  //if any filter does not apply, return false. Otherwise, return true.
  bool doFiltersApply(Group group){
    bool result = true;
    if(hobbyFilter != DEFAULT_HOBBY && hobbyFilter != group.hobbyName){
      result = false;
    }
    if(locationFilter != DEFAULT_LOCATION && locationFilter != group.location){
      result = false;
    }
    if(meetingTimeFilter != DEFAULT_DATE && !dateMatches(group.meeting_time)){
      result = false;
    }
    if(maxCapacityFilter != DEFAULT_MAX_CAPACITY && maxCapacityFilter != group.maxCapacity){
      result = false;
    }
    return result;
  }

  //Checks if the date matches by day, month, and year. Returns false if any
  //of these do not match, and true if they all match.
  bool dateMatches(DateTime selectedDate){
    bool result = false;
    if(meetingTimeFilter != null && meetingTimeFilter!.day == selectedDate.day && meetingTimeFilter!.month == selectedDate.month && meetingTimeFilter!.year == selectedDate.year){
      result = true;
    }
    return result;
  }

  //Displays the "DatePicker", a much simpler way to select the date.
  Future<DateTime> _showDatePicker()async {
    DateTime selectedDate = DateTime.now();
    await showDatePicker(
      context: context, 
      initialDate: DateTime.now(), 
      firstDate: DateTime.now(), 
      lastDate: DateTime(DateTime.now().year + 2),
    ).then((date){
      selectedDate = date!;
    });
    return selectedDate;
  }

  //A function which returns the filters widget.
  Widget displayFiltersWidget(){
    return Center(
      child: Container(
        color: Color.fromARGB(255, 17, 127, 171),
        child: Column(
          children: [
            //BackButton to ensure that the filters widget
            //can be removed and the GroupExplorerWidget can
            //be displayed.
            Container(
              alignment: Alignment.topLeft,
              child: BackButton(
                onPressed:(){
                  Navigator.of(context).pop();
                }
              )
            ),
            //Address TextField
            TextField(
              controller: _locationController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Address",
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: (){
                    _locationController.clear();
                  }
                )
              ),
            ),
            Row(
              children: [
                //Button to select the date.
                ElevatedButton(
                  onPressed: () async { 
                    tempDate = await _showDatePicker();
                    setState(() {
                      tempDateToDisplay = tempDate;
                    });
                  },
                  child: const Text(
                    "Choose Date",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Mulish'
                    )
                  ),
                ),
                SizedBox(width: 15),
                //Text which displays the selected date.
                Text("Selected Date: ${tempDateToDisplay != null ? tempDateToDisplay.toString() : "None."}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Mulish'
                  )
                ),
              ],
            ),
            //Text to display the selected hobby.
            Text(selectedHobby == null ? "Select a hobby to filter by (Shift + scroll if using a mouse)" : "Selected Hobby: ${selectedHobby}"),
            //A scroll view of the selectable hobbies.
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: selectableHobbies.map((hobby) =>
                  //Clicking on the OutlinedButton of a hobby
                  //sets the selectedHobby to that hobby name.
                  OutlinedButton(
                    onPressed: (){
                      setState(() {
                        selectedHobby = hobby.hobbyName;
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
            //TextField for maximum capacity of the group.
            TextField(
              keyboardType: TextInputType.number,
              controller: _maxCapacityController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Capacity",
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: (){
                    _maxCapacityController.clear();
                  }
                )
              ),
            ),
            //Button for Applying filters.
            ElevatedButton(
              onPressed: () {
                setState(() {
                  //first check if anything isn't null or empty.
                  if(_maxCapacityController.text.isNotEmpty){
                    maxCapacityFilter = int.parse(_maxCapacityController.text);
                  }
                  if(_locationController.text.isNotEmpty){
                    locationFilter = _locationController.text;
                  }
                  if(tempDate != null){
                    meetingTimeFilter = tempDate;
                  }
                  if(selectedHobby != null){
                    hobbyFilter = selectedHobby;
                  }

                  //Check if all filters apply to each group in the searched groups,
                  //and add that group to the groupsToRemove if the filters do not apply.
                  groups.forEach((group) {
                    if(!doFiltersApply(group)){
                      setState(() {
                        groupsToRemove.add(group);
                      });
                    }
                  });
                  //Remove groups where the groupsToRemoveList contains the given group,
                  //then clear both controllers for the next time filters are applied.
                  groups.removeWhere((group) => groupsToRemove.contains(group));
                  _locationController.clear();
                  _maxCapacityController.clear();
                });
                Navigator.of(context).pop();
              },
              child: Text("Apply Filters",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Mulish'
                )
              ),
            )
          ]
        ),
      )
    );
  }
  
}