import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:groupfly_project/models/group_fly_user.dart';
import 'package:groupfly_project/widgets/ExplorerWidgets/SearchResultWidgets/profile_search_result_container.dart';

import '../../services/repository_service.dart';

class ProfileExplorerWidget extends StatefulWidget{
  ProfileExplorerWidget({super.key});
  @override
  State<ProfileExplorerWidget> createState() => _ProfileExplorerWidgetState();
}

class _ProfileExplorerWidgetState extends State<ProfileExplorerWidget>{
  List<GroupFlyUser> profiles = [];
  var _profileExplorerController = TextEditingController();
  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 10, 70, 94),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 61, 111, 67),
        title: Text('Profile Explorer'),
        actions:[
          TextButton.icon(
            onPressed:(){
              //Display notifications widget
            },
            icon: const Icon(Icons.add_alert_sharp),
            label: const Text("Notifications")
          )
        ]
      ),
      body: Center(
        child: Column(
          children: [
            TextField(
              controller: _profileExplorerController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Search for Profiles",
                suffixIcon: IconButton(
                  icon: Icon(Icons.search_rounded),
                  onPressed: (){
                    if(_profileExplorerController.text.isNotEmpty){
                      GetIt.instance<RepositoryService>().searchProfileByName(_profileExplorerController.text).then((value) {
                        setState(() {
                          profiles = value;
                          _profileExplorerController.clear();
                        });
                      });
                    }
                  },
                )
              )
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children:
                    profiles.map((profile) =>
                      ProfileSearchResultContainer(profile: profile)
                    ).toList(),
                )
              ),
            )
                /*ElevatedButton(
                  onPressed: (){
                    showModalBottomSheet(
                      context: context,
                      builder: ((builder) => filtersPopUp())
                    );
                  }, 
                  child: const Text('Filters',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Mulish'
                    )
                  )
                )*/
          ]
        )
      )
    );
  }
  /*TODO: SAVE THIS FOR GROUP EXPLORER
  Widget filtersPopUp(){
    return Container(
      color: Color.fromARGB(255, 17, 127, 171),
      height: MediaQuery.of(context).size.height * 0.35,
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [

        ]
      )
    );
  }*/
}