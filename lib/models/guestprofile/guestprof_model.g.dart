// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'guestprof_model.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$GuestProfileModel on _GuestProfileModelBase, Store {
  final _$followerCountAtom =
      Atom(name: '_GuestProfileModelBase.followerCount');

  @override
  int get followerCount {
    _$followerCountAtom.reportRead();
    return super.followerCount;
  }

  @override
  set followerCount(int value) {
    _$followerCountAtom.reportWrite(value, super.followerCount, () {
      super.followerCount = value;
    });
  }

  final _$_GuestProfileModelBaseActionController =
      ActionController(name: '_GuestProfileModelBase');

  @override
  dynamic setfollowerCount(int value) {
    final _$actionInfo = _$_GuestProfileModelBaseActionController.startAction(
        name: '_GuestProfileModelBase.setfollowerCount');
    try {
      return super.setfollowerCount(value);
    } finally {
      _$_GuestProfileModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic addfollowerCount() {
    final _$actionInfo = _$_GuestProfileModelBaseActionController.startAction(
        name: '_GuestProfileModelBase.addfollowerCount');
    try {
      return super.addfollowerCount();
    } finally {
      _$_GuestProfileModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic subtractfollowerCount() {
    final _$actionInfo = _$_GuestProfileModelBaseActionController.startAction(
        name: '_GuestProfileModelBase.subtractfollowerCount');
    try {
      return super.subtractfollowerCount();
    } finally {
      _$_GuestProfileModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
followerCount: ${followerCount}
    ''';
  }
}
