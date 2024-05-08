import 'package:cloud_firestore/cloud_firestore.dart';

//GroupFlyUser model.
class GroupFlyUser{
  final String? uid;
  late String email;
  late String address;
  late DateTime? dateOfBirth;
  late String username;
  late String? photoURL;
  late int? homeFeedRecency;
  late bool? active;

  GroupFlyUser({required this.uid, this.email = '', this.address = '', this.dateOfBirth, this.username = '', this.photoURL, this.homeFeedRecency, this.active});

  //Obtains data from a Firebase Snapshot and returns a GroupFlyUser object.
  factory GroupFlyUser.fromDB(DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,){
      final map = snapshot.data();
      return GroupFlyUser(
        uid: snapshot.id,
        email: map?['email'], 
        address: map?['address'], 
        dateOfBirth: (map?['date_of_birth'] as Timestamp).toDate(),
        username: map?['username'],
        photoURL: map?['photo_url'],
        homeFeedRecency: map?['home_feed_recency_in_days'],
        active: map?['active']
    );
  }

  //Maps the current GroupFlyUser object to a map which would be passed through to a Repository
  //(Note: is not required for UserRepo, but is utilized in a method that it is implemented in)
  Map<String, dynamic> toMap(){
    return {
      'email': email,
      'address': address,
      'date_of_birth': dateOfBirth,
      'username': username
    };
  }

  //Sets active to true for account reactivation use-case.
  void reactivate(){
    active = true;
  }
}