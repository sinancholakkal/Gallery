import 'dart:io';

import 'package:flutter/material.dart';
import 'package:photo_view/photo_view_gallery.dart';

class PhotoView extends StatelessWidget {
  final List<File> img;
  final int index;

  const PhotoView({super.key, required this.img, required this.index});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme:const IconThemeData(
          color: Colors.white
        ),
        elevation: 0,
      ),
      body: PhotoViewGallery.builder(
        itemCount: img.length,
        builder: (context, index) {
          return PhotoViewGalleryPageOptions.customChild(
            child: Image(
              image: FileImage(img[index]),
            ),
          );
        },
        enableRotation: true,
      ),
    );
  }
}
