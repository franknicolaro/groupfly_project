import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:groupfly_project/DAOs/FriendDAO.dart';
import 'package:groupfly_project/DAOs/HobbyDAO.dart';
import 'package:groupfly_project/DAOs/NotificationDAO.dart';
import 'package:groupfly_project/DAOs/UserDAO.dart';
import 'package:groupfly_project/models/group_fly_user.dart';
import 'package:groupfly_project/repositories/FriendRepo.dart';
import 'package:groupfly_project/repositories/GroupRepo.dart';
import 'package:groupfly_project/repositories/HobbyRepo.dart';
import 'package:groupfly_project/repositories/NotificationRepo.dart';
import 'package:groupfly_project/repositories/PostRepo.dart';
import 'package:groupfly_project/repositories/UserRepo.dart';
import 'package:groupfly_project/services/authorization_service.dart';
import 'package:groupfly_project/controller_selector.dart';
import 'package:groupfly_project/services/repository_service.dart';
import 'package:provider/provider.dart';
import 'package:get_it/get_it.dart';

import 'DAOs/GroupDAO.dart';
import 'DAOs/PostDAO.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //Initialize Firebase to ensure that data can be read and written from Firebase.
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,);

  //Registration of lazy singletons to utilize within the repository service.
  GetIt.instance.registerLazySingleton<RepositoryService>(() => RepositoryServiceImpl());
  GetIt.instance.registerLazySingleton<UserDao>(() => UserRepo());
  GetIt.instance.registerLazySingleton<HobbyDao>(() => HobbyRepo());
  GetIt.instance.registerLazySingleton<FriendDao>(() => FriendRepo());
  GetIt.instance.registerLazySingleton<GroupDao>(() => GroupRepo());
  GetIt.instance.registerLazySingleton<PostDao>(() => PostRepo());
  GetIt.instance.registerLazySingleton<NotificationDao>(() => NotificationRepo());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    //Provide a StreamProvider into the build method which holds
    //information about the user and is utilized in the ControllerSelecter.
    return StreamProvider<GroupFlyUser?>.value(
      catchError: (_,__) => null,
      value: Authorization().user,
      initialData: null,
      child: MaterialApp(
        title: "GroupFly",
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        home: ControllerSelector()
      )
    );
  }
}