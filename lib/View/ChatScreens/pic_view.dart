import 'package:flutter/material.dart';

class FullSizeImageUrlScreen extends StatelessWidget {
  final String imageUrl;

  FullSizeImageUrlScreen({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child:   
         Image.network(
          imageUrl,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) {
              return child;
            }
            return CircularProgressIndicator();
          },
          errorBuilder: (context, error, stackTrace) {
            return Text('Error loading image: $error');
          },
          fit: BoxFit.contain, // Ensure the image fits within the screen
          width: MediaQuery.of(context)
              .size
              .width, // Set image width to screen width
          height: MediaQuery.of(context)
              .size
              .height, // Set image height to screen height
        ),
      ),
    );
  }
}
