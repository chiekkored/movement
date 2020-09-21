import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';

class DescriptionFeed extends StatefulWidget {
  final String description;
  DescriptionFeed(this.description);

  @override
  _DescriptionFeedState createState() => _DescriptionFeedState();
}

class _DescriptionFeedState extends State<DescriptionFeed> {
  @override
  Widget build(BuildContext context) {
    return ExpandableNotifier(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expandable(
            collapsed: ExpandableButton(
                child: Text(
              widget.description,
              style: TextStyle(
                  fontSize: 12.0,
                  color: Colors.white,
                  shadows: <Shadow>[
                    Shadow(
                      offset: Offset(0.0, 0.5),
                      blurRadius: 1.0,
                      color: Color.fromARGB(255, 0, 0, 0),
                    )
                  ]),
              softWrap: true,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            )),
            expanded: Column(
              children: [
                ExpandableButton(
                  child: Text(
                    widget.description,
                    style: TextStyle(
                        fontSize: 12.0,
                        color: Colors.white,
                        shadows: <Shadow>[
                          Shadow(
                            offset: Offset(0.0, 0.5),
                            blurRadius: 1.0,
                            color: Color.fromARGB(255, 0, 0, 0),
                          )
                        ]),
                    softWrap: true,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
