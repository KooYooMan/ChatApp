import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  final IconData icon;
  final String hint;
  final TextEditingController controller;
  final GlobalKey<FormState> formKey;
  final String Function(String) validator;
  InputField({this.icon, this.hint, this.controller, this.formKey, this.validator});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(
              color: Color(0xFFBC7C7C7),
              width: 2
          ),
          borderRadius: BorderRadius.circular(50)
      ),
      child: Row(
        children: <Widget>[
          Container(
              width: 60,
              child: Icon(
                icon,
                size: 20,
                color: Color(0xFFBB9B9B9),
              )
          ),
          Expanded(
            child: TextFormField(
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 20),
                  border: InputBorder.none,
                  hintText: hint
              ),
              validator: validator,
              controller: controller,
            ),
          )
        ],
      ),
    );
  }
}

// made for emails



// implemented for password

class HiddenInputField extends StatelessWidget {
  final IconData icon;
  final String hint;
  final TextEditingController controller;
  final GlobalKey<FormState> formKey;
  final String Function(String) validator;


  HiddenInputField({this.icon, this.hint, this.controller, this.formKey, this.validator});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(
              color: Color(0xFFBC7C7C7),
              width: 2
          ),
          borderRadius: BorderRadius.circular(50)
      ),
      child: Row(
        children: <Widget>[
          Container(
              width: 60,
              child: Icon(
                icon,
                size: 20,
                color: Color(0xFFBB9B9B9),
              )
          ),
          Expanded(
            child: TextFormField(
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 20),
                  border: InputBorder.none,
                  hintText: hint
              ),
              validator: validator,
              // onSaved: (val) =>  = val,
              obscureText: true,
              controller: controller,
            ),
          )
        ],
      ),
    );
  }
}


