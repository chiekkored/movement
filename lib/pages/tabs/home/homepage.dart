import 'package:flutter/material.dart';
import 'package:cached_video_player/cached_video_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:inview_notifier_list/inview_notifier_list.dart';
import 'package:movement/pages/tabs/home/views/title.dart';
import 'package:movement/pages/tabs/home/views/videofeed.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<List<DocumentSnapshot>> _getFeed;
  User _user = FirebaseAuth.instance.currentUser;

  CachedVideoPlayerController _videoPlayerController;

  @override
  void initState() {
    _getFeed = getFeed(); // only create the future once.
    super.initState();
  }

  Future<List<DocumentSnapshot>> getFeed() async {
    var firestore = FirebaseFirestore.instance;
    QuerySnapshot posts = await firestore
        .collection("posts")
        .doc(_user.uid)
        .collection("post_data")
        .get();
    return posts.docs;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TitleView(),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: FutureBuilder(
                future: _getFeed,
                builder: (_, AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Something went wrong');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    print('Loading');
                    return Container();
                  }
                  if (snapshot.hasData) {
                    return RefreshIndicator(
                      onRefresh: getFeed,
                      child: InViewNotifierList(
                        addAutomaticKeepAlives: false,
                        physics: BouncingScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        initialInViewIds: ['0'],
                        isInViewPortCondition: (double deltaTop,
                            double deltaBottom, double viewPortDimension) {
                          return deltaTop < (0.5 * viewPortDimension) &&
                              deltaBottom > (0.5 * viewPortDimension) - 100.0;
                        },
                        shrinkWrap: true,
                        itemCount: snapshot.data.length,
                        builder: (_, index) {
                          Map<String, dynamic> _feedItem =
                              snapshot.data[index].data();
                          return Stack(
                            children: [
                              Positioned(
                                bottom: 110.0,
                                child: Transform.translate(
                                  offset: const Offset(0.0, 70.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(20.0),
                                            bottomRight:
                                                Radius.circular(20.0))),
                                    height: 80.0,
                                    width:
                                        MediaQuery.of(context).size.width - 24,
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    EdgeInsets.only(top: 10.0, bottom: 110.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Container(
                                    child: LayoutBuilder(
                                      builder: (BuildContext context,
                                          BoxConstraints constraints) {
                                        return InViewNotifierWidget(
                                          id: '$index',
                                          builder: (BuildContext context,
                                              bool isInView, Widget child) {
                                            return VideoFeed(
                                                play: isInView,
                                                url: _feedItem['video_url']);
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                  top: 20.0,
                                  left: 10.0,
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 15.0,
                                        backgroundImage:
                                            NetworkImage(_feedItem['dp_url']),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: Text(
                                          _feedItem['user_name'],
                                          style: TextStyle(
                                              color: Colors.white,
                                              shadows: <Shadow>[
                                                Shadow(
                                                  offset: Offset(0.0, 0.5),
                                                  blurRadius: 3.0,
                                                  color: Color.fromARGB(
                                                      255, 0, 0, 0),
                                                )
                                              ]),
                                        ),
                                      )
                                    ],
                                  ))
                            ],
                          );
                        },
                      ),
                    );
                  } else {
                    // If there's NO feed to show
                    return Text('No data');
                  }
                }),
          ),
        ),
      ],
    );
  }
}
