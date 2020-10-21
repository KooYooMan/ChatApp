import 'package:flutter/material.dart';

class CircularImage extends StatelessWidget {
  CircularImage(this.imageProvider);
  final ImageProvider imageProvider;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30.0,
      height: 30.0,
      decoration: new BoxDecoration(
        shape: BoxShape.circle,
        image: new DecorationImage(
          fit: BoxFit.fill,
          image: imageProvider
        )
      )
    );
  }
}
