import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:movement/models/addpost/addpost_model.dart';
import 'package:movement/models/home/home_model.dart';
import 'package:movement/models/user/user_model.dart';
import 'package:provider/provider.dart';

import 'package:movement/pages/auth/login.dart';
import 'pages/landingpage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(providers: [
    Provider<AddPostModel>(create: (_) => AddPostModel()),
    Provider<HomeModel>(create: (_) => HomeModel()),
    Provider<UserModel>(create: (_) => UserModel()),
    StreamProvider<User>.value(value: FirebaseAuth.instance.authStateChanges()),
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // routes: {
      //   '/preview': (BuildContext context) => preview,
      //   '/trim': (BuildContext context) =>
      //       trimVideo, // Home() X => Causing the problem !!!!,
      //   '/upload': (BuildContext context) =>
      //       uploadVideo // Taking the final variable (ok),
      // },
      title: 'Movement',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          visualDensity: VisualDensity.adaptivePlatformDensity,
          scaffoldBackgroundColor: Colors.grey[200]),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, AsyncSnapshot<User> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data != null) {
              return LandingPage();
            } else {
              return Login();
            }
          }
          return Login();
        },
      ),
    );
  }
}

// For Dark Mode future purposes
// theme: ThemeData.dark().copyWith(
//     visualDensity: VisualDensity.adaptivePlatformDensity,
//     scaffoldBackgroundColor: Colors.grey[200]),
