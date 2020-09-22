import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ProfileSettingsButtons extends StatefulWidget {
  @override
  _ProfileSettingsButtonsState createState() => _ProfileSettingsButtonsState();
}

class _ProfileSettingsButtonsState extends State<ProfileSettingsButtons> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FlatButton(
          color: Colors.grey,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          onPressed: () {},
          child: Text(
            'Edit Profile',
            style: TextStyle(color: Colors.white),
          ),
        ),
        FlatButton(
          color: Colors.grey,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          onPressed: () {
            _googleSignIn.signOut();
            _auth.signOut();
          },
          child: Text(
            'Logout',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
