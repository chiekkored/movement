import 'dart:io';

import 'package:animated_icon_button/animated_icon_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movement/models/addpost/addpost_model.dart';
import 'package:movement/pages/tabs/addpost/preview.dart';
import 'package:movement/pages/tabs/home/homepage.dart';
import 'package:movement/pages/tabs/notification/notificationpage.dart';
import 'package:movement/pages/tabs/profile/profilepage.dart';
import 'package:movement/pages/tabs/search/searchpage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage>
    with TickerProviderStateMixin {
  // List of bottom navigation pages
  List<Widget> _pages = [
    HomePage(),
    SearchPage(),
    NotificationPage(),
    ProfilePage()
  ];

  // FFMPEG controller for uploading and statistics
  final FlutterFFmpeg _flutterFFmpeg = FlutterFFmpeg();
  final FlutterFFmpegConfig _flutterFFmpegConfig = FlutterFFmpegConfig();

  // Global Scaffold Key for snackbar
  final globalScaffoldKey = GlobalKey<ScaffoldState>();

  // Animation controller for adding and cancelling upload
  AnimationController _animationController;
  // If uploading is true, cancel button; If not, open preview page
  bool _isUploading = false;

  // Function to upload video
  Future<void> _uploadVideo(String inputPath) async {
    // getApplicationDocumentsDirectory or getExternalStorageDirectory
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;
    String outputPath = appDocPath +
        '/' +
        Timestamp.now().millisecondsSinceEpoch.toString() +
        '.mp4';
    _flutterFFmpegConfig.enableStatisticsCallback(
        context.read<AddPostModel>().uploadstatisticsCallback);
    await _flutterFFmpeg
        .execute(
            "-y -i '$inputPath' -max_muxing_queue_size 9999 -c:v libx264 -crf 28 -r 23 -preset superfast -filter:v 'fps=fps=23' -c:a copy $outputPath")
        .then((rc) async {
      if (rc == 0) {
        // Upload file to Storage
        var storage = FirebaseStorage.instance;
        User user = FirebaseAuth.instance.currentUser;
        StorageTaskSnapshot video_snapshot = await storage
            .ref()
            .child("posts/${user.uid}/videos/" +
                Timestamp.now().millisecondsSinceEpoch.toString() +
                '.mp4')
            .putFile(File(outputPath))
            .onComplete;

        StorageTaskSnapshot thumb_snapshot = await storage
            .ref()
            .child("posts/${user.uid}/thumb/" +
                Timestamp.now().millisecondsSinceEpoch.toString() +
                '.jpg')
            .putFile(context.read<AddPostModel>().uploadThumbnail)
            .onComplete;
        // Upload to Firestore
        String vid_url = await video_snapshot.ref.getDownloadURL();
        String thumb_url = await thumb_snapshot.ref.getDownloadURL();
        print(video_snapshot.ref.getDownloadURL());
        FirebaseFirestore.instance
            .collection('posts/${user.uid}/post_data')
            .add({
          'uid': user.uid,
          'user_name': user.displayName,
          'dp_url': user.photoURL,
          'video_url': vid_url,
          'description': context.read<AddPostModel>().uploadDescription,
          'aspect_ratio': context.read<AddPostModel>().uploadAspectRatio,
          'thumbnail': thumb_url,
          'upload_date': Timestamp.now()
        }).catchError((error) => print("Failed to add user: $error"));
        context.read<AddPostModel>().uploadProgress = null;
        // Reverse X button
        _animationController.reverse();
        // Reset listening variables to null and 0
        context.read<AddPostModel>().resetUpload();
        // Delete file after upload
        final dir = File(outputPath);
        dir.delete();
      } else if (rc == 1) {
        _animationController.reverse();
        context.read<AddPostModel>().resetUpload();
        // Show snackbar that there's an error in upload
        globalScaffoldKey.currentState.showSnackBar(
            SnackBar(content: Text("Upload error. Please try again.")));
      } else {
        // If ffmpeg is cancelled
        _animationController.reverse();
        context.read<AddPostModel>().resetUpload();
      }

      _isUploading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
      reverseDuration: Duration(milliseconds: 200),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      initialIndex: 0,
      child: Scaffold(
        key: globalScaffoldKey,
        // appBar: AppBar(
        //   centerTitle: true,
        //   backgroundColor: Colors.white,
        //   title: Center(
        //       child: Text('Movement',
        //           style: GoogleFonts.leckerliOne(
        //               color: Colors.black, fontSize: 26.0))),
        // ),
        body: SafeArea(
          child: TabBarView(
              physics: NeverScrollableScrollPhysics(), children: _pages),
        ),
        bottomNavigationBar: BottomAppBar(
            shape: const CircularNotchedRectangle(),
            child: Theme(
              data: ThemeData(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent),
              child: TabBar(
                indicatorColor: Colors.transparent,
                tabs: [
                  Tab(
                    icon: Icon(Icons.home),
                  ),
                  Container(
                    padding: EdgeInsets.only(right: 40.0),
                    child: Tab(
                      icon: Icon(Icons.search),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 40.0),
                    child: Tab(
                      iconMargin: EdgeInsets.only(left: 20.0),
                      icon: Icon(Icons.notifications),
                    ),
                  ),
                  Tab(
                    icon: Icon(Icons.person),
                  ),
                ],
                unselectedLabelColor: Colors.grey[400],
                labelColor: Colors.black,
                labelStyle: TextStyle(fontSize: 50.0),
              ),
            )),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.white,
          onPressed: () {
            // Cancel functionality if there's ongoing upload
            if (_isUploading) {
              _flutterFFmpeg.cancel();
            } else {
              // Open Preview page if there's NO ongoing upload
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PreviewVideo()),
              ).whenComplete(() {
                // If there's upload path provided then upload file to Firebase
                if (Provider.of<AddPostModel>(context, listen: false)
                        .uploadVideoPath !=
                    null) {
                  _isUploading = true;
                  _animationController.forward();
                  _uploadVideo(Provider.of<AddPostModel>(context, listen: false)
                      .uploadVideoPath);
                }
              });
            }
          },
          tooltip: 'Add Video',
          child: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: AnimatedIconButton(
                  focusColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  animationController: _animationController,
                  size: 28,
                  onPressed: () {},
                  endIcon: Icon(
                    Icons.close,
                    color: Colors.white,
                  ),
                  startIcon: Icon(
                    Icons.add,
                    color: Colors.black,
                  ),
                  endBackgroundColor: Colors.red,
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Observer(
                  builder: (_) {
                    // Progress indicator for uploadprogress
                    return Container(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        child: CircularProgressIndicator(
                          value: context.read<AddPostModel>().uploadProgress,
                        ));
                  },
                ),
              ),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }
}