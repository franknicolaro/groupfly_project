import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../models/Group.dart';
import '../../models/Hobby.dart';
import '../../services/repository_service.dart';
import '../GroupWidgets/listed_group_container.dart';

class GroupExplorerWidget extends StatefulWidget{
  GroupExplorerWidget({super.key});
  @override
  State<GroupExplorerWidget> createState() => _GroupExplorerWidgetState();
}

class _GroupExplorerWidgetState extends State<GroupExplorerWidget>{
  List<Group> groups = [];
  List<Group> formerSearchResults = [];
  List<Group> groupsToRemove = [];
  String? hobbyFilter;
  String? locationFilter;
  DateTime? tempDate;
  String? selectedHobby;
  DateTime? meetingTimeFilter;
  late int maxCapacityFilter;
  final int DEFAULT_MAX_CAPACITY = -1;
  final String DEFAULT_HOBBY = '';
  final DateTime DEFAULT_DATE = DateTime.now();
  final String DEFAULT_LOCATION = '';
  var _groupExplorerController = TextEditingController();
  var _locationController = TextEditingController();
  var _maxCapacityController = TextEditingController();
  List<Hobby> selectableHobbies = [];

  @override
  void initState(){
    super.initState();
    maxCapacityFilter = DEFAULT_MAX_CAPACITY;
    meetingTimeFilter = DEFAULT_DATE;
    hobbyFilter = DEFAULT_HOBBY;
    locationFilter = DEFAULT_LOCATION;
    selectableHobbies = GetIt.instance<RepositoryService>().getAllHobbies();
  }
  @override
  Widget build(BuildContext context){
    return Center(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children:  
                  groups.map((group) =>
                    ListedGroupContainer(group: group)
                  ).toList(),
              ),
            )
          )
        ]
      ),
    );
  }
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
  bool dateMatches(DateTime selectedDate){
    
    bool result = false;
    if(meetingTimeFilter != null && meetingTimeFilter!.day == selectedDate.day && meetingTimeFilter!.month == selectedDate.month && meetingTimeFilter!.year == selectedDate.year){
      print("Applies to ${selectedDate.toString()}");
      result = true;
    }
    return result;
  }
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
  Widget displayFiltersWidget(){
    return Center(
      child: Container(
        color: Color.fromARGB(255, 17, 127, 171),
        child: Column(
          children: [
            Container(
              alignment: Alignment.topLeft,
              child: BackButton(
                onPressed:(){
                  Navigator.of(context).pop();
                }
              )
            ),
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
                ElevatedButton(
                  onPressed: () async { 
                    tempDate = await _showDatePicker();
                    setState(() {
                      
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
                Text("Selected Date: ${tempDate != null ? tempDate.toString() : "None."}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Mulish'
                  )
                ),
              ],
            ),
            Text(selectedHobby == null ? "Select a hobby to filter by (Shift + scroll if using a mouse)" : "Selected Hobby: ${selectedHobby}"),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: selectableHobbies.map((hobby) =>
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
            ElevatedButton(
              onPressed: () {
                setState(() {
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
                  groups.forEach((group) {
                    if(!doFiltersApply(group)){
                      setState(() {
                        groupsToRemove.add(group);
                      });
                    }
                  });
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