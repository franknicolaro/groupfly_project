import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../models/Group.dart';
import '../models/Hobby.dart';

//A standalone service which acts to validate the information entered.
class ValidationService{

  //Checks for a valid password. A password is valid if the text is 8+ characters and
  //contains an uppercase, lowercase, and special character.
  bool validPassword(String text){
    return (text.isNotEmpty && text.length >=8 && containsUppercase(text) && containsLowercase(text) && containsSpecialCharacters(text));
  }

  //Checks for a valid username. A username is valid if the text is between 2
  //and 25 characters.
  bool validUsername(String text){
    return (text.isNotEmpty && text.length >= 2 && text.length <= 25);
  }

  //Checks for a valid address. An address is valid if the text is 10 characters.
  bool validAddress(String text){
    return (text.isNotEmpty && text.length >= 10);
  }

  //Checks for a valid date of birth, which checks if the age of the user is at least 18 years.
  bool validDateOfBirth(DateTime birthday){
    DateTime today = DateTime.now();
    DateTime adultDate = DateTime(
      birthday.year + 18,
      birthday.month,
      birthday.day
    );
    return adultDate.isBefore(today);
  }

  //Checks if the hobbies list is not empty.
  bool validHobbiesList(List<Hobby> hobbies){
    return (hobbies != null && hobbies.isNotEmpty);
  }

  //Checks if a post is valid, which checks if the group selected and file to be posted aren't null.
  bool validPost(Group selectedGroup, XFile fileToPost){
    return selectedGroup != null && fileToPost != null;
  }

  //Checks if the Group's maximum capacity is valid, which checks if the value is greater than 1.
  bool validMaxCapacity(String text){
    return text != null && text.isNotEmpty && (int.tryParse(text) != null && (int.parse(text) > 1));
  }

  //Checks if the text contains an uppercase character, which uses
  //Unicode from 'A' to 'Z' to compare with the characters from the text.
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

  //Checks if the text contains special characters, which checks the text each time
  //for each speacial character in the specialCharacters string.
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
  //Checks if the text contains lowercase characters, which uses
  //Unicode from 'a' to 'z' to compare with the characters from the text.
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
}