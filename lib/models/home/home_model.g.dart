// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_model.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$HomeModel on _HomeModelBase, Store {
  final _$feedListAtom = Atom(name: '_HomeModelBase.feedList');

  @override
  List<DocumentSnapshot> get feedList {
    _$feedListAtom.reportRead();
    return super.feedList;
  }

  @override
  set feedList(List<DocumentSnapshot> value) {
    _$feedListAtom.reportWrite(value, super.feedList, () {
      super.feedList = value;
    });
  }

  final _$scrollControllerAtom = Atom(name: '_HomeModelBase.scrollController');

  @override
  ScrollController get scrollController {
    _$scrollControllerAtom.reportRead();
    return super.scrollController;
  }

  @override
  set scrollController(ScrollController value) {
    _$scrollControllerAtom.reportWrite(value, super.scrollController, () {
      super.scrollController = value;
    });
  }

  final _$feedItemsFutureAtom = Atom(name: '_HomeModelBase.feedItemsFuture');

  @override
  ObservableFuture<List<DocumentSnapshot>> get feedItemsFuture {
    _$feedItemsFutureAtom.reportRead();
    return super.feedItemsFuture;
  }

  @override
  set feedItemsFuture(ObservableFuture<List<DocumentSnapshot>> value) {
    _$feedItemsFutureAtom.reportWrite(value, super.feedItemsFuture, () {
      super.feedItemsFuture = value;
    });
  }

  final _$_HomeModelBaseActionController =
      ActionController(name: '_HomeModelBase');

  @override
  dynamic setScrollController(ScrollController value) {
    final _$actionInfo = _$_HomeModelBaseActionController.startAction(
        name: '_HomeModelBase.setScrollController');
    try {
      return super.setScrollController(value);
    } finally {
      _$_HomeModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic backToTopScroll(ScrollController value) {
    final _$actionInfo = _$_HomeModelBaseActionController.startAction(
        name: '_HomeModelBase.backToTopScroll');
    try {
      return super.backToTopScroll(value);
    } finally {
      _$_HomeModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  Future<dynamic> fetchFeed() {
    final _$actionInfo = _$_HomeModelBaseActionController.startAction(
        name: '_HomeModelBase.fetchFeed');
    try {
      return super.fetchFeed();
    } finally {
      _$_HomeModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
feedList: ${feedList},
scrollController: ${scrollController},
feedItemsFuture: ${feedItemsFuture}
    ''';
  }
}
