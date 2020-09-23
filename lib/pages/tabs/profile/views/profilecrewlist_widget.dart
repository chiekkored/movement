import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:movement/models/user/user_model.dart';
import 'package:provider/provider.dart';

class ProfileCrewList extends StatefulWidget {
  @override
  _ProfileCrewListState createState() => _ProfileCrewListState();
}

class _ProfileCrewListState extends State<ProfileCrewList> {
  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    return StreamBuilder(
        stream: users
            .doc(context.watch<UserModel>().userId)
            .collection('crew_list')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Container();
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container();
          }
          if (snapshot.data.size > 0) {
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
          } else {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'No Crew',
                    style: TextStyle(color: Colors.grey, fontSize: 12.0),
                  ),
                  Text(
                    'Add Crews Now',
                    style: TextStyle(color: Colors.blue, fontSize: 12.0),
                  ),
                ],
              ),
            );
          }
        });
  }
}
