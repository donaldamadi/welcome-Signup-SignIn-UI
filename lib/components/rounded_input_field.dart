import 'package:flutter/material.dart';
import 'package:welcome_page/constants.dart';

class RoundedInputField extends StatelessWidget {
  final String hintText;
  final Function onChanged;
  final Function validator;
  RoundedInputField({this.hintText, this.onChanged, this.validator});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Material(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        margin: EdgeInsets.symmetric(vertical: 10),
        width: size.width * 0.8,
        decoration: BoxDecoration(
            color: kSecondaryColor, borderRadius: BorderRadius.circular(29)),
        child: TextFormField(
          validator: validator,
          keyboardType: TextInputType.emailAddress,
          onChanged: onChanged,
          cursorColor: kPrimaryColor,
          decoration: InputDecoration(
              icon: Icon(
            Icons.person,
            color: kPrimaryColor,
          ),
          hintText: hintText,
          border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}
