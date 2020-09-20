import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  // Global Scaffold Key for snackbar
  final globalScaffoldKey = GlobalKey<ScaffoldState>();

  // Create a CollectionReference called users that references the firestore collection
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  // Create a CollectionReference called users that references the firestore collection
  CollectionReference followers =
      FirebaseFirestore.instance.collection('followers');
  // Create a CollectionReference called users that references the firestore collection
  CollectionReference following =
      FirebaseFirestore.instance.collection('following');

  Future<UserCredential> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount googleUser = await GoogleSignIn()
          .signIn()
          .catchError((onError) => print('Error g-signin: ' + onError));

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final GoogleAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Once signed in, return the UserCredential
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      print(e);
    }
  }

  Future<void> isUserInFirestore(User user) async {
    // Try get user data in Firestore
    DocumentSnapshot isRegistered = await users.doc(user.uid).get();

    // If user doesn't exist
    if (!isRegistered.exists) {
      // Call the user's CollectionReference to add a new user
      users
          .doc(user.uid)
          .set({
            'uid': user.uid,
            'full_name': user.displayName,
            'email': user.email,
            'phone_number': user.phoneNumber,
            'user_email': user.email,
          })
          .then((value) => print("User Added"))
          .catchError((error) => print("Failed to add user: $error"));

      // Call the followers's CollectionReference to add a new followers list for user
      // followers
      //     .doc(user.uid)
      //     .collection('followers_list')
      //     .add({})
      //     .then((value) => print("Followers List Added"))
      //     .catchError((error) => print("Failed to add followers: $error"));

      // Call the following's CollectionReference to add a new followers list for user
      // following
      //     .doc(user.uid)
      //     .collection('following_list')
      //     .add({})
      //     .then((value) => print("Following List Added"))
      //     .catchError((error) => print("Failed to add following list: $error"));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: globalScaffoldKey,
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          // Image.asset(
          //   "images/bg.jpg",
          //   height: MediaQuery.of(context).size.height,
          //   width: MediaQuery.of(context).size.width,
          //   fit: BoxFit.cover,
          // ),
          Positioned(
              bottom: 10,
              child: SignInButton(
                Buttons.Google,
                onPressed: () {
                  signInWithGoogle()
                      .then((value) => isUserInFirestore(value.user));
                },
              ))
        ],
      ),
    );
  }
}
