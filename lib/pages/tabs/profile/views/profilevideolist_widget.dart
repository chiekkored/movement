import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:movement/models/user/user_model.dart';
import 'package:provider/provider.dart';

class ProfileVideoList extends StatefulWidget {
  @override
  _ProfileVideoListState createState() => _ProfileVideoListState();
}

class _ProfileVideoListState extends State<ProfileVideoList> {
  User _user = FirebaseAuth.instance.currentUser;
  CollectionReference posts = FirebaseFirestore.instance.collection('posts');

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        StreamBuilder(
            stream: posts.doc(_user.uid).collection('post_data').snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Container();
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container();
              }
              if (snapshot.data.docs.length > 0) {
                List<QueryDocumentSnapshot> data = snapshot.data.docs;
                return GridView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3),
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) => CachedNetworkImage(
                    imageUrl: data[index].data()['thumbnail'],
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    placeholder: (context, url) => Container(
                      color: Colors.grey,
                    ),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                );
              } else {
                return Text('aaa');
              }
            })
      ],
    );
  }
}
