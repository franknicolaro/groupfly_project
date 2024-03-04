import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:groupfly_project/DAOs/FriendDAO.dart';
import 'package:groupfly_project/DAOs/HobbyDAO.dart';
import 'package:groupfly_project/DAOs/UserDAO.dart';
import 'package:groupfly_project/models/group_fly_user.dart';
import 'package:groupfly_project/repositories/FriendRepo.dart';
import 'package:groupfly_project/repositories/GroupRepo.dart';
import 'package:groupfly_project/repositories/HobbyRepo.dart';
import 'package:groupfly_project/repositories/UserRepo.dart';
import 'package:groupfly_project/services/authorization_service.dart';
import 'package:groupfly_project/controller_selector.dart';
import 'package:groupfly_project/services/repository_service.dart';
import 'package:provider/provider.dart';
import 'package:get_it/get_it.dart';

import 'DAOs/GroupDAO.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,);
  GetIt.instance.registerLazySingleton<RepositoryService>(() => RepositoryServiceImpl());
  GetIt.instance.registerLazySingleton<UserDao>(() => UserRepo());
  GetIt.instance.registerLazySingleton<HobbyDao>(() => HobbyRepo());
  GetIt.instance.registerLazySingleton<FriendDao>(() => FriendRepo());
  GetIt.instance.registerLazySingleton<GroupDao>(() => GroupRepo());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //Initialize Firebase here.
        /*
        // Import the functions you need from the SDKs you need
        import { initializeApp } from "firebase/app";
        import { getAnalytics } from "firebase/analytics";
        // TODO: Add SDKs for Firebase products that you want to use
        // https://firebase.google.com/docs/web/setup#available-libraries

        // Your web app's Firebase configuration
        // For Firebase JS SDK v7.20.0 and later, measurementId is optional
        const firebaseConfig = {
          apiKey: "AIzaSyBh6-v_Es-2lzOza_yLmsQu_mkb-3FQOgc",
          authDomain: "groupfly-a90ae.firebaseapp.com",
          projectId: "groupfly-a90ae",
          storageBucket: "groupfly-a90ae.appspot.com",
          messagingSenderId: "1026053522641",
          appId: "1:1026053522641:web:fd9695400a1e6bc024f1f0",
          measurementId: "G-RYVM2H3TF5"
        };*/
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