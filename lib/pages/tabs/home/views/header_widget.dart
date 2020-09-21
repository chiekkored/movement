import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TitleView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.black12, style: BorderStyle.solid),
        ),
      ),
      padding: EdgeInsets.fromLTRB(12.0, 6.0, 12.0, 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Movement',
            style: GoogleFonts.leckerliOne(color: Colors.black, fontSize: 35.0),
          ),
          Container(
            width: 50.0,
            child: FlatButton(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onPressed: () {},
              child: Center(child: Icon(Icons.chat)),
            ),
          )
        ],
      ),
    );
  }
}
