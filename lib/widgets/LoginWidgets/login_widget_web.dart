import 'package:flutter/material.dart';

import '../../services/authorization_service.dart';

class LoginWidgetWeb extends StatefulWidget{
  final Function switchView;
  LoginWidgetWeb({super.key, required this.switchView});

  @override
  _LoginWidgetWebState createState() => _LoginWidgetWebState();
}

class _LoginWidgetWebState extends State<LoginWidgetWeb>{
  final Authorization _auth = Authorization();
  final _formKey = GlobalKey<FormState>();

  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 10, 70, 94),
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text('Login to Groupfly'),
        actions: [
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
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () async {
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
              SizedBox(height: 12.0),
              Text(error, style: TextStyle(color: Colors.red, fontSize: 14.0))
            ],
          ),
        )
      ),
    );
  }
}