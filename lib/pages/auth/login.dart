import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:movement/models/user/user_model.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.clear();
    // If user doesn't exist
    if (!isRegistered.exists) {
      // Call the user's CollectionReference to add a new user
      users
          .doc(user.uid)
          .set({
            'uid': user.uid,
            'display_name': user.displayName,
            'dp_url': user.photoURL,
            'email': user.email,
            'bio': '',
            'phone_number': user.phoneNumber,
            'is_verified': false,
          })
          .then((value) => print('User added'))
          .catchError((error) => print("Failed to add user: $error"));

      prefs.setString('userId', user.uid);
      prefs.setString('displayName', user.displayName);
      prefs.setString('dpUrl', user.photoURL);
      prefs.setString('email', user.email);
      prefs.setString('bio', '');
      prefs.setString('phoneNumber', user.phoneNumber);
      prefs.setBool('isVerified', false);

      // Call the followers's CollectionReference to add a new followers list for user
      // followers
      //     .doc(user.uid)
      //     .collection('followers_list')
      //     .add({})
      //     .then((value) => print("Followers List Added"))
      //     .catchError((error) => print("Failed to add followers: $error"));

      // Call the following's CollectionReference to add a new following list for user
      // following
      //     .doc(user.uid)
      //     .collection('following_list')
      //     .add({})
      //     .then((value) => print("Following List Added"))
      //     .catchError((error) => print("Failed to add following list: $error"));
    } else {
      Map<String, dynamic> _userData = isRegistered.data();
      prefs.setString('userId', _userData['uid']);
      prefs.setString('displayName', _userData['display_name']);
      prefs.setString('dpUrl', _userData['dp_url']);
      prefs.setString('email', _userData['email']);
      prefs.setString('bio', _userData['bio']);
      prefs.setString('phoneNumber', _userData['phone_number']);
      prefs.setBool('isVerified', _userData['is_verified']);
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
              )),
          Positioned(
            bottom: 100,
            child: Text(context.watch<UserModel>().displayName ?? 'null'),
          ),
        ],
      ),
    );
  }
}
