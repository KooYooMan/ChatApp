import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ReportScreen extends StatefulWidget {
  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  File _image;
  List<File> _pickedImages = List<File>();
  TextEditingController _reportTextController = TextEditingController();
  _imageFromGallery() async {
    File file = await FilePicker.getFile(type: FileType.custom, allowedExtensions: ['jpg', 'jpeg', 'png']);
    setState(() {
      if (file != null) {
        print(file.path);
        _pickedImages.add(file);
      } else {
        print("NULL");
      }
    });
  }
  Widget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Icon(Icons.arrow_back_rounded, color: Colors.black,),
        iconSize: 25.0,
      ),
      title: Text(
        "What happended?",
        style: TextStyle(
          color: Colors.black,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {
            print(_reportTextController);
            _reportTextController.clear();
          },
          icon: Icon(Icons.send, color: Colors.black,),
          iconSize: 25.0,
        )
      ],
    );
  }
  Widget _buildPickedImageView() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemBuilder: (BuildContext context, int index) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: Image.file(
            _pickedImages[index],
            height: 50.0,
            fit: BoxFit.fitHeight,
          ),
        );
      },
    );
  }
  Widget _buildReportField() {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height / 2,
      ),
      width: MediaQuery.of(context).size.width - 20,
      margin: EdgeInsets.symmetric(horizontal: 10.0),
      child: TextFormField(
        keyboardType: TextInputType.multiline,
        maxLines: null,
        controller: _reportTextController,
        decoration: const InputDecoration(
          hintText: "Tell us the issues and how to \nregenerate it.",
        ),
        validator: (String value) {
          return value.length == 0 ? 'This is required field' : null;
        },
      ),
    );
  }
  Widget _buildReportBody() {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 10.0,),
            _buildReportField(),
            SizedBox(height: 10.0,),
            Container(
              width: 140,
              child: RaisedButton(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    color: Colors.black,
                  )
                ),
                onPressed: () {
                  _imageFromGallery();
                },
                child: Center(
                  child: Row(
                    children: [
                      Icon(Icons.image_outlined),
                      SizedBox(width: 5.0,),
                      Text("Add images"),
                    ],
                  ),
                )

              ),
            )
          ],
        ),
      )
    );
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: _buildAppBar(),
        body: _buildReportBody(),
      ),
    );
  }
}
