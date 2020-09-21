import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:movement/models/home/home_model.dart';
import 'package:movement/pages/guest%20profile/guestProfile.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class ProfileFeed extends StatefulWidget {
  final String dpUrl;
  final String userName;
  final String uid;
  final bool isVerified;
  ProfileFeed(this.dpUrl, this.userName, this.uid, this.isVerified);

  @override
  _ProfileFeedState createState() => _ProfileFeedState();
}

class _ProfileFeedState extends State<ProfileFeed> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read<HomeModel>().setisHomeVisible(false);
        return Navigator.push(
                context,
                PageTransition(
                    duration: Duration(milliseconds: 150),
                    type: PageTransitionType.rightToLeftWithFade,
                    child: GuestProfilePage(widget.uid, widget.dpUrl,
                        widget.userName, widget.isVerified)))
            .whenComplete(
                () => context.read<HomeModel>().setisHomeVisible(true));
      },
      child: Row(
        children: [
          CachedNetworkImage(
            imageUrl: widget.dpUrl,
            imageBuilder: (context, imageProvider) => CircleAvatar(
              radius: 15.0,
              backgroundImage: imageProvider,
            ),
            placeholder: (context, url) => CircleAvatar(
              radius: 15.0,
              backgroundColor: Colors.grey[200],
            ),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              widget.userName,
              style: TextStyle(color: Colors.white, shadows: <Shadow>[
                Shadow(
                  offset: Offset(0.0, 0.5),
                  blurRadius: 1.0,
                  color: Color.fromARGB(255, 0, 0, 0),
                )
              ]),
            ),
          )
        ],
      ),
    );
  }
}
