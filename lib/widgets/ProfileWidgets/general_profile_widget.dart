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

//A class that displays a profile widget, depending on the user passed through.
//This is different from UserProfileWeb because this contains the actual data,
//Whereas UserProfileWeb contains GeneralProfileWidget where the user passed
//into it is the current user accessing the system.
class GeneralProfileWidget extends StatefulWidget{
  GroupFlyUser user;        //The user of the profile.
  FriendList friends;       //The friend list of the user.
  bool isFromOtherPage;     //A boolean to check if the user is from another page other than the UserProfileWeb.
  bool isCurrentUserFriend; //A boolean to check if the current user is a friend of the user.
  Function removeFriend;    //The removeFriend function from AppController.
  GeneralProfileWidget({required this.user, required this.isFromOtherPage, required this.isCurrentUserFriend, required this.friends, required this.removeFriend});
  @override
  State<GeneralProfileWidget> createState() => _GeneralProfileWidgetState();
}

class _GeneralProfileWidgetState extends State<GeneralProfileWidget>{
  //Authorization service for friend request/removal.
  final Authorization _auth = Authorization();

  //Validation Service for checking for a valid post.
  final ValidationService _validation = ValidationService();

  //FirebaseStorage instance for image uploading (profile picture and post creation)
  FirebaseStorage storage = FirebaseStorage.instance;

  //Variables for file selection for image uploading.
  PickedFile? _imageFile;
  final ImagePicker _imagePicker = ImagePicker();
  var selectedFile;
  XFile? fileToPost;

  //Controller for new post caption.
  var _newPostController = TextEditingController();

  //The selected group that a new post is in reference to.
  Group? selectedGroup;

  //Temporarily holds the url of the image which would be uploaded with the post.
  String? tempUrl;

  //Data about the user including posts, groups, and friends (with a FriendList object for obtaining UIDs)
  List<Post> posts = [];
  List<Group> groups = [];
  List<GroupFlyUser> friends = [];
  FriendList? list;

  //Boolean to check if the profile is the current user's profile.
  late bool isProfileOfCurrentUser;

  //Error label for post creation form.
  String error = "";

  //Initializes data about the user and the boolean that checks for the currentUser.
  @override
  void initState() {
    super.initState();
    initPosts();
    initGroups();
    isProfileOfCurrentUser = widget.user.uid == _auth.currentUser!.uid;
    initFriends();
  }

  //A method which updates the UI by calling setState.
  void refresh(){
    setState(() {
      
    });
  }

  //Builds the GeneralProfileWidget.
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Color.fromARGB(255, 10, 70, 94),
        child: Column(
          children: [
            //BackButton to remove the GeneralProfileWidget from display,
            //but only if the profile doesn't concern the current user and 
            //the current user is not from another page other than ProfileWidgetWeb.
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
                  //Displays the profile picture with the given imageURL. 
                  //If the user does not currently have a photoURL, then uses a
                  //stock image from the internet.
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
                          //displays the option to upload an image.
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
            //Username Label
            UsernameLabel(user: widget.user),
            Center(
              child: !isProfileOfCurrentUser ?
                (widget.isCurrentUserFriend ?
                //Remove Friend button.
                  ElevatedButton(
                    onPressed: (){
                      //Removes the friend from both the user's document in Firestore 
                      //in addition to the user from the friend's document. 
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
                  //Send friend request button.
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
                  //FriendCountLabel
                  FriendCountLabel(friends: widget.friends),
                  SizedBox(width:15),
                  //View Friends Button
                  ElevatedButton(
                    onPressed: (){
                      //Refreshes to update the number of friends of the user, then
                      //displays those friends in the FriendListWidget.
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
                  //NumberOfGroupsLabel
                  NumberOfGroupsLabel(numberOfGroups: groups.length),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.1015),
                  //PostCountLabel
                  PostCountLabel(posts: posts),
                ]
              )
            ),
            //New post button
            Visibility(
              visible: isProfileOfCurrentUser,
              child: ElevatedButton(
                onPressed: (){
                  //Displays the post creation form.
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
            //Displays the post list of the user.
            UserPostList(posts: posts, user: widget.user,),
          ]
        ),
      );
  }

  //Initializes the groups list.
  void initGroups(){
    GetIt.instance<RepositoryService>().getGroupsByMemberUID(widget.user.uid!).then((value) {
      setState(() {
        groups = value;
      });
    },);
  }

  //Initializes the posts list.
  void initPosts(){
    GetIt.instance<RepositoryService>().getPostsByUID(widget.user.uid!).then((value){
      setState(() {
        posts = value;
      });
    });
  }

  //Initializes FriendList object and list of GroupFlyUsers that are friends.
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

  //An update to get all users that are friends of the user the profile pertains to.
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

  //Obtains an image from the current user, which is 
  //uploaded to FirebaseStorage and used as the 
  //current user's new profile picture.
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

  //Takes an image for the current user's new post to upload.
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

  //Uploads the image file for the post and creates the post.
  //Then, inserts the post to both the local list and the
  //post collection in Firestore.
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

  //Locally removes the friend from the current user's friends.
  //Also removes the friend from the AppController list.
  void removeFriend(String uid){
    setState(() {
      friends.removeWhere((user) => user.uid! == uid);
      widget.removeFriend(uid);
    });
  }
  //Returns the UserFriendListWidget.
  Widget displayFriendsOfUser(){
    return UserFriendListWidget(friends: friends, removeFriend: removeFriend, friendList: widget.friends, user: widget.user);
  }

  //Returns the post creation form.
  Widget postPopUp(){
    return Container(
      color: Color.fromARGB(255, 17, 127, 171),
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          //Button to remove post creation form from display.
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
          //Label for selected photo.
          Text(fileToPost == null ? "Select a photo:" : "Selected file name: ${fileToPost!.name}",
            style: TextStyle(
              fontSize: 24
            )
          ),
          //Buttons to choose the image source.
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton.icon(
                icon: Icon(Icons.camera_alt),
                onPressed: (){
                  //Takes the photo for the post with the camera as image source, then refreshes the widget.
                  takePostPhoto(ImageSource.camera);
                  refresh();
                },
                label: Text("Take a photo"),
              ),
              TextButton.icon(
                icon: Icon(Icons.image),
                onPressed:(){
                  //Takes the photo for the post with the platform's photo gallery/file explorer as image source, then refreshes the widget.
                  takePostPhoto(ImageSource.gallery);
                  refresh();
                },
                label: Text("Choose a photo")
              )
            ]
          ),
          //Selected Group Label
          Text(selectedGroup == null ? "Select a group that this is in reference to (Shift + scroll if using a mouse):" : "Group seleced: ${selectedGroup!.title}",
            style: TextStyle(
              fontSize: 24
            )
          ),
          //Button to select the group for the post.
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
          //TextField for the caption of the post.
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
          //Submit button for create post
          ElevatedButton(
            onPressed: () {
              setState(() {
                //Checks if the post is valid. If it is, get a reference to the group and upload
                //the post and image. If not, display an error. A post is invalid if it does not have
                //a selected group or an image to post.
                if(!_validation.validPost(selectedGroup!, fileToPost!)){
                  error = "Please provide an image and group before posting.";
                }
                else{
                  DocumentReference refToGroup = FirebaseFirestore.instance.doc("group/${selectedGroup!.group_id}");
                  uploadPostImageAndAddPost(refToGroup);
                  Navigator.pop(context);
                }
              });
            }, 
            child: Text("Create Post")
          ),
          //Error text
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
  //Returns a pop up Widget for selecting a profile picture.
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
          //Label to ask how the user would like to display their photo.
          Text(
            "How would you like to select your photo?",
            style: TextStyle(
              fontSize: 20
            ),
          ),
          SizedBox(
            height: 20,
          ),
          //Buttons for selecting photo.
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton.icon(
                icon: Icon(Icons.camera_alt),
                //Takes the photo with the camera as image source
                onPressed: (){
                  takePhoto(ImageSource.camera);
                },
                label: Text("Take a photo"),
              ),
              TextButton.icon(
                icon: Icon(Icons.image),
                //Takes the photo with the platform's image gallery/file explorer as image source
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