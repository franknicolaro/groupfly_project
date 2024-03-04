
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:groupfly_project/models/Group.dart';
import 'package:groupfly_project/services/authorization_service.dart';
import 'package:groupfly_project/services/repository_service.dart';

class NumberOfGroupsLabel extends StatefulWidget{
  @override
  State<NumberOfGroupsLabel> createState() => _NumberOfGroupsLabelState();
}

class _NumberOfGroupsLabelState extends State<NumberOfGroupsLabel>{
  Authorization _auth = Authorization();
  var groups;

  @override
  void initState(){
    super.initState();
    initGroups();
  }

  void initGroups(){
    groups = GetIt.instance<RepositoryService>().getGroupsByMemberUID(_auth.currentUser!.uid);
    print('groups returned.');
  }

  @override
  Widget build(BuildContext context){
    print(groups.toString());
    return FutureBuilder(
      future: groups,
      builder:(context, snapshot){
        if(snapshot.connectionState == ConnectionState.done){
          if(snapshot.hasError){
            return Center(
              child: Text(
                '${snapshot.error} occurred',
              )
            );
          }
          else if(snapshot.hasData){
            List<Group> groupList = snapshot.data as List<Group>;
            print(groupList);
            return Text(
              'Number of Groups participated in: ${groupList.length}',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w600,
                fontFamily: 'Mulish',
              )
            );
          }
        }
        return const Center(
          child: CircularProgressIndicator()
        );
      }
    );
  }
}