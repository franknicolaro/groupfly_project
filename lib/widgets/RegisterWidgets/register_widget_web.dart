import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:groupfly_project/services/repository_service.dart';
import 'package:groupfly_project/services/validation_service.dart';

import '../../models/Hobby.dart';
import '../../services/authorization_service.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class RegisterWidgetWeb extends StatefulWidget{
  //Functions passed through to RegisterWidget from LoginController
  final Function switchView;
  final Function setHobbies;
  RegisterWidgetWeb({super.key, required this.switchView, required this.setHobbies});

  @override
  _RegisterWidgetWebState createState() => _RegisterWidgetWebState();
}
class _RegisterWidgetWebState extends State<RegisterWidgetWeb>{
  //Services intialized for authorization and validation.
  final Authorization _auth = Authorization();
  final ValidationService _validation = ValidationService();

  //Key to keep track of data in form.
  final _formKey = GlobalKey<FormState>();

  //Variables to be passed through to _auth for registration.
  String email = '';
  String password = '';

  //Error message text.
  String error = '';

  //Other variables that are added into user's document in Firestore.
  String address = '';
  String username = '';
  DateTime? dateOfBirth;
  List<Hobby> _selectedHobbies = [];

  //All selectable hobbies from the HobbyRepository.
  static final List<Hobby> _selectableHobbies = GetIt.instance<RepositoryService>().getAllHobbies();

  //Mapping of Hobbies to a MultiSelectItem Widget.
  final _items = _selectableHobbies.map((hobby) => MultiSelectItem<Hobby>(hobby, hobby.hobbyName))
  .toList();

  @override
  Widget build(BuildContext context) {
    //Scaffold to return an AppBar with a body widget (Container).
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 10, 70, 94),
      //AppBar that displays a title text for login.
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text('Register for Groupfly'),
        actions: [
          //Allows the switching of views from register to login.
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
      //Container that withholds the Form of TextFields (contained in a SingleChildScrollView to scroll through the Form).
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 35.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                //Email Label with TextField
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
                //Password Label with TextField
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
                  validator: (value) => !_validation.validPassword(value!) ? 'Enter a password that contains 8+ characters, an uppercase and lowercase letter, and a special character' : null,
                  onChanged: (value){
                    setState(() => password = value);
                  }
                ),
                //Username Label with TextField
                const Text('Username', style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Mulish',
                            )),
                SizedBox(height: 10.0),
                TextFormField(
                  validator: (value) => !_validation.validUsername(value!) ? 'Enter a username with at least 2 characters but no more than 25 characters' : null,
                  onChanged: (value){
                    setState(() => username = value);
                  }
                ),
                //Address Label with TextField
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
                  validator: (value) => !_validation.validAddress(value!) ? 'Enter an address of 10+ characters' : null,
                  onChanged: (value){
                    setState(() => address = value);
                  }
                ),
                //Date of Birth Label with Date Input Field.
                //Dates entered must not only be of a valid date, 
                //but also the valid format (format provided as hint text).
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
                  lastDate: DateTime(DateTime.now().year - 18, DateTime.now().month, DateTime.now().day),
                  errorFormatText: "Invalid Format",
                  errorInvalidText: "Invalid Date: Must be 18+ to register.",
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
                //Sellect Hobbies Label with MutliSelectDialogField.
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
                  validator: (results) => !_validation.validHobbiesList(results!) ? "At least one hobby must be selected" : null,
                  onConfirm: (results)  {
                    _selectedHobbies = results;
                  }
                ),
                //Submit button for registration.
                ElevatedButton(
                  onPressed: () async {
                    _formKey.currentState!.save();
                    //Validate all text fields.
                    if(_formKey.currentState!.validate()){
                      dynamic result = await _auth.registerAccountAndVerify(email, password);
                      if(result == null){
                        setState(() {
                          error = 'Supply valid credentials: Email may be in improper form.';
                        });
                      }
                      else{
                        setState(() {
                          error = '';
                        });
                      }
                      //Sets the current user's uid to each Hobby selected.
                      _selectableHobbies.forEach((hobby) {
                        setState(() {
                          hobby.setUid(_auth.currentUser!.uid);
                        });
                      },);
                      //Call setHobbies and insert the GroupFlyUser (with active set to false until verified).
                      //Then, switches view to VerifyAccountScreen
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
                const SizedBox(height: 12.0),
                //Error Text
                Text(error, style: TextStyle(color: Colors.red, fontSize: 14.0))
              ],
            ),
          ),
        )
      ),
    );
  }
}