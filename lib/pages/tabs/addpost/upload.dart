import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_video_compress/flutter_video_compress.dart';
import 'package:movement/models/addpost/addpost_model.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:path_provider/path_provider.dart';

class UploadVideo extends StatefulWidget {
  final String inputPath;
  final double endValue;
  UploadVideo(this.inputPath, this.endValue);

  @override
  _UploadVideoState createState() => _UploadVideoState();
}

class _UploadVideoState extends State<UploadVideo> {
  final AddPostModel _addpost = AddPostModel();
  final _flutterVideoCompress = FlutterVideoCompress();
  TextEditingController _textController = TextEditingController();
  final uploadScaffoldKey = GlobalKey<ScaffoldState>();

  File _thumbnailFileImage;

  bool _isUploading = false;
  @override
  void initState() {
    super.initState();
    getThumbnail();
  }

  getThumbnail() async {
    final thumbnailFile =
        await _flutterVideoCompress.getThumbnailWithFile(widget.inputPath,
            quality: 50, // default(100)
            position: -1 // default(-1)
            );
    setState(() {
      _thumbnailFileImage = thumbnailFile;
    });
  }
// frame= 1132 fps= 41 q=-1.0 Lsize=   58640kB time=00:00:49.20 bitrate=9763.2kbits/s dup=192 drop=0 speed=1.78x ~~~ thread 5
// frame= 1132 fps= 39 q=-1.0 Lsize=   58641kB time=00:00:49.20 bitrate=9763.4kbits/s dup=192 drop=0 speed=1.71x ~~~ thread 0
// frame= 1132 fps= 42 q=-1.0 Lsize=   58641kB time=00:00:49.20 bitrate=9763.4kbits/s dup=192 drop=0 speed=1.85x ~~~ none

// /data/user/0/com.example.movement/app_flutter/Trimmer/IMG_2320_trimmed:Sep10,2020-23:20:02.mp4':

  final FlutterFFprobe _flutterFFprobe = new FlutterFFprobe();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: uploadScaffoldKey,
      appBar: AppBar(
          backgroundColor: Colors.white,
          actions: [
            FlatButton(
                onPressed: () {
                  _flutterFFprobe.getMediaInformation(widget.inputPath).then(
                      (value) =>
                          print('----------Duration: ${value['duration']}'));
                  context.read<AddPostModel>().uploadInfo(
                      widget.inputPath,
                      _textController.text,
                      _thumbnailFileImage,
                      widget.endValue,
                      context.read<AddPostModel>().aspectRatio);
                  Navigator.popUntil(context, ModalRoute.withName('/'));
                },
                child: Text('Post'))
          ],
          // Back button
          leading: _isUploading
              ? Container()
              : IconButton(
                  icon: Icon(Icons.chevron_left, color: Colors.black),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 12.0),
            height: 60.0,
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Row(
                children: [
                  Container(
                    width: 50.0,
                    height: 50.0,
                    child: FittedBox(
                      fit: BoxFit.cover,
                      child: _thumbnailFileImage != null
                          ? Image.file(_thumbnailFileImage)
                          : Container(),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: TextField(
                        readOnly: _isUploading,
                        controller: _textController,
                        keyboardType: TextInputType.multiline,
                        minLines: 1, //Normal textInputField will be displayed
                        maxLines: 5,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Write something about your video',
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _textController.dispose();
  }
}

// Old Preview page
// import 'dart:io';

// import 'package:chewie/chewie.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_mobx/flutter_mobx.dart';
// import 'package:provider/provider.dart';
// import 'package:movement/models/addpost/addpost_model.dart';
// import 'package:movement/pages/tabs/addpost/trim.dart';
// import 'package:photo_manager/photo_manager.dart';
// import 'package:video_player/video_player.dart';
// import 'package:video_trimmer/trim_editor.dart';
// import 'package:video_trimmer/video_trimmer.dart';

// class PreviewVideo extends StatefulWidget {
//   @override
//   _PreviewVideoState createState() => _PreviewVideoState();
// }

// class _PreviewVideoState extends State<PreviewVideo> {
//   final globalScaffoldKey = GlobalKey<ScaffoldState>();
//   // List of gallery thumbnails
//   List<Widget> _mediaList = [];
//   // For paination when scroll
//   int currentPage = 0;
//   int lastPage;
//   bool open = false;
//   File _toPreview;

//   final Trimmer _trimmer = Trimmer();

//   // Chewie and video_player controllers
//   VideoPlayerController previewVideoPlayerController;
//   ChewieController chewieController;

//   @override
//   void initState() {
//     super.initState();
//     _getMedia();
//   }

//   // Pagination when scroll
//   _handleScrollEvent(ScrollNotification scroll) {
//     if (scroll.metrics.pixels / scroll.metrics.maxScrollExtent > 0.33) {
//       if (currentPage != lastPage) {
//         _getMedia();
//       }
//     }
//   }

//   // Filtering only video and lessthan 30 second videos
//   FilterOption filter = FilterOption();
//   FilterOptionGroup filterg = FilterOptionGroup();

//   // Get list of videos
//   _getMedia() async {
//     // Filter videos
//     filterg.setOption(
//         AssetType.video,
//         FilterOption(
//             durationConstraint:
//                 DurationConstraint(max: Duration(seconds: 60))));
//     lastPage = currentPage;
//     // Request user to allow app from opening gallery
//     var result = await PhotoManager.requestPermission();
//     if (result) {
//       // Get specific album => Recent
//       List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(
//         type: RequestType.video,
//         hasAll: true,
//         filterOption: filterg,
//       );

//       if (albums.length > 0 && albums != null) {
//         //Get media from Recent
//         List<AssetEntity> media =
//             await albums[0].getAssetListPaged(currentPage, 20);
//         // Render thumbnail widget
//         List<Widget> temp = [];
//         for (var asset in media) {
//           temp.add(
//             FutureBuilder(
//               future: asset.thumbDataWithSize(200, 200),
//               builder: (BuildContext context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.done)
//                   return GestureDetector(
//                     onTap: () async {
//                       // Preview video
//                       // chewieController.videoPlayerController
//                       //     .seekTo(Duration.zero);
//                       // chewieController.videoPlayerController.pause();
//                       // Set video to Preview
//                       _toPreview = await asset.file;
//                       context.read<AddPostModel>().preview(
//                           await asset.file,
//                           asset.width / asset.height,
//                           asset.relativePath + asset.title,
//                           asset.duration,
//                           asset.height.toDouble(),
//                           asset.width.toDouble());
//                     },
//                     child: Stack(
//                       children: <Widget>[
//                         Positioned.fill(
//                           child: Image.memory(
//                             snapshot.data,
//                             fit: BoxFit.cover,
//                           ),
//                         ),
//                         if (asset.type == AssetType.video)
//                           Align(
//                             alignment: Alignment.bottomRight,
//                             child: Padding(
//                               padding: EdgeInsets.only(right: 5, bottom: 5),
//                               child: Icon(
//                                 Icons.videocam,
//                                 color: Colors.white,
//                               ),
//                             ),
//                           ),
//                         if (asset.type == AssetType.video)
//                           Align(
//                             alignment: Alignment.bottomLeft,
//                             child: Padding(
//                               padding: EdgeInsets.only(
//                                 left: 10,
//                                 bottom: 10,
//                               ),
//                               child: Container(
//                                 decoration: BoxDecoration(
//                                     color: Color.fromRGBO(220, 220, 220, .6),
//                                     borderRadius:
//                                         BorderRadius.all(Radius.circular(20))),
//                                 width: 30.0,
//                                 height: 15.0,
//                                 child: Center(
//                                     child: Text(
//                                   '${asset.duration.toString()}s',
//                                   style: TextStyle(fontWeight: FontWeight.bold),
//                                 )),
//                               ),
//                             ),
//                           ),
//                       ],
//                     ),
//                   );
//                 return Container();
//               },
//             ),
//           );
//         }

//         // Get first video as preview
//         if (!open) {
//           _toPreview = await media[0].originFile;
//           context.read<AddPostModel>().preview(
//               await media[0].originFile,
//               media[0].width / media[0].height,
//               media[0].relativePath + '/' + media[0].title,
//               media[0].duration,
//               media[0].height.toDouble(),
//               media[0].width.toDouble());
//           open = true;
//         }

//         // List video to _mediaList List
//         setState(() {
//           // Pass media list to _mediaList list
//           _mediaList.addAll(temp);
//           currentPage++;
//         });
//       } else {
//         return Container();
//       }
//     } else {
//       // Ask user again to request access for gallery
//       PhotoManager.openSetting();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         key: globalScaffoldKey,
//         appBar: AppBar(
//           actions: [
//             // Next button for trimming video
//             // Play controller after closing trim page
//             context.watch<AddPostModel>().videoPreview != null
//                 ? FlatButton(
//                     onPressed: () async {
//                       // Pass selected video to be trimmed to trim page
//                       await _trimmer.loadVideo(
//                           videoFile: context.read<AddPostModel>().videoPreview);
//                       Navigator.push(
//                         this.context,
//                         MaterialPageRoute(
//                             builder: (context) => TrimVideo(_trimmer)),
//                       ).whenComplete(() {
//                         previewVideoPlayerController.play();
//                         // chewieController.videoPlayerController.play();
//                         // chewieController = ChewieController(autoPlay: true);
//                       });
//                       previewVideoPlayerController.pause();
//                       // chewieController.videoPlayerController.pause();
//                       // chewieController = ChewieController(autoPlay: false);
//                     },
//                     child: Text('Next'))
//                 : Container()
//           ],
//           // Back button
//           leading: IconButton(
//             icon: Icon(Icons.close, color: Colors.black),
//             onPressed: () {
//               Navigator.of(context).pop();
//             },
//           ),
//           backgroundColor: Colors.white,
//         ),
//         body: ListView(
//           children: [
//             Container(
//                 height: 900.0 / MediaQuery.of(context).devicePixelRatio,
//                 color: Colors.white,
//                 child: _toPreview == null
//                     ? Center(
//                         child: Container(
//                           width: 30.0,
//                           height: 30.0,
//                           child: CircularProgressIndicator(),
//                         ),
//                       )
//                     // If video is ready to preview
//                     : Observer(
//                         builder: (BuildContext context) => FittedBox(
//                           fit: BoxFit.fitWidth,
//                           child: Center(
//                             child: _toPreview != null
//                                 ? Container(
//                                     height: context
//                                         .watch<AddPostModel>()
//                                         .videoHeight,
//                                     width: context
//                                         .watch<AddPostModel>()
//                                         .videoWidth,
//                                     child: AspectRatio(
//                                       aspectRatio: context
//                                               .watch<AddPostModel>()
//                                               .videoHeight /
//                                           context
//                                               .watch<AddPostModel>()
//                                               .videoWidth,
//                                       child: VideoPlayer(
//                                           previewVideoPlayerController =
//                                               VideoPlayerController.file(context
//                                                   .watch<AddPostModel>()
//                                                   .videoPreview)
//                                                 ..initialize().then((value) {
//                                                   previewVideoPlayerController
//                                                       .setLooping(true);
//                                                   previewVideoPlayerController
//                                                       .play();
//                                                 })),
//                                     ),
//                                   )
//                                 : Container(),
//                           ),
//                         ),
//                       )),
//             // Onscroll pagination
//             NotificationListener<ScrollNotification>(
//               onNotification: (ScrollNotification scroll) {
//                 _handleScrollEvent(scroll);
//                 return;
//               },
//               child: GridView.builder(
//                   itemCount: _mediaList.length,
//                   shrinkWrap: true,
//                   physics: NeverScrollableScrollPhysics(),
//                   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                       crossAxisCount: 3),
//                   itemBuilder: (BuildContext context, int index) {
//                     return _mediaList[index];
//                   }),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     // if (chewieController != null) {
//     // chewieController.videoPlayerController.dispose();

//     // chewieController.pause();
//     // chewieController.dispose();

//     super.dispose();
//     previewVideoPlayerController.dispose();
//     // }
//   }
// }
