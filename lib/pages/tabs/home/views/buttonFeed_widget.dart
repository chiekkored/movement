import 'package:flutter/material.dart';
import 'package:movement/customs/movement_custom_icons.dart';
import 'package:timeago/timeago.dart' as timeago;

class ButtonFeed extends StatefulWidget {
  final uploadDate;
  ButtonFeed(this.uploadDate);

  @override
  _ButtonFeedState createState() => _ButtonFeedState();
}

class _ButtonFeedState extends State<ButtonFeed> {
  @override
  Widget build(BuildContext context) {
    DateTime datePosted = (widget.uploadDate).toDate();
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () => print('Applaud list clicked'),
              child: Text(
                '108 applaud this.',
                style: TextStyle(fontSize: 10.0, color: Colors.grey),
              ),
            ),
            Text(
              timeago.format(datePosted).toString(),
              style: TextStyle(fontSize: 10.0, color: Colors.grey),
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 110.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => print('Clap button clicked'),
                    child: Container(
                      height: 40.0,
                      child: Icon(
                        MovementCustom.clap_fill,
                        color: Colors.grey,
                        size: 20.0,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => print('Text comments clicked'),
                    child: Container(
                      height: 40.0,
                      child: Icon(
                        MovementCustom.comments,
                        color: Colors.grey,
                        size: 20.0,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => print('Video comments clicked'),
                    child: Container(
                      height: 40.0,
                      child: Icon(
                        MovementCustom.video_comment,
                        color: Colors.grey,
                        size: 20.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () => print('Feed settings clicked'),
              child: Container(
                height: 40.0,
                child: Icon(
                  Icons.more_horiz,
                  color: Colors.grey[400],
                  size: 24.0,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
