import 'package:flutter/material.dart';

const kPrimaryColor = Color(0xFF0097A7);
const kSecondaryColor = Color(0xFF2EC4D4);

const kMessageTextFieldDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  hintText: 'Type your message here...',
  border: InputBorder.none,
);

const kMessageContainerDecoration = BoxDecoration(
  border: Border(
    top: BorderSide(color: kSecondaryColor, width: 2.0),
  ),
);

class Constants {
  static String myName = "";
}
