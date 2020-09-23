import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:movement/models/user/user_model.dart';
import 'package:provider/provider.dart';

class ProfileBio extends StatelessWidget {
  final UserModel _userModel = UserModel();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _userModel.getBio(),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) =>
          snapshot.hasData
              ? Container(
                  padding: EdgeInsets.symmetric(vertical: 6.0),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30.0),
                    child: Text(
                      snapshot.data,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12.0),
                    ),
                  ),
                )
              : Container(),
    );
  }
}
