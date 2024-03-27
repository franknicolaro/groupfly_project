import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:groupfly_project/widgets/ProfileWidgets/post_creation_group_container.dart';
import 'package:groupfly_project/widgets/ProfileWidgets/profile_picture.dart';
import 'package:groupfly_project/widgets/ProfileWidgets/user_post_list_widget.dart';
import 'package:image_picker/image_picker.dart';

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
  GeneralProfileWidget({required this.user});
  @override
  State<GeneralProfileWidget> createState() => _GeneralProfileWidgetState();
}

class _GeneralProfileWidgetState extends State<GeneralProfileWidget>{
  Authorization _auth = Authorization();
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
  @override
  void initState(){
    super.initState();
    initPosts();
    initGroups();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
          children: [
            Center(
              child: Stack(
                children: <Widget>[
                  ProfilePictureWidget(
                    imageUrl: widget.user.photoURL == null || widget.user.photoURL! == "" ? "https://images.vexels.com/media/users/3/180861/isolated/preview/f68f0a8f6f1901015166ae2f9d8a39f8-cute-ladybug-flying-outline.png" : widget.user.photoURL!,
                  ),
                  Visibility(
                    visible: widget.user.uid == _auth.currentUser!.uid,
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FriendCountLabel(user: widget.user),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.1015),
                  NumberOfGroupsLabel(numberOfGroups: groups.length),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.1015),
                  PostCountLabel(posts: posts),
                ]
              )
            ),
            //TODO:Change this visibility to instead be an Add Friend or Create a new post button, depending on who is the user in this profile
            //e.g. widget.user.uid == _auth.currentUser!.uid
            Visibility(
              visible: widget.user.uid == _auth.currentUser!.uid,
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
        Post postToAdd = Post(comments: [], description: _newPostController.text, groupRef: groupRef, imageUrl: tempUrl!, likesByUid: [], postId: '', posterId: widget.user.uid!);
        GetIt.instance<RepositoryService>().insertPost(postToAdd);
        posts.insert(0, postToAdd);
      });
    });
  }
  Widget postPopUp(){
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
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
                },
                label: Text("Take a photo"),
              ),
              TextButton.icon(
                icon: Icon(Icons.image),
                onPressed:(){
                  takePostPhoto(ImageSource.gallery);
                },
                label: Text("Choose a photo")
              )
            ]
          ),
          Text(selectedGroup == null ? "Select a group that this is in reference to:" : "Group seleced: ${selectedGroup!.title}",
            style: TextStyle(
              fontSize: 24
            )
          ),
          SingleChildScrollView(
            child: Row(
              children: groups.map((group) =>
                OutlinedButton(
                  onPressed: () {
                    setState(() {
                      selectedGroup = group;
                    });
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
                DocumentReference refToGroup = FirebaseFirestore.instance.doc("group/${selectedGroup!.group_id}");
                uploadPostImageAndAddPost(refToGroup);
                Navigator.pop(context);
              });
            }, 
            child: Text("Create Post")
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