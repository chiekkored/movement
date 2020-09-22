import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:movement/customs/movement_custom_icons.dart';
import 'package:movement/models/guestprofile/guestprof_model.dart';
import 'package:movement/pages/guestprofile/views/guestachievementlist_widget.dart';
import 'package:movement/pages/guestprofile/views/guestcrewlist_widget.dart';
import 'package:movement/pages/guestprofile/views/guestfollowbtn_widget.dart';
import 'package:movement/pages/guestprofile/views/guestvideolist_widget.dart';
import 'package:movement/pages/guestprofile/views/guestbio_widget.dart';
import 'package:movement/pages/guestprofile/views/guestcountdata_widget.dart';
import 'package:provider/provider.dart';

class GuestProfilePage extends StatefulWidget {
  final String dpUrl;
  final String userName;
  final String uid;
  final bool isVerified;
  GuestProfilePage(this.uid, this.dpUrl, this.userName, this.isVerified);
  @override
  _GuestProfilePageState createState() => _GuestProfilePageState();
}

class _GuestProfilePageState extends State<GuestProfilePage> {
  CollectionReference followers =
      FirebaseFirestore.instance.collection('followers');
  CollectionReference posts = FirebaseFirestore.instance.collection('posts');

  ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) => GuestProfileModel(),
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(
                Icons.chevron_left,
                size: 22.0,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            backgroundColor: Colors.grey[200],
            shadowColor: Colors.transparent,
            centerTitle: true,
            title: GestureDetector(
              onTap: () => _scrollController.animateTo(0.0,
                  duration: Duration(seconds: 1), curve: Curves.ease),
              child: Text(
                widget.userName,
                style: TextStyle(fontSize: 14.0, color: Colors.black),
              ),
            ),
          ),
          body: SingleChildScrollView(
            controller: _scrollController,
            physics: BouncingScrollPhysics(),
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 6.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CachedNetworkImage(
                          imageUrl: widget.dpUrl,
                          imageBuilder: (context, imageProvider) =>
                              CircleAvatar(
                            radius: 50.0,
                            backgroundImage: imageProvider,
                          ),
                          placeholder: (context, url) => Container(
                            color: Colors.grey,
                          ),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 6.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.userName,
                          style: TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.bold),
                        ),
                        widget.isVerified
                            ? Icon(MovementCustom.verified)
                            : Container()
                      ],
                    ),
                  ),
                  // Follow button widget
                  GuestFollowButton(widget.uid),
                  // User bio widget
                  GuestBio(widget.uid),
                  // Crew list widget
                  GuestCrewList(widget.uid),
                  // Achievement list widget
                  // FOR VERIFIED USERS ONLY ~~~~~~~~~~~~ for future plan
                  // GuestAchievementList(),
                  // User info counts widget
                  GuestCountData(widget.uid),
                  // Video list widget
                  GuestVideoList(widget.uid)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
