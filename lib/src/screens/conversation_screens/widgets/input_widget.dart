import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InputWidget extends StatelessWidget {
  final TextEditingController textEditingController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(width: 8,),
              Flexible(
                child: Container(
                  child: TextField(
                    style: TextStyle(color: Colors.grey, fontSize: 15.0),
                    controller: textEditingController,
                    decoration: InputDecoration.collapsed(
                      hintText: "Viết tin nhắn",
                    ),
                  ),
                ),
              ),
              Material(
                child: new Container(
                  margin: EdgeInsets.symmetric(horizontal: 8.0),
                  child: IconButton(
                    icon: new Icon(Icons.send),
                    color: Colors.grey,
                    //TODO: do actually onPress
                    onPressed: () => {textEditingController.clear()},
                  )
                )
              )
            ],
          ),
          Row(
            //TODO: do option for gif, icon, ...
            children: [
              Material(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 1.0),
                  child: new IconButton(
                    icon: Icon(Icons.face),
                    color: Colors.black,
                    //TODO: do actually onPress
                    onPressed: () => {},
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
