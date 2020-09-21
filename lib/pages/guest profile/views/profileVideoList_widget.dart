import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProfileVideoList extends StatefulWidget {
  final String uid;
  ProfileVideoList(this.uid);

  @override
  ProfileVideoListState createState() => ProfileVideoListState();
}

class ProfileVideoListState extends State<ProfileVideoList> {
  CollectionReference posts = FirebaseFirestore.instance.collection('posts');

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FutureBuilder(
            future: posts.doc(widget.uid).collection('post_data').get(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
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
                return Container();
              }
            })
      ],
    );
  }
}
