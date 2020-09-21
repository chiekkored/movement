import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CrewList extends StatefulWidget {
  final String uid;
  CrewList(this.uid);

  @override
  _CrewListState createState() => _CrewListState();
}

class _CrewListState extends State<CrewList> {
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: users.doc(widget.uid).collection('crew_list').get(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            List<QueryDocumentSnapshot> data = snapshot.data.docs;
            return ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: data.length,
                itemBuilder: (_, index) {
                  Map<String, dynamic> _crew = data[index].data();
                  return Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.0),
                        child: ListTile(
                          dense: true,
                          visualDensity: VisualDensity.compact,
                          leading: CachedNetworkImage(
                            imageUrl: _crew['dp_url'],
                            imageBuilder: (context, imageProvider) =>
                                CircleAvatar(
                              radius: 18.0,
                              backgroundImage: imageProvider,
                            ),
                            placeholder: (context, url) => Container(
                              color: Colors.grey,
                            ),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          ),
                          title: Text(_crew['crew_name']),
                          subtitle: Text(_crew['position']),
                          trailing: Icon(Icons.chevron_right),
                        ),
                      ),
                    ],
                  );
                });
          }
          return Container();
        });
  }
}
