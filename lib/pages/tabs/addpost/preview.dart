import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:movement/pages/tabs/addpost/upload.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:movement/models/addpost/addpost_model.dart';
import 'package:movement/pages/tabs/addpost/trim.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:video_player/video_player.dart';
import 'package:video_trimmer/video_trimmer.dart';

class PreviewVideo extends StatefulWidget {
  @override
  _PreviewVideoState createState() => _PreviewVideoState();
}

class _PreviewVideoState extends State<PreviewVideo> {
  AddPostModel _addPostModel = AddPostModel();
  final globalScaffoldKey = GlobalKey<ScaffoldState>();
  // List of gallery thumbnails
  List<Widget> _mediaList = [];
  // For paination when scroll
  int currentPage = 0;
  int lastPage;
  bool open = false;
  bool _isNext = false;
  Duration _currentTimePosition;
  File _toPreview;

  final Trimmer _trimmer = Trimmer();

  // Chewie and video_player controllers
  VideoPlayerController previewVideoPlayerController;
  ChewieController chewieController;

  final TransformationController transformationController =
      TransformationController();

  @override
  void initState() {
    super.initState();
    _getMedia();
  }

  // Pagination when scroll
  _handleScrollEvent(ScrollNotification scroll) {
    if (scroll.metrics.pixels / scroll.metrics.maxScrollExtent > 0.33) {
      if (currentPage != lastPage) {
        _getMedia();
      }
    }
  }

  // Filtering only video and lessthan 30 second videos
  FilterOption filter = FilterOption();
  FilterOptionGroup filterg = FilterOptionGroup();

  // Get list of videos
  _getMedia() async {
    // Filter videos
    filterg.setOption(
        AssetType.video,
        FilterOption(
            durationConstraint:
                DurationConstraint(max: Duration(seconds: 60))));
    lastPage = currentPage;
    // Request user to allow app from opening gallery
    var result = await PhotoManager.requestPermission();
    if (result) {
      // Get specific album => Recent
      List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(
        type: RequestType.video,
        hasAll: true,
        filterOption: filterg,
      );

      if (albums.length > 0 && albums != null) {
        //Get media from Recent
        List<AssetEntity> media =
            await albums[0].getAssetListPaged(currentPage, 20);
        // Render thumbnail widget
        List<Widget> temp = [];
        for (var asset in media) {
          temp.add(
            FutureBuilder(
              future: asset.thumbDataWithSize(200, 200),
              builder: (BuildContext context, snapshot) {
                if (snapshot.connectionState ==
                    ConnectionState.done) if (snapshot.hasData)
                  return GestureDetector(
                    onTap: () async {
                      // Preview video
                      // Set video to Preview
                      _toPreview = await asset.file;
                      context.read<AddPostModel>().preview(
                          await asset.file,
                          asset.width / asset.height,
                          asset.relativePath + '/' + asset.title,
                          asset.duration,
                          asset.height.toDouble(),
                          asset.width.toDouble());
                    },
                    child: Stack(
                      children: <Widget>[
                        Positioned.fill(
                          child: Image.memory(
                            snapshot.data,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            height: 50,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                end: Alignment(0.0, -1),
                                begin: Alignment(0.0, 0.4),
                                colors: <Color>[
                                  Color(0x8A000000),
                                  Colors.black12.withOpacity(0.0)
                                ],
                              ),
                            ),
                          ),
                        ),
                        if (asset.type == AssetType.video)
                          Align(
                            alignment: Alignment.bottomLeft,
                            child: Padding(
                              padding: EdgeInsets.only(
                                left: 10,
                                bottom: 10,
                              ),
                              child: Text(
                                '${asset.duration.toString()}s',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                return Container();
              },
            ),
          );
        }

        // Get first video as preview
        if (albums.length > 0 && albums != null) {
          if (!open) {
            _toPreview = await media[0].originFile;
            context.read<AddPostModel>().preview(
                await media[0].originFile,
                media[0].width / media[0].height,
                media[0].relativePath + '/' + media[0].title,
                media[0].duration,
                media[0].height.toDouble(),
                media[0].width.toDouble());
            open = true;
          }
        }

        // List video to _mediaList List
        setState(() {
          // Pass media list to _mediaList list
          _mediaList.addAll(temp);
          currentPage++;
        });
      } else {
        setState(() {
          _mediaList = [
            Container(
              color: Colors.grey[100],
              width: 50.0,
              height: 50.0,
              child: Center(child: Icon(Icons.videocam_off)),
            )
          ];
        });
        return Container();
      }
    } else {
      // Ask user again to request access for gallery
      PhotoManager.openSetting();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: globalScaffoldKey,
        appBar: AppBar(
          centerTitle: true,
          actions: [
            context.watch<AddPostModel>().videoPreview != null
                ? FlatButton(
                    onPressed: () {
                      // Used to avoid rebuild video when going to next page
                      _isNext = true;
                      _currentTimePosition =
                          previewVideoPlayerController.value.position;
                      Navigator.push(
                        this.context,
                        PageTransition(
                            duration: Duration(milliseconds: 150),
                            type: PageTransitionType.rightToLeftWithFade,
                            child: UploadVideo(
                                Provider.of<AddPostModel>(context,
                                        listen: false)
                                    .videoPath,
                                Provider.of<AddPostModel>(context,
                                        listen: false)
                                    .videoTime
                                    .toDouble())),
                      ).whenComplete(() {
                        previewVideoPlayerController.play();
                        _isNext = false;
                      });
                      previewVideoPlayerController.pause();
                    },
                    child: Icon(
                      Icons.chevron_right,
                      size: 20.0,
                    ))
                : Container()
          ],
          // Next button for trimming video
          // Play controller after closing trim page
          // title: context.watch<AddPostModel>().videoPreview != null
          //     ? FlatButton(
          //         splashColor: Colors.transparent,
          //         highlightColor: Colors.transparent,
          //         onPressed: () async {
          //           // Used to avoid rebuild video when going to next page
          //           _isNext = true;
          //           _currentTimePosition =
          //               previewVideoPlayerController.value.position;
          //           // Pass selected video to be trimmed to trim page
          //           await _trimmer.loadVideo(
          //               videoFile: context.read<AddPostModel>().videoPreview);
          //           Navigator.push(
          //             this.context,
          //             MaterialPageRoute(
          //                 builder: (context) => TrimVideo(_trimmer)),
          //           ).whenComplete(() {
          //             previewVideoPlayerController.play();
          //             _isNext = false;
          //             // chewieController.videoPlayerController.play();
          //             // chewieController = ChewieController(autoPlay: true);
          //           });
          //           previewVideoPlayerController.pause();
          //           // chewieController.videoPlayerController.pause();
          //           // chewieController = ChewieController(autoPlay: false);
          //         },
          //         child: Icon(
          //           Icons.content_cut,
          //           size: 18.0,
          //           color: Colors.black,
          //         ),
          //       )
          //     : Container(),
          // Back button
          leading: IconButton(
            icon: Icon(
              Icons.close,
              size: 18.0,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          backgroundColor: Colors.white,
        ),
        body: Stack(
          children: [
            Center(
                child: _toPreview == null
                    ? Text('No Videos Found')
                    // If video is ready to preview
                    : Observer(
                        builder: (context) => AspectRatio(
                              aspectRatio: Provider.of<AddPostModel>(context)
                                      .videoWidth /
                                  Provider.of<AddPostModel>(context)
                                      .videoHeight,
                              child: InteractiveViewer(
                                child: VideoPlayer(
                                    previewVideoPlayerController =
                                        VideoPlayerController.file(context
                                            .watch<AddPostModel>()
                                            .videoPreview)
                                          ..initialize().then((value) {
                                            // If page is not on screen save the state when it rebuilds
                                            if (_isNext) {
                                              previewVideoPlayerController
                                                  .seekTo(_currentTimePosition);
                                              previewVideoPlayerController
                                                  .pause();
                                              previewVideoPlayerController
                                                  .setLooping(true);
                                            } else {
                                              previewVideoPlayerController
                                                  .setLooping(true);
                                              previewVideoPlayerController
                                                  .play();
                                            }
                                          })),
                              ),
                            ))),
            Positioned(
              bottom: 0.0,
              child: Container(
                height: 100,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    end: Alignment(0.0, -1),
                    begin: Alignment(0.0, 0.4),
                    colors: <Color>[
                      Color(0x8A000000),
                      Colors.black12.withOpacity(0.0)
                    ],
                  ),
                ),
              ),
            ),
            DraggableScrollableSheet(
              initialChildSize: 0.3,
              minChildSize: 0.05,
              maxChildSize: 0.8,
              builder: (_, scrollableController) =>
                  // Onscroll pagination
                  Container(
                decoration: BoxDecoration(
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        offset: Offset(0.0, 0.2),
                        blurRadius: 1.0,
                        color: Color.fromARGB(255, 0, 0, 0),
                      )
                    ],
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        topRight: Radius.circular(20.0))),
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  controller: scrollableController,
                  child: Column(
                    children: [
                      Container(
                        child: Center(
                          child: Icon(Icons.unfold_more),
                        ),
                      ),
                      NotificationListener<ScrollNotification>(
                        onNotification: (ScrollNotification scroll) {
                          _handleScrollEvent(scroll);
                          return;
                        },
                        child: GridView.builder(
                            itemCount: _mediaList.length,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3),
                            itemBuilder: (BuildContext context, int index) {
                              try {
                                return _mediaList[index];
                              } catch (e) {
                                return Container();
                              }
                            }),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    try {
      previewVideoPlayerController.dispose();
    } catch (e) {
      print(e);
    }
    // }
  }
}
