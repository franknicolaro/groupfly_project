import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:groupfly_project/services/image_storage_service.dart';
import 'package:groupfly_project/services/repository_service.dart';

import '../../models/Group.dart';
import '../../models/Post.dart';
import '../../models/group_fly_user.dart';
import 'likes_and_comments_widget.dart';

class PostContainer extends StatefulWidget{
  Post post;
  GroupFlyUser user;
  PostContainer({required this.post, required this.user});
  @override
  State<PostContainer> createState() => _PostContainerState();
}

class _PostContainerState extends State<PostContainer>{
  ImageStorageService _storage = ImageStorageService();
  FirebaseStorage fbStorage = FirebaseStorage.instance;
  var imageUrl;
  var groupAsFuture;
  String? url;
  @override
  void initState(){
    super.initState;
    initImageUrl();
    initGroup();
  }
  void initImageUrl() {
      imageUrl = _storage.getImageUrlFromStorage(fbStorage.ref().child(widget.post.imageUrl));
  }
  void initGroup(){
    groupAsFuture = GetIt.instance<RepositoryService>().getGroupByPostReference(widget.post.groupRef);
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Container(
            height: MediaQuery.of(context).size.height * 0.40,
            width: MediaQuery.of(context).size.width * 0.58,
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 17, 127, 171),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Column(
              children: [
                Row(
                  children: [
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
                            return Column(
                              children: [
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
                                Container(
                                  child: Text(
                                    'On ${group.meeting_time.month}/${group.meeting_time.day}/${group.meeting_time.year}'
                                  )
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  widget.post.description
                                )
                              ],
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