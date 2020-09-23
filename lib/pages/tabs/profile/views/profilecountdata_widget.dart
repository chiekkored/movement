import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:movement/models/user/user_model.dart';
import 'package:provider/provider.dart';

class ProfileCountData extends StatefulWidget {
  @override
  _ProfileCountDataState createState() => _ProfileCountDataState();
}

class _ProfileCountDataState extends State<ProfileCountData> {
  User _user = FirebaseAuth.instance.currentUser;
  CollectionReference posts = FirebaseFirestore.instance.collection('posts');
  CollectionReference followers =
      FirebaseFirestore.instance.collection('followers');
  CollectionReference following =
      FirebaseFirestore.instance.collection('following');

  @override
  Widget build(BuildContext context) {
    // var userModelRead = context.watch<UserModel>();
    return Container(
      margin: EdgeInsets.all(12.0),
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0), color: Colors.white),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                FutureBuilder(
                    future: posts.doc(_user.uid).collection('post_data').get(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.hasData) {
                          return Text(
                            snapshot.data.docs.length.toString(),
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20.0),
                          );
                        } else {
                          return Text(
                            '0',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20.0),
                          );
                        }
                      } else {
                        return Container();
                      }
                    }),
                Text(
                  'Videos',
                  style: TextStyle(fontSize: 12.0),
                )
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                FutureBuilder(
                    future: followers
                        .doc(_user.uid)
                        .collection('followers_list')
                        .get(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.hasData) {
                          return Text(
                            snapshot.data.docs.length.toString(),
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20.0),
                          );
                        } else {
                          return Text(
                            '0',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20.0),
                          );
                        }
                      } else {
                        return Container();
                      }
                    }),
                Text(
                  'Followers',
                  style: TextStyle(fontSize: 12.0),
                )
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                FutureBuilder(
                    future: following
                        .doc(_user.uid)
                        .collection('following_list')
                        .get(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.hasData) {
                          return Text(
                            snapshot.data.docs.length.toString(),
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20.0),
                          );
                        } else {
                          return Text(
                            '0',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20.0),
                          );
                        }
                      } else {
                        return Container();
                      }
                    }),
                Text(
                  'Following',
                  style: TextStyle(fontSize: 12.0),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
