import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class GuestAchievementList extends StatefulWidget {
  @override
  _GuestAchievementListState createState() => _GuestAchievementListState();
}

class _GuestAchievementListState extends State<GuestAchievementList> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 6.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Achievements',
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
              GestureDetector(
                onTap: () {
                  print('see all');
                },
                child: Text(
                  'See All',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 12.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          height: 80.0,
          margin: EdgeInsets.symmetric(vertical: 6.0),
          child: ListView.builder(
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: 10,
              itemBuilder: (_, index) {
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 6.0),
                  height: 80.0,
                  width: 80.0,
                  child: CachedNetworkImage(
                    imageUrl: 'https://picsum.photos/id/${index * 12}/200/',
                    imageBuilder: (context, imageProvider) => ClipRRect(
                      borderRadius: BorderRadius.circular(20.0),
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    placeholder: (context, url) => ClipRRect(
                      borderRadius: BorderRadius.circular(20.0),
                      child: Container(
                        color: Colors.grey,
                      ),
                    ),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                );
              }),
        ),
      ],
    );
  }
}
