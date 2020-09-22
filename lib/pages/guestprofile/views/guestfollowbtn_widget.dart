import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:movement/models/guestprofile/guestprof_model.dart';
import 'package:provider/provider.dart';

class GuestFollowButton extends StatefulWidget {
  final String uid;
  GuestFollowButton(this.uid);

  @override
  _GuestFollowButtonState createState() => _GuestFollowButtonState();
}

class _GuestFollowButtonState extends State<GuestFollowButton> {
  final _guestProfileModel = GuestProfileModel();

  CollectionReference following =
      FirebaseFirestore.instance.collection('following');
  CollectionReference follower =
      FirebaseFirestore.instance.collection('followers');

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
              color: Colors.grey,
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
                onPressed: () {
                  try {
                    following
                        .doc(_user.uid)
                        .collection('following_list')
                        .doc(widget.uid)
                        .set({
                      'uid': widget.uid,
                      'following_date': Timestamp.now()
                    });
                    follower
                        .doc(widget.uid)
                        .collection('followers_list')
                        .doc(_user.uid)
                        .set({
                      'uid': _user.uid,
                      'follower_date': Timestamp.now()
                    });
                    context.read<GuestProfileModel>().addfollowerCount();
                    setState(() {});
                  } catch (e) {
                    print(e);
                  }
                },
                child: Text(
                  'Follow',
                  style: TextStyle(color: Colors.white),
                ),
              );
            } else {
              return OutlineButton(
                borderSide: BorderSide(color: Colors.red),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                onPressed: () {
                  try {
                    following
                        .doc(_user.uid)
                        .collection('following_list')
                        .doc(widget.uid)
                        .delete();
                    follower
                        .doc(widget.uid)
                        .collection('followers_list')
                        .doc(_user.uid)
                        .delete();
                    context.read<GuestProfileModel>().subtractfollowerCount();
                    setState(() {});
                  } catch (e) {
                    print(e);
                  }
                },
                child: Text(
                  'Unfollow',
                  style: TextStyle(color: Colors.red),
                ),
              );
            }
          }
        });
  }
}
