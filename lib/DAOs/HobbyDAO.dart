import '../models/Hobby.dart';

abstract class HobbyDao{
  Future<void> insertHobbies(List<Hobby> selectedHobbies);
}