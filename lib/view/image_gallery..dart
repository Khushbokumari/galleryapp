// lib/image_gallery.dart
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

void main() => runApp(MaterialApp(home: ImageGalleryApp()));

class ImageGalleryApp extends StatelessWidget {
  get imageUrls => null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Gallery'),
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
        ),
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) {
                return FullScreenImage(imageUrl: imageUrls[index]);
              }));
            },
            child: Image.network(imageUrls[index]),
          );
        },
        itemCount: imageUrls.length,
      ),
    );
  }
}

class FullScreenImage extends StatelessWidget {
  final String imageUrl;

  FullScreenImage({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder(
        future: getImageFileFromPath(imageUrl),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            File imageFile = snapshot.data as File;
            return PhotoView(
              imageProvider: FileImage(imageFile),
            );
          }
        },
      ),
    );
  }

  Future<File> getImageFileFromPath(String path) async {
    final appDir = await getApplicationDocumentsDirectory();
    return File('${appDir.path}/$path');
  }

  getApplicationDocumentsDirectory() {}
}
