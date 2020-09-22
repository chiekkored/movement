import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:movement/customs/movement_custom_icons.dart';
import 'package:movement/models/user/user_model.dart';
import 'package:movement/pages/tabs/profile/views/profilebio_widget.dart';
import 'package:movement/pages/tabs/profile/views/profilecountdata_widget.dart';
import 'package:movement/pages/tabs/profile/views/profilecrewlist_widget.dart';
import 'package:movement/pages/tabs/profile/views/profilesettingsbtns_widget.dart';
import 'package:movement/pages/tabs/profile/views/profilevideolist_widget.dart';
import 'package:provider/provider.dart';

class MyProfilePage extends StatefulWidget {
  @override
  _MyProfilePageState createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  ScrollController _scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    // var userModelRead = context.read<UserModel>();
    // var userModelWatch = context.watch<UserModel>();

    return SingleChildScrollView(
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
                  // CachedNetworkImage(
                  //   imageUrl: context.watch<UserModel>().dpUrl,
                  //   imageBuilder: (context, imageProvider) => CircleAvatar(
                  //     radius: 50.0,
                  //     backgroundImage: imageProvider,
                  //   ),
                  //   placeholder: (context, url) => Container(
                  //     color: Colors.grey,
                  //   ),
                  //   errorWidget: (context, url, error) => Icon(Icons.error),
                  // ),
                ],
              ),
            ),
            // Container(
            //   padding: EdgeInsets.symmetric(vertical: 6.0),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: [
            //       Text(
            //         context.watch<UserModel>().displayName,
            //         style:
            //             TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            //       ),
            //       context.watch<UserModel>().isVerified
            //           ? Icon(MovementCustom.verified)
            //           : Container()
            //     ],
            //   ),
            // ),
            // Settings buttons widget
            ProfileSettingsButtons(),

            // User bio widget
            ProfileBio(),

            // Crew list widget
            ProfileCrewList(),

            // Achievement list widget
            // FOR VERIFIED USERS ONLY ~~~~~~~~~~~~ for future plan
            // AchievementList(),

            // User info counts widget
            ProfileCountData(),

            // Video list widget
            ProfileVideoList()
          ],
        ),
      ),
    );
  }
}
