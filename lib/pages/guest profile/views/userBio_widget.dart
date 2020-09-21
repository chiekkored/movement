import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserBio extends StatelessWidget {
  final String uid;
  UserBio(this.uid);
  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    return FutureBuilder(
        future: users.doc(uid).get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data = snapshot.data.data();
            return Container(
              padding: EdgeInsets.symmetric(vertical: 6.0),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.0),
                child: Text(
                  data['bio'],
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12.0),
                ),
              ),
            );
          }
          return Container();
        });
  }
}
