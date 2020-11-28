import 'package:flutter/material.dart';

class NeOutlineButton extends StatelessWidget {
  final String text;
  NeOutlineButton({this.text});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Color(0xFFB40284A),
          width: 2
        ),
        borderRadius: BorderRadius.circular(30)
      ),
      padding: EdgeInsets.all(20),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            color: Color(0xFFB40284A),
            fontSize: 16
          )
        ),
      ),
    );
  }
}

class PrimaryButton extends StatelessWidget {
  final String text;
  PrimaryButton({this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Color(0xFFB40284A),
          borderRadius: BorderRadius.circular(30)

      ),
      padding: EdgeInsets.all(20),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16
          )
        ),

      ),
    );
  }

}
