import 'package:flutter/material.dart';

class ImageScreen extends StatefulWidget {
  ImageScreen(this.conversationName, this.imageProvider);
  final ImageProvider imageProvider;
  final String conversationName;
  @override
  _ImageScreenState createState() => _ImageScreenState();
}

class _ImageScreenState extends State<ImageScreen> {
  bool _isShowTopBar = true;
  Widget _buildTopBar() {
    return Row(
      children: [
        IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: Colors.white,),
          iconSize: 25.0,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        SizedBox(width: 30.0,),
        Container(
          child: Text(
            widget.conversationName,
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: Colors.white
            ),
          ),
        ),
      ],
    );
  }
  Widget _buildAppBar() {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back_rounded),
        iconSize: 25.0,
        color: Colors.white,
        onPressed: () {
          Navigator.pop(context);
        },
      ),

      title: Row(
        children: [
          SizedBox(width: 8.0),
          Container(
            child: Text(
              widget.conversationName,
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ]
      ),
      backgroundColor: Colors.transparent,
      elevation: 0.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget imageW = Center(
      child: Image(
        image: widget.imageProvider,
        fit: BoxFit.contain,
        width: MediaQuery.of(context).size.width,
      ),
    );
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: GestureDetector(
          onTap: () {
            setState(() {
              _isShowTopBar = !_isShowTopBar;
            });
          },
          child: (_isShowTopBar) ? Scaffold(
            backgroundColor: Colors.transparent,
            body : Stack(
              children: [
                Center(
                  child: imageW,
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  child: _buildTopBar())
                ,
              ],
            ),
          ) : Scaffold(
            backgroundColor: Colors.transparent,
            body: imageW,
          ),
        ),
      ),
    );
  }
}
