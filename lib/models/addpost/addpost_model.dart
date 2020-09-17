import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
part 'addpost_model.g.dart';

class AddPostModel = _AddPostModelBase with _$AddPostModel;

abstract class _AddPostModelBase with Store {
  // For PreviewPage
  @observable
  File videoPreview;
  double aspectRatio;
  String videoPath;
  int videoTime;

  @observable
  double videoHeight;

  @observable
  double videoWidth;

  // Set values for previewing video
  @action
  void preview(File video, double aspect, String path, int time, double height,
      double width) {
    videoPreview = video;
    aspectRatio = aspect;
    videoPath = path;
    videoTime = time;
    videoHeight = height;
    videoWidth = width;
  }
  // End for PreviewPage

  // For UploadPage
  @observable
  double uploadProgress = 0.0;

  String uploadVideoPath;
  String uploadDescription;
  File uploadThumbnail;
  double uploadEndTime;
  double uploadAspectRatio;

  @action
  uploadInfo(String videoPath, String description, File thumbnail,
      double endTime, double aspectRatio) {
    uploadEndTime = endTime;
    uploadVideoPath = videoPath;
    uploadDescription = description ?? '';
    uploadThumbnail = thumbnail;
    uploadAspectRatio = aspectRatio;
  }

  @action
  uploadstatisticsCallback(int time, int size, double bitrate, double speed,
      int videoFrameNumber, double videoQuality, double videoFps) {
    // uploadProgress calculation
    uploadProgress = time / (uploadEndTime * 1000);
    print('*************** $uploadProgress)');
    // If compress complete, return progress to 0
    // if (uploadProgress >= 0.99) {
    //   print('DONEEEE');
    //   uploadProgress = 0.0;
    // }
  }

  @action
  resetUpload() {
    uploadProgress = 0.0;
    uploadEndTime = null;
    uploadVideoPath = null;
    uploadDescription = null;
    uploadThumbnail = null;
  }
  // End for UploadPage

}
