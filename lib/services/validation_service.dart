import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../models/Group.dart';
import '../models/Hobby.dart';

class ValidationService{
  bool validPassword(String text){
    return (text.isNotEmpty && text.length >=8 && containsUppercase(text) && containsLowercase(text) && containsSpecialCharacters(text));
  }
  bool validUsername(String text){
    return (text.isNotEmpty && text.length >= 2 && text.length <= 25);
  }
  bool validAddress(String text){
    return (text.isNotEmpty && text.length >= 10);
  }
  bool validDateOfBirth(DateTime birthday){
    print(birthday.year);
    DateTime today = DateTime.now();
    DateTime adultDate = DateTime(
      birthday.year + 18,
      birthday.month,
      birthday.day
    );
    return adultDate.isBefore(today);
  }
  bool validHobbiesList(List<Hobby> hobbies){
    return (hobbies != null && hobbies.isNotEmpty);
  }
  bool validPost(Group selectedGroup, XFile fileToPost){
    return selectedGroup != null && fileToPost != null;
  }
  bool validMaxCapacity(String text){
    return text != null && text.isNotEmpty && (int.tryParse(text) != null && !(int.parse(text) > 1));
  }
  bool containsUppercase(String text){
    var aAscii = 'A'.codeUnitAt(0);
    var zAscii = 'Z'.codeUnitAt(0);
    bool result = false;
    for (var character in text.characters) {
      if(character.codeUnitAt(0) >= aAscii && character.codeUnitAt(0) <= zAscii){
        result = true;
        break;
      }
    }
    return result;
  }
  bool containsSpecialCharacters(String text){
    String specialCharacters = "[!@#\$%^&*(),.?\":{}|<>]";
    bool result = false;
    for (var character in specialCharacters.characters) {
      if(text.contains(character)){
        result = true;
        break;
      }
    }
    return result;
  }
  bool containsLowercase(String text){
    var aAscii = 'a'.codeUnitAt(0);
    var zAscii = 'z'.codeUnitAt(0);
    bool result = false;
    for (var character in text.characters) {
      if(character.codeUnitAt(0) >= aAscii && character.codeUnitAt(0) <= zAscii){
        result = true;
        break;
      }
    }
    return result;
  }
  bool containsNumber(String text){
    var zeroAscii = '0'.codeUnitAt(0);
    var nineAscii = '9'.codeUnitAt(0);
    bool result = false;
    for(var character in text.characters) {
      if(character.codeUnitAt(0) >= zeroAscii && character.codeUnitAt(0) <= nineAscii){
        result = true;
        break;
      }
    }
    return result;
  }
}