import 'package:flutter/material.dart';
import 'package:groupfly_project/services/authorization_service.dart';

class ChangePasswordWidget extends StatefulWidget{
  ChangePasswordWidget({super.key});

  @override
  State<ChangePasswordWidget> createState() => _ChangePasswordWidgetState();
}

class _ChangePasswordWidgetState extends State<ChangePasswordWidget>{
  final Authorization _auth = Authorization();
  final _formKey = GlobalKey<FormState>();

  String oldPassword = '';
  String newPassword = '';
  String error = '';
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromARGB(255, 10, 70, 94),
      child: Column(
        children: [
          Container(
            alignment: Alignment.topLeft,
            child: BackButton(
              onPressed: (){
                Navigator.of(context).pop();
              },
            )
          ),
          Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 20),
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
                  validator: (value) => value!.isEmpty ? 'Enter your old password' : null,
                  onChanged:(value) {
                    setState(() => oldPassword = value);
                  },
                ),
                const SizedBox(height: 20),
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
                  validator: (value) => value!.isEmpty ? 'Enter a new password' : null,
                  onChanged:(value) {
                    setState(() => newPassword = value);
                  },
                ),
                ElevatedButton(
                  onPressed: () async {
                    _formKey.currentState!.save();
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
                Text(error, style: TextStyle(color: Colors.red, fontSize: 14))
              ],
            )
          ),
        ],
      ),
    );
  }

}
