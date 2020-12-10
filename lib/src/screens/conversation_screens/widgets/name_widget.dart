import 'package:flutter/material.dart';

class NameWidget extends StatelessWidget {
  NameWidget(this.name);
  final String name;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            SizedBox(width: 60.0,),
            Container(
              child: Text(
                name,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12.0,
                  fontStyle: FontStyle.normal
                ),
              ),

            ),
          ],
        ),
        SizedBox(height: 5.0),
      ],
    );
  }
}
