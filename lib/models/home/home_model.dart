import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
part 'home_model.g.dart';

class HomeModel = _HomeModelBase with _$HomeModel;

abstract class _HomeModelBase with Store {
  @observable
  List<DocumentSnapshot> feedList = [];

  @observable
  ScrollController scrollController = ScrollController();

  @action
  setScrollController(ScrollController value) => scrollController = value;

  @action
  backToTopScroll(ScrollController value) {
    value.animateTo(0.0, duration: Duration(seconds: 1), curve: Curves.ease);
  }

  @action
  Future<List<DocumentSnapshot>> getFeedList() async {
    List<DocumentSnapshot> feedList = [];
    await firestore
        .collection("posts")
        .doc(_user.uid)
        .collection("post_data")
        .get()
        .then((QuerySnapshot querySnapshot) => {
              querySnapshot.docs.forEach((doc) {
                feedList.add(doc);
              })
            });
    return feedList;
  }

  User _user = FirebaseAuth.instance.currentUser;
  var firestore = FirebaseFirestore.instance;

  @observable
  ObservableFuture<List<DocumentSnapshot>> topItemsFuture;

  @action
  Future fetchLatest() => topItemsFuture = ObservableFuture(firestore
      .collection("posts")
      .doc(_user.uid)
      .collection("post_data")
      .get()
      .then((QuerySnapshot feed) => feed.docs));
}
