// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'addpost_model.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$AddPostModel on _AddPostModelBase, Store {
  final _$videoPreviewAtom = Atom(name: '_AddPostModelBase.videoPreview');

  @override
  File get videoPreview {
    _$videoPreviewAtom.reportRead();
    return super.videoPreview;
  }

  @override
  set videoPreview(File value) {
    _$videoPreviewAtom.reportWrite(value, super.videoPreview, () {
      super.videoPreview = value;
    });
  }

  final _$videoHeightAtom = Atom(name: '_AddPostModelBase.videoHeight');

  @override
  double get videoHeight {
    _$videoHeightAtom.reportRead();
    return super.videoHeight;
  }

  @override
  set videoHeight(double value) {
    _$videoHeightAtom.reportWrite(value, super.videoHeight, () {
      super.videoHeight = value;
    });
  }

  final _$videoWidthAtom = Atom(name: '_AddPostModelBase.videoWidth');

  @override
  double get videoWidth {
    _$videoWidthAtom.reportRead();
    return super.videoWidth;
  }

  @override
  set videoWidth(double value) {
    _$videoWidthAtom.reportWrite(value, super.videoWidth, () {
      super.videoWidth = value;
    });
  }

  final _$uploadProgressAtom = Atom(name: '_AddPostModelBase.uploadProgress');

  @override
  double get uploadProgress {
    _$uploadProgressAtom.reportRead();
    return super.uploadProgress;
  }

  @override
  set uploadProgress(double value) {
    _$uploadProgressAtom.reportWrite(value, super.uploadProgress, () {
      super.uploadProgress = value;
    });
  }

  final _$_AddPostModelBaseActionController =
      ActionController(name: '_AddPostModelBase');

  @override
  void preview(File video, double aspect, String path, int time, double height,
      double width) {
    final _$actionInfo = _$_AddPostModelBaseActionController.startAction(
        name: '_AddPostModelBase.preview');
    try {
      return super.preview(video, aspect, path, time, height, width);
    } finally {
      _$_AddPostModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic uploadInfo(String videoPath, String description, File thumbnail,
      double endTime, double aspectRatio) {
    final _$actionInfo = _$_AddPostModelBaseActionController.startAction(
        name: '_AddPostModelBase.uploadInfo');
    try {
      return super
          .uploadInfo(videoPath, description, thumbnail, endTime, aspectRatio);
    } finally {
      _$_AddPostModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic uploadstatisticsCallback(
      int time,
      int size,
      double bitrate,
      double speed,
      int videoFrameNumber,
      double videoQuality,
      double videoFps) {
    final _$actionInfo = _$_AddPostModelBaseActionController.startAction(
        name: '_AddPostModelBase.uploadstatisticsCallback');
    try {
      return super.uploadstatisticsCallback(
          time, size, bitrate, speed, videoFrameNumber, videoQuality, videoFps);
    } finally {
      _$_AddPostModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic resetUpload() {
    final _$actionInfo = _$_AddPostModelBaseActionController.startAction(
        name: '_AddPostModelBase.resetUpload');
    try {
      return super.resetUpload();
    } finally {
      _$_AddPostModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
videoPreview: ${videoPreview},
videoHeight: ${videoHeight},
videoWidth: ${videoWidth},
uploadProgress: ${uploadProgress}
    ''';
  }
}
