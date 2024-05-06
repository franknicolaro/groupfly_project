import 'dart:js_interop';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:groupfly_project/services/validation_service.dart';
import 'package:groupfly_project/widgets/FriendsWidgets/user_friend_list_widget.dart';
import 'package:groupfly_project/widgets/ProfileWidgets/post_creation_group_container.dart';
import 'package:groupfly_project/widgets/ProfileWidgets/profile_picture.dart';
import 'package:groupfly_project/widgets/ProfileWidgets/user_post_list_widget.dart';
import 'package:image_picker/image_picker.dart';

import '../../models/FriendList.dart';
import '../../models/Group.dart';
import '../../models/Post.dart';
import '../../models/group_fly_user.dart';
import '../../services/authorization_service.dart';
import '../../services/repository_service.dart';
import 'ProfileLabels/friend_count_label.dart';
import 'ProfileLabels/number_of_groups_label.dart';
import 'ProfileLabels/number_of_posts_label.dart';
import 'ProfileLabels/username_label.dart';

class GeneralProfileWidget extends StatefulWidget{
  GroupFlyUser user;
  FriendList friends;
  bool isFromOtherPage;
  bool isCurrentUserFriend;
  Function removeFriend;
  GeneralProfileWidget({required this.user, required this.isFromOtherPage, required this.isCurrentUserFriend, required this.friends, required this.removeFriend});
  @override
  State<GeneralProfileWidget> createState() => _GeneralProfileWidgetState();
}

class _GeneralProfileWidgetState extends State<GeneralProfileWidget>{
  final Authorization _auth = Authorization();
  final ValidationService _validation = ValidationService();
  FirebaseStorage storage = FirebaseStorage.instance;
  PickedFile? _imageFile;
  final ImagePicker _imagePicker = ImagePicker();
  var selectedFile;
  Group? selectedGroup;
  var _newPostController = TextEditingController();
  XFile? fileToPost;
  String? userName;
  List<Post> posts = [];
  String? tempUrl;
  List<Group> groups = [];
  List<GroupFlyUser> friends = [];
  FriendList? list;
  late bool isProfileOfCurrentUser;
  late bool isCurrentUserFriend;
  String error = "";
  @override
  void initState() {
    super.initState();
    initPosts();
    initGroups();
    isProfileOfCurrentUser = widget.user.uid == _auth.currentUser!.uid;
    initFriends();
  }
  //TODO: add "addFriend" button to send a notification.

  void refresh(){
    setState(() {
      
    });
  }
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Color.fromARGB(255, 10, 70, 94),
        child: Column(
          children: [
            Visibility(
              visible: !isProfileOfCurrentUser || widget.isFromOtherPage,
              child: Container(
                alignment: Alignment.topLeft,
                child: BackButton(
                  onPressed: (){
                    Navigator.of(context).pop();
                  },
                )
              )
            ),
            Center(
              child: Stack(
                children: <Widget>[
                  ProfilePictureWidget(
                    imageUrl: widget.user.photoURL == null || widget.user.photoURL! == "" ? "https://images.vexels.com/media/users/3/180861/isolated/preview/f68f0a8f6f1901015166ae2f9d8a39f8-cute-ladybug-flying-outline.png" : widget.user.photoURL!,
                  ),
                  Visibility(
                    visible: isProfileOfCurrentUser,
                    child: Positioned(
                      bottom: 20,
                      right: 20,
                      child: InkWell(
                        onTap:(){
                          showModalBottomSheet(
                            context: context, 
                            builder: ((builder) => photoPopUp()),
                          );
                        },
                        child: Icon(
                          Icons.camera_alt,
                          color: Colors.black45,
                          size: 30
                        )
                      ),
                    )
                  )
                ]
              ),
            ),
            UsernameLabel(user: widget.user),
            Center(
              child: !isProfileOfCurrentUser ?
                (widget.isCurrentUserFriend ?
                  ElevatedButton(
                    onPressed: (){
                      GetIt.instance<RepositoryService>().removeFriend(_auth.currentUser!.uid, widget.user.uid!).then((_) {
                        GetIt.instance<RepositoryService>().removeFriend(widget.user.uid!, _auth.currentUser!.uid).then((_){
                          widget.removeFriend(widget.user.uid!);
                          Navigator.of(context).pop();
                        });
                      });
                    }, 
                    child: Text("Remove Friend",
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Mulish'
                      )
                    )
                  ) :
                  ElevatedButton(
                    onPressed: (){
                      GetIt.instance<RepositoryService>().sendFriendRequestNotification(_auth.currentUser!.uid, widget.user.uid!);
                    }, 
                    child: Text("Send Friend Request",
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Mulish'
                      )
                    )
                  )
                ) : null
            ),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FriendCountLabel(friends: widget.friends),
                  SizedBox(width:15),
                  ElevatedButton(
                    onPressed: (){
                      refreshFriends().then((value) {
                        showModalBottomSheet(
                          isScrollControlled: true,
                          context: context, 
                          builder: ((builder) => displayFriendsOfUser())
                        );
                      });
                    }, 
                    child: Text("View Friends",
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Mulish'
                      )
                    )
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.1015),
                  NumberOfGroupsLabel(numberOfGroups: groups.length),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.1015),
                  PostCountLabel(posts: posts),
                ]
              )
            ),
            Visibility(
              visible: isProfileOfCurrentUser,
              child: ElevatedButton(
                onPressed: (){
                  showModalBottomSheet(
                    context: context,
                    builder: ((builder) => postPopUp())
                  );
                },
                child: const Text('Create a new post',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Mulish'
                  )
                )
              )
            ),
            UserPostList(posts: posts, user: widget.user,),
            /*
            TODO: Profile Settings needs to be added.
            */
          ]
        ),
      );
  }
  void initGroups(){
    GetIt.instance<RepositoryService>().getGroupsByMemberUID(widget.user.uid!).then((value) {
      setState(() {
        groups = value;
      });
    },);
  }
  void initPosts(){
    GetIt.instance<RepositoryService>().getPostsByUID(widget.user.uid!).then((value){
      setState(() {
        posts = value;
      });
    });
  }
  Future<void> initFriends() async{
    GetIt.instance<RepositoryService>().getFriendsByUID(widget.user.uid!).then(((friendList) {
      setState(() {
        list = friendList;
        for(String uid in friendList.friend_uids){
          GetIt.instance<RepositoryService>().getGroupFlyUserByUID(uid).then((friend){
            friends.add(friend);
          });
        }
      });
    }));
  }
  Future<void> refreshFriends() async{
    FriendList? doNotAddAgain;
    if(!list.isNull){
      doNotAddAgain = list!;
    }
    GetIt.instance<RepositoryService>().getFriendsByUID(widget.user.uid!).then(((friendList) {
      setState(() {
        list = friendList;
        for(String uid in friendList.friend_uids){
          if(!doNotAddAgain.isNull && !doNotAddAgain!.friend_uids.contains(uid)){
            GetIt.instance<RepositoryService>().getGroupFlyUserByUID(uid).then((friend){
              friends.add(friend);
            });
          }
        }
      });
    }));
  }
  void takePhoto(ImageSource source) async{
    selectedFile = await _imagePicker.pickImage(
      source: source,
    );
    if(selectedFile != null){
      Reference ref = FirebaseStorage.instance.ref().child("images/${_auth.currentUser!.uid}");
      TaskSnapshot taskSnapshot = await ref.putData(await selectedFile.readAsBytes());
      String url = await taskSnapshot.ref.getDownloadURL();
      await _auth.currentUser!.updatePhotoURL(url);
      setState(() {
        _imageFile = PickedFile(url);
      });
    }
  }
  void takePostPhoto(ImageSource source) async{
    selectedFile = await _imagePicker.pickImage(
      source: source,
    );
    if(selectedFile != null){
      setState(() {
        fileToPost = selectedFile;
      });
    }
  }
  Future<void> uploadPostImageAndAddPost(DocumentReference groupRef) async{
    Reference ref = FirebaseStorage.instance.ref().child("images/${fileToPost!.name}");
    TaskSnapshot taskSnapshot = await ref.putData(await selectedFile.readAsBytes());
    taskSnapshot.ref.getDownloadURL().then((value) {
      setState((){
        tempUrl = value;
        Post postToAdd = Post(comments: [], description: _newPostController.text, groupRef: groupRef, imageUrl: tempUrl!, likesByUid: [], postId: '', posterId: widget.user.uid!, datePosted: DateTime.now());
        GetIt.instance<RepositoryService>().insertPost(postToAdd);
        posts.insert(0, postToAdd);
      });
    });
  }
  void removeFriend(String uid){
    setState(() {
      friends.removeWhere((user) => user.uid! == uid);
      widget.removeFriend(uid);
    });
  }
  Widget displayFriendsOfUser(){
    return UserFriendListWidget(friends: friends, removeFriend: removeFriend, friendList: widget.friends, user: widget.user);
  }
  Widget postPopUp(){
    return Container(
      color: Color.fromARGB(255, 17, 127, 171),
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          //TODO: Change this to back button.
          ElevatedButton(
            onPressed: (){
              Navigator.pop(context);
            }, 
            child: Text("Back to Profile",
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
                fontFamily: 'Mulish'
              )
            )
          ),
          Text(fileToPost == null ? "Select a photo:" : "Selected file name: ${fileToPost!.name}",
            style: TextStyle(
              fontSize: 24
            )
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton.icon(
                icon: Icon(Icons.camera_alt),
                onPressed: (){
                  takePostPhoto(ImageSource.camera);
                  refresh();
                },
                label: Text("Take a photo"),
              ),
              TextButton.icon(
                icon: Icon(Icons.image),
                onPressed:(){
                  takePostPhoto(ImageSource.gallery);
                  refresh();
                },
                label: Text("Choose a photo")
              )
            ]
          ),
          Text(selectedGroup == null ? "Select a group that this is in reference to (Shift + scroll if using a mouse):" : "Group seleced: ${selectedGroup!.title}",
            style: TextStyle(
              fontSize: 24
            )
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: groups.map((group) =>
                OutlinedButton(
                  onPressed: () {
                    setState(() {
                      selectedGroup = group;
                    });
                    refresh();
                  },
                  child: PostCreationGroupContainer(group: group)
                )
              ).toList()
            ),
          ),
          TextField(
            controller: _newPostController,
            decoration: InputDecoration(
              border:OutlineInputBorder(),
              hintText: "Enter a caption",
              suffixIcon: IconButton(
                icon: Icon(Icons.clear),
                onPressed: (){
                  _newPostController.clear();
                },
              )
            )
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                if(!_validation.validPost(selectedGroup!, fileToPost!)){
                  error = "Please provide an image and group before posting.";
                }
                //TODO: add errors if user hasn't selected a photo or group.
                DocumentReference refToGroup = FirebaseFirestore.instance.doc("group/${selectedGroup!.group_id}");
                uploadPostImageAndAddPost(refToGroup);
                Navigator.pop(context);
              });
            }, 
            child: Text("Create Post")
          ),
          Text(error,
            style: TextStyle(
              color: Colors.red,
              fontFamily: "Mulish",
              fontWeight: FontWeight.w500,
              fontSize: 14
            ),
          )
        ],
      )
    );
  }
  Widget photoPopUp() {
    return Container(
      height: 75,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        children: [
          Text(
            "How would you like to select your photo?",
            style: TextStyle(
              fontSize: 20
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton.icon(
                icon: Icon(Icons.camera_alt),
                onPressed: (){
                  takePhoto(ImageSource.camera);
                },
                label: Text("Take a photo"),
              ),
              TextButton.icon(
                icon: Icon(Icons.image),
                onPressed:(){
                  takePhoto(ImageSource.gallery);
                },
                label: Text("Choose a photo")
              )
            ]
          )
        ],
      )
    );
  }
}