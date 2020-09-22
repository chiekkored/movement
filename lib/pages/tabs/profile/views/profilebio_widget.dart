import 'package:flutter/material.dart';
import 'package:movement/models/user/user_model.dart';
import 'package:provider/provider.dart';

class ProfileBio extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 6.0),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30.0),
        child: Text(
          context.watch<UserModel>().bio,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12.0),
        ),
      ),
    );
  }
}
