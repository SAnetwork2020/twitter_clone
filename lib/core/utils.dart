import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void showSnackBar(BuildContext context, String content) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(content),
    ),
  );
}

String getNameFromEmail(String email) {
  return email.split("@")[0];
}

Future<List<File>> pickImages() async {
  List<File> images = [];
  final ImagePicker picker = ImagePicker();
  final imageFiles = await picker.pickMultiImage();
  if (imageFiles.isNotEmpty) {
    for (final image in imageFiles) {
      images.add(File(image.path));
    }
  }
  return images;
}

  // List<XFile> images = await picker.pickMultiImage();
  // final LostDataResponse response = await picker.retrieveLostData();
  // if (response.isEmpty) {
  //   return;
  // }
  // final List<XFile>? files = response.files;
  // if (files != null) {
  //   _handleLostFiles(files);
  // } else {
  //   _handleError(response.exception);
  // }