import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FollowButton extends StatefulWidget {
  final String uid;
  FollowButton(this.uid);

  @override
  _FollowButtonState createState() => _FollowButtonState();
}

class _FollowButtonState extends State<FollowButton> {
  CollectionReference following =
      FirebaseFirestore.instance.collection('following');

  User _user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: following
            .doc(_user.uid)
            .collection('following_list')
            .doc(widget.uid)
            .get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return FlatButton(
              color: Colors.black,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              onPressed: () {},
              child: Text(
                'Loading',
                style: TextStyle(color: Colors.white),
              ),
            );
          } else {
            if (!snapshot.data.exists) {
              return FlatButton(
                color: Colors.black,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                onPressed: () {},
                child: Text(
                  'Follow',
                  style: TextStyle(color: Colors.white),
                ),
              );
            } else {
              return FlatButton(
                color: Colors.black,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                onPressed: () {},
                child: Text(
                  'Following',
                  style: TextStyle(color: Colors.white),
                ),
              );
            }
          }
        });
  }
}
