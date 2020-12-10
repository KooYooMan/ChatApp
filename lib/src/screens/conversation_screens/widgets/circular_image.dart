import 'package:flutter/material.dart';

class CircularImage extends StatelessWidget {
  CircularImage(this.imageProvider);
  final ImageProvider imageProvider;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundImage: imageProvider,
      radius: 20.0,
    );
  }
}
