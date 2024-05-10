import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:groupfly_project/services/image_storage_service.dart';
import 'package:groupfly_project/services/repository_service.dart';

import '../../models/Group.dart';
import '../../models/Post.dart';
import '../../models/group_fly_user.dart';
import 'likes_and_comments_widget.dart';

//A class that displays a post information.
class PostContainer extends StatefulWidget{
  Post post;              //The post to be displayed.
  GroupFlyUser user;      //The current user, passed through into the LikesAndCommentsWidget.
  PostContainer({required this.post, required this.user});
  @override
  State<PostContainer> createState() => _PostContainerState();
}

class _PostContainerState extends State<PostContainer>{
  //ImageStorageService for retrieving images and 
  //FirebaseStorage instance, used to upload images to Firebase.
  final ImageStorageService _storage = ImageStorageService();
  FirebaseStorage fbStorage = FirebaseStorage.instance;

  var imageUrl;       //The url of the image to be displayed.
  var groupAsFuture;  //The group that the post is in reference to as a future variable.
  String? url;        //Non-future version of the url.

  //Initialize the State and the "future" variables for their respective FutureBuilders
  @override
  void initState(){
    super.initState;
    initImageUrl();
    initGroup();
  }

  //Initializes the "future" url variable.
  void initImageUrl() {
    imageUrl = _storage.getImageUrlFromStorage(fbStorage.ref().child(widget.post.imageUrl));
  }

  //Initializes the "future" group variable.
  void initGroup(){
    groupAsFuture = GetIt.instance<RepositoryService>().getGroupByPostReference(widget.post.groupRef);
  }

  //Builds the PostContainer.
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          //Container used as the background of the post.
          child: Container(
            height: MediaQuery.of(context).size.height * 0.34,
            width: MediaQuery.of(context).size.width * 0.55,
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 21, 153, 206),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    //Container to hold the image.
                    Container(
                      alignment: Alignment.topLeft,
                      child:FutureBuilder(
                        future: imageUrl,
                        builder: ((context, snapshot) {
                          if(snapshot.connectionState == ConnectionState.done){
                            if(snapshot.hasError){
                              return Center(
                                child: Text(
                                  '${snapshot.error} occurred'
                                )
                              );
                            }
                            else if(snapshot.hasData){
                              url = snapshot.data as String;
                              return Container(
                                height: MediaQuery.of(context).size.height * .25,
                                width: MediaQuery.of(context).size.width * .25,
                                child: Image.network(url!)
                              );
                            }
                          }
                          return const Center(
                            child: CircularProgressIndicator()
                          );
                        })
                      ),
                    ),
                    //FutureBuilder which holds data about the group.
                    FutureBuilder(
                      future: groupAsFuture,
                      builder: ((context, snapshot) {
                        if(snapshot.connectionState == ConnectionState.done){
                          if(snapshot.hasError){
                            return Center(
                              child: Text(
                                '${snapshot.error} occurred'
                              )
                            );
                          }
                          else if(snapshot.hasData){
                            Group group = snapshot.data as Group;
                            return Expanded(
                              child: Column(
                                children: [
                                  //Group title label for the reference to the group.
                                  Container(
                                    child: Text(
                                      'From: ${group.title}',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Mulish',
                                      )
                                    ),
                                  ),
                                  //When the group met. 
                                  Container(
                                    child: Text(
                                      'On ${group.meeting_time.month}/${group.meeting_time.day}/${group.meeting_time.year}'
                                    )
                                  ),
                                  const SizedBox(height: 5),
                                  //Description of the post.
                                  Text(
                                    widget.post.description
                                  )
                                ],
                              )
                            );
                          }
                        }
                        return const Center(
                          child: CircularProgressIndicator()
                        );
                      })
                    )
                  ]
                ),
                //The LikesAndCommentsWidget (see likes_and_comments_widget.dart)
                LikesAndCommentsWidget(
                  likes: widget.post.likesByUid,
                  comments: widget.post.comments,
                  postId: widget.post.postId,
                  currentUser: widget.user
                ),
              ],
            )
          )
        ),
        const SizedBox(height: 20)
      ],
    );
  }
}