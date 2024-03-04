import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:groupfly_project/services/repository_service.dart';

import '../../models/Hobby.dart';
import '../../services/authorization_service.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class RegisterWidgetWeb extends StatefulWidget{
  final Function switchView;
  final Function setHobbies;
  RegisterWidgetWeb({super.key, required this.switchView, required this.setHobbies});

  @override
  _RegisterWidgetWebState createState() => _RegisterWidgetWebState();
}

class _RegisterWidgetWebState extends State<RegisterWidgetWeb>{
  final Authorization _auth = Authorization();
  final _formKey = GlobalKey<FormState>();

  String email = '';
  String password = '';
  String error = '';
  String address = '';
  String username = '';
  DateTime? dateOfBirth;
  static final List<Hobby> _selectableHobbies = [
    Hobby(hobbyName: "Singing"),
    Hobby(hobbyName: "Dancing"),
    Hobby(hobbyName: "Football"),
    Hobby(hobbyName: "Soccer"),
    Hobby(hobbyName: "Baseball"),
    Hobby(hobbyName: "Basketball"),
    Hobby(hobbyName: "Bowling"),
    Hobby(hobbyName: "Hiking"),
    Hobby(hobbyName: "Frisbee"),
    Hobby(hobbyName: "Swimming"),
    Hobby(hobbyName: "Walking"),
    Hobby(hobbyName: "Exercising"),
    Hobby(hobbyName: "Cooking"),
    Hobby(hobbyName: "Painting"),
  ];

  final _items = _selectableHobbies.map((hobby) => MultiSelectItem<Hobby>(hobby, hobby.hobbyName))
  .toList();
  List<Hobby> _selectedHobbies = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 10, 70, 94),
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text('Register for Groupfly'),
        actions: [
          TextButton.icon(
            onPressed: (){
              widget.switchView("login");
            }, 
            icon: const Icon(Icons.person, color: Colors.black), 
            label: const Text('Return to Login',
            style: TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Mulish',
              )
            )
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 35.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 20.0),
              const Text('Email', style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Mulish',
                          )),
              const SizedBox(height: 10.0),
              TextFormField(
                validator: (value) => value!.isEmpty ? 'Enter an email' : null,
                onChanged: (value){
                  setState(() => email = value);
                },
              ),
              SizedBox(height: 20.0),
              const Text('Password', style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Mulish',
                          )),
              SizedBox(height: 10.0),
              TextFormField(
                obscureText: true,
                validator: (value) => value!.length < 6 ? 'Enter a password with 6+ characters' : null,
                onChanged: (value){
                  setState(() => password = value);
                }
              ),
              const Text('Username', style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Mulish',
                          )),
              SizedBox(height: 10.0),
              TextFormField(
                obscureText: true,
                validator: (value) => value!.isEmpty ? 'Enter a username' : null,
                onChanged: (value){
                  setState(() => username = value);
                }
              ),
              SizedBox(height: 20.0),
              const Text('Address', style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Mulish',
                )
              ),
              SizedBox(height: 10.0),
              TextFormField(
                obscureText: false,
                validator: (value) => value!.length < 10 ? 'Enter an address of 10+ characters' : null,
                onChanged: (value){
                  setState(() => address = value);
                }
              ),
              SizedBox(height: 20.0),
              const Text('Date of Birth', style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Mulish',
                )
              ),
              SizedBox(height: 10.0),
              InputDatePickerFormField(
                initialDate: DateTime.fromMillisecondsSinceEpoch(100),
                firstDate: DateTime(1940),
                lastDate: DateTime(2040),
                errorFormatText: "Invalid Format",
                errorInvalidText: "Invalid Date",
                onDateSubmitted: (date) {
                  setState(() {
                    dateOfBirth = date;
                  });
                },
                onDateSaved: (date){
                  setState(() {
                    dateOfBirth = date;
                  });
                },
              ),
              //TODO: Move this to another screen potentially.
              SizedBox(height: 20.0),
              const Text('Select Hobbies', style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Mulish',
                )
              ),
              SizedBox(height: 10.0),
              MultiSelectDialogField(
                items: _items, 
                selectedColor: Colors.green,
                validator: (results){
                  if (results == null || results.isEmpty) {
                    return "Required";
                  }
                  return null;
                },
                onConfirm: (results)  {
                  _selectedHobbies = results;
                }
              ),
              ElevatedButton(
                onPressed: () async {
                  _formKey.currentState!.save();
                  if(_formKey.currentState!.validate()){
                     dynamic result = await _auth.registerAccountAndVerify(email, password);
                    if(result == null){
                      setState(() {
                        error = 'Supply valid credentials';
                      });
                    }
                    else{
                      setState(() {
                        error = '';
                      });
                    }
                    _selectableHobbies.forEach((hobby) {
                      setState(() {
                        hobby.setUid(_auth.currentUser!.uid);
                      });
                    },);
                    widget.setHobbies(_selectedHobbies);
                    await GetIt.instance<RepositoryService>().insertGroupFlyUser(email, address, dateOfBirth, username);
                    widget.switchView("verify");
                  }
                }, 
                child: const Text('Complete Registration',
                  style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Mulish',
                          )
                )
              ),
              SizedBox(height: 12.0),
              Text(error, style: TextStyle(color: Colors.red, fontSize: 14.0))
            ],
          ),
        )
      ),
    );
  }
}