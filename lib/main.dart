// lib/image_gallery.dart
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

void main() => runApp(MaterialApp(home: ImageGalleryApp()));

class ImageGalleryApp extends StatelessWidget {
  final List<String> imageUrls = [
    'https://th.bing.com/th/id/OIP.e1d4W_qoHZrF8_PNyqfRKwHaEo?pid=ImgDet&rs=1',
    'https://wallpapercave.com/wp/jJYCv7U.jpg',
    
    'https://th.bing.com/th/id/R.e8c2fbc63819a4b5ce33faab4e8681b6?rik='
        'D6B5PXW66U5uVA&riu=http%3a%2f%2fwallpapercave.com%2fwp%2fwp1814538.'
        'jpg&ehk=4o4f2kw3i6wr6RxpBsvfYHvnPB%2bLXmtlxwAq11SagmY%3d&risl=&pid=ImgRaw&r=0',

    // Add more image URLs here
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Gallery'),
      ),
      body:
      GridView.builder(
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
            child: Image.network(imageUrls[index], key: UniqueKey()), // Add UniqueKey
          );
        },
        itemCount: imageUrls.length,
      )







    );
  }
}

class FullScreenImage extends StatelessWidget {
  final String imageUrl;

  FullScreenImage({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    if (imageUrl.startsWith('http') || imageUrl.startsWith('https')) {
      // If it's a remote URL, load the image using NetworkImage
      return Scaffold(
        appBar: AppBar(),
        body: PhotoView(
          imageProvider: NetworkImage(imageUrl),
        ),
      );
    } else {
      // If it's a local file path, load the image from local storage
      return FutureBuilder(
        future: getImageFileFromPath(imageUrl),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            File imageFile = snapshot.data as File;
            return Scaffold(
              appBar: AppBar(),
              body: PhotoView(
                imageProvider: FileImage(imageFile),
              ),
            );
          }
        },
      );
    }
  }

  Future<File> getImageFileFromPath(String path) async {
    final appDir = await getApplicationDocumentsDirectory();
    return File('${appDir.path}/$path');
  }
}