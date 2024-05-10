import '../models/Hobby.dart';

//Hobby Data Access Object
abstract class HobbyDao{
  Future<void> insertHobbies(List<Hobby> selectedHobbies);
  List<Hobby> getAllHobbies();
}