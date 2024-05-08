import 'package:flutter/material.dart';
import 'package:groupfly_project/services/authorization_service.dart';
import 'package:groupfly_project/services/validation_service.dart';

//A class that allows the current user to change their password.
class ChangePasswordWidget extends StatefulWidget{
  ChangePasswordWidget({super.key});

  @override
  State<ChangePasswordWidget> createState() => _ChangePasswordWidgetState();
}

class _ChangePasswordWidgetState extends State<ChangePasswordWidget>{
  //Authorization service to update the password.
  final Authorization _auth = Authorization();

  //Validation service to validate the new password.
  final ValidationService _validation = ValidationService();

  //The key for the Form
  final _formKey = GlobalKey<FormState>();

  //Strings to keep track of the old password, new password, and error message.
  String oldPassword = '';
  String newPassword = '';
  String error = '';

  //Builds the ChangePasswordWidget
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromARGB(255, 10, 70, 94),
      child: Column(
        children: [
          //Back button to remove the ChangePasswordWidget from display
          Container(
            alignment: Alignment.topLeft,
            child: BackButton(
              onPressed: (){
                Navigator.of(context).pop();
              },
            )
          ),
          //Form to enter the old and new passwords
          Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 20),
                //Label and TextField for old password
                const Text('Old Password',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Mulish'
                  )
                ),
                const SizedBox(height: 10),
                TextFormField(
                  obscureText: true,
                  validator: (value) => value!.isEmpty ? 'Enter your old password' : null,
                  onChanged:(value) {
                    setState(() => oldPassword = value);
                  },
                ),
                const SizedBox(height: 20),
                //Label and TextField for new password
                const Text('New Password',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Mulish'
                  )
                ),
                const SizedBox(height: 10),
                TextFormField(
                  obscureText: true,
                  validator: (value) => _validation.validPassword(value!) ? 'Enter a new password that is 8+ characters, with uppercase, lowercase, and special characters' : null,
                  onChanged:(value) {
                    setState(() => newPassword = value);
                  },
                ),
                //Submit button to change the password.
                ElevatedButton(
                  onPressed: () async {
                    _formKey.currentState!.save();
                    //Checks if the passwords match after validating. If they do,
                    //display the error message. If not, then change the password, then remove
                    //ChangePasswordWIdget from display.
                    if(_formKey.currentState!.validate()){
                      if(oldPassword == newPassword){
                        setState(() {
                          error = 'Passwords match.';
                        },);
                      }
                      else{
                        setState(() {
                          error = '';
                        },);
                        await _auth.changePassword(oldPassword, newPassword).then((_) {
                          Navigator.of(context).pop();
                        },);
                      }
                    }
                  }, 
                  child: const Text('Change Password',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Mulish'
                    )
                  )
                ),
                SizedBox(height: 15),
                //Error label.
                Text(error, style: TextStyle(color: Colors.red, fontSize: 14))
              ],
            )
          ),
        ],
      ),
    );
  }

}
