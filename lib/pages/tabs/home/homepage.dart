import 'package:flutter/material.dart';
import 'package:cached_video_player/cached_video_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:inview_notifier_list/inview_notifier_list.dart';
import 'package:mobx/mobx.dart';
import 'package:movement/models/home/home_model.dart';
import 'package:movement/movement_custom_icons.dart';
import 'package:movement/pages/tabs/home/views/title.dart';
import 'package:movement/pages/tabs/home/views/videofeed.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  User _user = FirebaseAuth.instance.currentUser;
  final HomeModel _homemodel = HomeModel();

  Future<void> _refreshFeed() async {
    Future.delayed(const Duration(milliseconds: 500), () {
      _homemodel.fetchFeed();
    });
  }

  @override
  void initState() {
    _homemodel.fetchFeed();
    super.initState();
  }

  ScrollController scroll = ScrollController();
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      children: [
        TitleView(),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Observer(
              builder: (_) {
                final List<DocumentSnapshot> _feedItems =
                    _homemodel.feedItemsFuture.result;
                switch (_homemodel.feedItemsFuture.status) {
                  case FutureStatus.pending:
                    print('loading');
                    return Container();

                  case FutureStatus.rejected:
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        FlatButton(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onPressed: () {},
                          child: Center(child: Icon(Icons.refresh)),
                        ),
                        Text(
                          'Loading Feed Failed',
                          style: TextStyle(color: Colors.black),
                        ),
                      ],
                    );

                  case FutureStatus.fulfilled:
                    return RefreshIndicator(
                      onRefresh: _refreshFeed,
                      child: InViewNotifierList(
                        controller: context.read<HomeModel>().scrollController,
                        physics: BouncingScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        initialInViewIds: ['0'],
                        isInViewPortCondition: (double deltaTop,
                            double deltaBottom, double viewPortDimension) {
                          return deltaTop < (0.5 * viewPortDimension) &&
                              deltaBottom > (0.5 * viewPortDimension) - 100.0;
                        },
                        shrinkWrap: true,
                        itemCount: _feedItems.length,
                        builder: (_, index) {
                          Map<String, dynamic> _feedItem =
                              _feedItems[index].data();
                          return Stack(
                            children: [
                              Positioned(
                                bottom: 110.0,
                                child: Transform.translate(
                                  offset: const Offset(-0.4, 60.0),
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
                                    child: Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            width: 150.0,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                Container(
                                                  height: 40.0,
                                                  child: Icon(
                                                    MovementCustom.clap_fill,
                                                    color: Colors.grey[400],
                                                    size: 24.0,
                                                  ),
                                                ),
                                                Container(
                                                  height: 40.0,
                                                  child: Icon(
                                                    Icons.chat_bubble,
                                                    color: Colors.grey[400],
                                                    size: 24.0,
                                                  ),
                                                ),
                                                Container(
                                                  height: 40.0,
                                                  child: Icon(
                                                    Icons.camera_roll,
                                                    color: Colors.grey[400],
                                                    size: 24.0,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            height: 40.0,
                                            child: Icon(
                                              Icons.more_horiz,
                                              color: Colors.grey[400],
                                              size: 24.0,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
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
                                            // Pass false value from HomeModel Provider if homepage is not in view
                                            return Observer(
                                              builder: (_) {
                                                return VideoFeed(
                                                  play: (Provider.of<HomeModel>(
                                                              context)
                                                          .isHomeVisible)
                                                      ? isInView
                                                      : Provider.of<HomeModel>(
                                                              context)
                                                          .isHomeVisible,
                                                  url: _feedItem['video_url'],
                                                );
                                              },
                                            );
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
                                                  blurRadius: 1.0,
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
                }
                return Container(
                  height: 0.0,
                  width: 0.0,
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
