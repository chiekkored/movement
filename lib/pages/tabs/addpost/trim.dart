import 'package:flutter/material.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:movement/pages/tabs/addpost/upload.dart';
import 'package:provider/provider.dart';
import 'package:movement/models/addpost/addpost_model.dart';
import 'package:video_trimmer/trim_editor.dart';
import 'package:video_trimmer/video_trimmer.dart';
import 'package:video_trimmer/video_viewer.dart';

class TrimVideo extends StatefulWidget {
  final Trimmer _trimmer;
  TrimVideo(this._trimmer);
  @override
  _TrimVideoState createState() => _TrimVideoState();
}

class _TrimVideoState extends State<TrimVideo> {
  final AddPostModel _progress = AddPostModel();
  final FlutterFFmpeg _flutterFFmpeg = new FlutterFFmpeg();
  final FlutterFFmpegConfig _flutterFFmpegConfig = new FlutterFFmpegConfig();

  double _startValue = 0.0;
  double _endValue = 0.0;
  bool _isPlaying = false;
  bool _loadDone = false;

  // Future _cropvideo;

  @override
  void initState() {
    super.initState();
    // _cropvideo = _cropVideo();
  }

  // Future _cropVideo() async {
  //   if (context.read<AddPostModel>().videoHeight > 400) {
  //     Directory appDocDir = await getApplicationDocumentsDirectory();
  //     String appDocPath = appDocDir.path;
  //     String outputPath = appDocPath + "/output.mp4";
  //     _flutterFFmpegConfig.enableStatisticsCallback(this.statisticsCallback);
  //     await _flutterFFmpeg
  //         .execute(
  //             "-y -i '${context.read<AddPostModel>().videoPath}' -c:v libx264 -crf 28 -preset ultrafast -threads 5 -filter:v 'fps=fps=23, scale=720:in_h:force_original_aspect_ratio=decrease, crop=in_w:900:-in_w:${context.read<AddPostModel>().videoPosY}' -c:a copy $outputPath")
  //         .then((rc) => print("FFmpeg process exited with rc $rc"));
  //     await _trimmer.loadVideo(videoFile: File(outputPath));
  //   } else {
  //     await _trimmer.loadVideo(
  //         videoFile: context.read<AddPostModel>().videoPreview);
  //   }
  //   if (mounted)
  //     setState(() {
  //       _loadDone = true;
  //     });
  //   return _trimmer;
  // }

  // void statisticsCallback(int time, int size, double bitrate, double speed,
  //     int videoFrameNumber, double videoQuality, double videoFps) {
  //   _progress.trimProgress(time, context.read<AddPostModel>().videoTime);
  // }

  @override
  Widget build(BuildContext context) {
    final _video = context.watch<AddPostModel>();

    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          actions: [
            mounted
                ?
                // Next button after trimming video
                FlatButton(
                    onPressed: () async {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          content: CircularProgressIndicator(),
                        ),
                      );
                      await widget._trimmer
                          .saveTrimmedVideo(
                              startValue: _startValue, endValue: _endValue)
                          .then((value) {
                        Navigator.push(
                          this.context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  UploadVideo(value, _endValue)),
                        );
                      });
                    },
                    child: Text(
                      'Trim',
                      style: TextStyle(color: Colors.white),
                    ))
                : Container()
          ],
          leading: IconButton(
            icon: Icon(Icons.chevron_left, color: Colors.white),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          backgroundColor: Color.fromRGBO(50, 50, 50, 0.7),
        ),
        body: Stack(
          children: [
            GestureDetector(
              onTap: () async {
                bool playbackState = await widget._trimmer.videPlaybackControl(
                    startValue: _startValue, endValue: _endValue);
                _isPlaying = playbackState;
              },
              child: Stack(
                children: [
                  Container(
                    color: Colors.black,
                    child: VideoViewer(),
                  ),
                  if (_isPlaying == false)
                    Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: EdgeInsets.only(right: 5.0, left: 5.0),
                        child: Icon(
                          Icons.pause,
                          color: Colors.white,
                        ),
                      ),
                    )
                ],
              ),
            ),
            Positioned(
              bottom: 30.0,
              left: 0.0,
              right: 0.0,
              child: TrimEditor(
                thumbnailQuality: 50,
                borderPaintColor: Colors.white,
                circlePaintColor: Colors.white,
                viewerHeight: 50.0,
                durationTextStyle: TextStyle(
                  color: Colors.white,
                  shadows: <Shadow>[
                    Shadow(
                      offset: Offset(0.0, 1.0),
                      blurRadius: 3.0,
                      color: Color.fromARGB(255, 0, 0, 0),
                    )
                  ],
                ),
                viewerWidth: MediaQuery.of(context).size.width - 50,
                onChangeStart: (value) {
                  _startValue = value;
                },
                onChangeEnd: (value) {
                  _endValue = value;
                },
                onChangePlaybackState: (value) {
                  setState(() {
                    _isPlaying = value;
                  });
                },
              ),
            ),
          ],
        ));
  }

  // @override
  // void dispose() {
  //   super.dispose();
  //   _flutterFFmpeg.cancel();
  // }
}

//body: FutureBuilder(
//           future: _cropvideo,
//           builder: (context, snapshot) {
//             if (snapshot.hasData) {
//               return Container(
//                 child: Column(
//                   children: [
//                     Container(
//                       height: 400.0,
//                       child: GestureDetector(
//                           onTap: () async {
//                             bool playbackState =
//                                 await snapshot.data.videPlaybackControl(
//                               startValue: _startValue,
//                               endValue: _endValue,
//                             );
//                             _isPlaying = playbackState;
//                           },
//                           child: Stack(
//                             children: [
//                               VideoViewer(),
//                               if (_isPlaying == false)
//                                 Align(
//                                   alignment: Alignment.center,
//                                   child: Padding(
//                                     padding:
//                                         EdgeInsets.only(right: 5, bottom: 5),
//                                     child: Icon(
//                                       Icons.pause,
//                                       color: Colors.white,
//                                     ),
//                                   ),
//                                 ),
//                             ],
//                           )),
//                     ),
//                     SizedBox(
//                       height: 50.0,
//                     ),
//                     Center(
//                       child: TrimEditor(
//                         borderPaintColor: Colors.black,
//                         circlePaintColor: Colors.black,
//                         viewerHeight: 50.0,
//                         durationTextStyle: TextStyle(color: Colors.grey[400]),
//                         viewerWidth: MediaQuery.of(context).size.width - 50,
//                         onChangeStart: (value) {
//                           _startValue = value;
//                         },
//                         onChangeEnd: (value) {
//                           _endValue = value;
//                         },
//                         onChangePlaybackState: (value) {
//                           setState(() {
//                             _isPlaying = value;
//                           });
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//               );
//             } else {
//               return Center(
//                 child: Container(
//                   child: Observer(
//                     builder: (_) => LinearProgressIndicator(
//                       value: _progress.progress,
//                     ),
//                   ),
//                 ),
//               );
//             }
//           }),
