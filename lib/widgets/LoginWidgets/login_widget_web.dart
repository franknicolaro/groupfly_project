import 'package:flutter/material.dart';

import '../../services/authorization_service.dart';

class LoginWidgetWeb extends StatefulWidget{
  //Function passed through to LoginWidget from LoginController
  final Function switchView;
  LoginWidgetWeb({super.key, required this.switchView});

  @override
  _LoginWidgetWebState createState() => _LoginWidgetWebState();
}

class _LoginWidgetWebState extends State<LoginWidgetWeb>{
  //Authorization Service to allow for the login of the user.
  final Authorization _auth = Authorization();

  //Key to keep track of data in form.
  final _formKey = GlobalKey<FormState>();

  //Variables to be passed through to _auth for login.
  String email = '';
  String password = '';

  //Error message that displays if the login doesn't correctly occur.
  String error = '';

  @override
  Widget build(BuildContext context) {
    //Scaffold which returns an AppBar and a body widget (Container)
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 10, 70, 94),
      appBar: 
      //AppBar that displays a title text for login.
      AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text('Login to Groupfly'),
        actions: [
          //Allows the switching of views from login to register.
          TextButton.icon(
            onPressed: (){
              widget.switchView("register");
            }, 
            icon: const Icon(Icons.person, color: Colors.black), 
            label: const Text('Register',
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
      //Container that withholds the Form of TextFields.
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 35.0),
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
              const SizedBox(height: 20.0),
              const Text('Password', style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Mulish',
                          )),
              const SizedBox(height: 10.0),
              TextFormField(
                obscureText: true,
                validator: (value) => value!.length < 6 ? 'Enter a password with 6+ characters' : null,
                onChanged: (value){
                  setState(() => password = value);
                }
              ),
              const SizedBox(height: 20.0),
              //Sign in button with validation.
              ElevatedButton(
                onPressed: () async {
                  //Uses validator functions within each TextField.
                  if(_formKey.currentState!.validate()){
                    dynamic result = await _auth.signIn(email, password);
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
                  }
                }, 
                child: const Text('Sign in',
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
        )
      ),
    );
  }
}