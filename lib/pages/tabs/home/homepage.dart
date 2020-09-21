import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:cached_video_player/cached_video_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:inview_notifier_list/inview_notifier_list.dart';
import 'package:mobx/mobx.dart';
import 'package:movement/models/home/home_model.dart';
import 'package:movement/customs/movement_custom_icons.dart';
import 'package:movement/pages/tabs/home/views/buttonFeed_widget.dart';
import 'package:movement/pages/tabs/home/views/descriptionFeed_widget.dart';
import 'package:movement/pages/tabs/home/views/header_widget.dart';
import 'package:movement/pages/tabs/home/views/profileFeed_widget.dart';
import 'package:movement/pages/tabs/home/views/videoFeed_widget.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  User _user = FirebaseAuth.instance.currentUser;
  final HomeModel _homemodel = HomeModel();

  // Function to refresh feed
  Future<void> _refreshFeed() async {
    // Delay .5 seconds to give justice to loading animation
    Future.delayed(const Duration(milliseconds: 500), () {
      // Fetch feed from HomeModel() Future bloc
      _homemodel.fetchFeed();
    });
  }

  @override
  void initState() {
    // When state starts, fetch feed from HomeModel() Future bloc
    _homemodel.fetchFeed();
    super.initState();
  }

  ScrollController scroll = ScrollController();
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      children: [
        // Header View
        TitleView(),
        // Feed Item
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            // Observer for new future feed list
            child: Observer(
              // ignore: missing_return
              builder: (_) {
                final List<DocumentSnapshot> _feedItems =
                    _homemodel.feedItemsFuture.result;
                switch (_homemodel.feedItemsFuture.status) {
                  // If observerfuture is still pending
                  case FutureStatus.pending:
                    print('loading');
                    return Container();

                  // If observerfuture gets error or rejected
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

                  // If observerfuture is success
                  case FutureStatus.fulfilled:
                    return RefreshIndicator(
                      onRefresh: _refreshFeed,
                      // Same as ListView builder
                      child: InViewNotifierList(
                        // Controller used to go back to top from landingpage button
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
                              // Row of buttons
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
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12.0),
                                        child: ButtonFeed(
                                            _feedItem['upload_date'])),
                                  ),
                                ),
                              ),
                              // Video Widget
                              Padding(
                                padding:
                                    EdgeInsets.only(top: 10.0, bottom: 110.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Container(
                                    child: Stack(
                                      children: [
                                        LayoutBuilder(
                                          builder: (BuildContext context,
                                              BoxConstraints constraints) {
                                            // When user is in view, called this notifier
                                            return InViewNotifierWidget(
                                              id: '$index',
                                              builder: (BuildContext context,
                                                  bool isInView, Widget child) {
                                                // Pass false value from HomeModel Provider if homepage is not in view
                                                return Observer(
                                                  builder: (_) {
                                                    return VideoFeed(
                                                      play: (Provider.of<
                                                                      HomeModel>(
                                                                  context)
                                                              .isHomeVisible)
                                                          ? isInView
                                                          : Provider.of<
                                                                      HomeModel>(
                                                                  context)
                                                              .isHomeVisible,
                                                      url: _feedItem[
                                                          'video_url'],
                                                    );
                                                  },
                                                );
                                              },
                                            );
                                          },
                                        ),
                                        // Description row
                                        Positioned(
                                          bottom: 10.0,
                                          left: 0.0,
                                          right: 0.0,
                                          child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 12.0),
                                              child: DescriptionFeed(
                                                  _feedItem['description'])),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              // User posted the feed item row
                              Positioned(
                                  top: 20.0,
                                  left: 10.0,
                                  child: ProfileFeed(
                                      _feedItem['dp_url'],
                                      _feedItem['user_name'],
                                      _feedItem['uid'],
                                      _feedItem['is_verified']))
                            ],
                          );
                        },
                      ),
                    );
                }
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
