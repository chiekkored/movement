import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserCountData extends StatefulWidget {
  final String uid;
  UserCountData(this.uid);

  @override
  _UserCountDataState createState() => _UserCountDataState();
}

class _UserCountDataState extends State<UserCountData> {
  CollectionReference posts = FirebaseFirestore.instance.collection('posts');
  CollectionReference followers =
      FirebaseFirestore.instance.collection('followers');
  CollectionReference following =
      FirebaseFirestore.instance.collection('following');

  @override
  Widget build(BuildContext context) {
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
                    future: posts.doc(widget.uid).collection('post_data').get(),
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
                        .doc(widget.uid)
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
                        .doc(widget.uid)
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
