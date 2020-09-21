import 'package:cached_video_player/cached_video_player.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:video_player/video_player.dart';

class VideoFeed extends StatefulWidget {
  final String url;
  final bool play;

  const VideoFeed({Key key, @required this.url, @required this.play})
      : super(key: key);
  @override
  _VideoFeedState createState() => _VideoFeedState();
}

class _VideoFeedState extends State<VideoFeed> {
  CachedVideoPlayerController _videoPlayerController;
  Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    _videoPlayerController = CachedVideoPlayerController.network(widget.url);
    _initializeVideoPlayerFuture =
        _videoPlayerController.initialize().then((_) {
      // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
      setState(() {});
    });

    if (widget.play) {
      _videoPlayerController.play();
      _videoPlayerController.setLooping(true);
    }
  }

  @override
  void didUpdateWidget(VideoFeed oldWidget) {
    if (oldWidget.play != widget.play) {
      if (widget.play) {
        _videoPlayerController.play();
        _videoPlayerController.setLooping(true);
      } else {
        Duration _reset = Duration(seconds: 0);
        _videoPlayerController.seekTo(_reset);
        _videoPlayerController.pause();
      }
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializeVideoPlayerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          var _size = _videoPlayerController.value.size;
          return GestureDetector(
            onTap: () => print('Video Widget clicked'),
            child: (_size.height > _size.width)
                ? Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.width,
                    child: FittedBox(
                      fit: BoxFit.fitWidth,
                      alignment: Alignment.center,
                      child: Container(
                        height: _videoPlayerController.value.size.height,
                        width: _videoPlayerController.value.size.width,
                        child: AspectRatio(
                            aspectRatio:
                                _videoPlayerController.value.aspectRatio,
                            child: CachedVideoPlayer(_videoPlayerController)),
                      ),
                    ),
                  )
                : AspectRatio(
                    aspectRatio: _videoPlayerController.value.aspectRatio,
                    child: CachedVideoPlayer(_videoPlayerController)),
          );
        } else {
          return Shimmer.fromColors(
            child: Container(
              color: Colors.white,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.width,
            ),
            baseColor: Colors.grey[300],
            highlightColor: Colors.grey[100],
          );
        }
      },
    );
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }
}
