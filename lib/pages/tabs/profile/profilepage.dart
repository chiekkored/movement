import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
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
  final UserModel _userModel = UserModel();

  ScrollController _scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    // var userModelRead = context.read<UserModel>();
    // var userModelWatch = context.watch<UserModel>();

    return SingleChildScrollView(
      controller: _scrollController,
      physics: BouncingScrollPhysics(),
      child: Container(
        margin: EdgeInsets.only(top: 30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FutureBuilder(
              future: _userModel.getDpUrl(),
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) =>
                  snapshot.hasData
                      ? Container(
                          padding: EdgeInsets.symmetric(vertical: 6.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CachedNetworkImage(
                                imageUrl: snapshot.data,
                                imageBuilder: (context, imageProvider) =>
                                    CircleAvatar(
                                  radius: 50.0,
                                  backgroundImage: imageProvider,
                                ),
                                placeholder: (context, url) => CircleAvatar(
                                  radius: 50.0,
                                  backgroundColor: Colors.grey[300],
                                ),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                              )
                            ],
                          ),
                        )
                      : Container(),
            ),
            FutureBuilder(
              future: _userModel.getDisplayName(),
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) =>
                  snapshot.hasData
                      ? Container(
                          padding: EdgeInsets.symmetric(vertical: 6.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                snapshot.data,
                                style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              FutureBuilder(
                                future: _userModel.getIsVerified(),
                                builder: (BuildContext context,
                                        AsyncSnapshot<bool> snapshot) =>
                                    snapshot.hasData
                                        ? snapshot.data
                                            ? Icon(MovementCustom.verified)
                                            : Container()
                                        : Container(),
                              )
                            ],
                          ),
                        )
                      : Container(),
            ),
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
