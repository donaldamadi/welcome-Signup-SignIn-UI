import 'package:flutter/material.dart';
import 'package:welcome_page/constants.dart';

class PasswordField extends StatefulWidget {
  final Function validator;
  final Function onChanged;
  PasswordField({this.onChanged, this.validator});

  @override
  _PasswordFieldState createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool obscureText = true;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Material(
      color: Colors.white,
      child: Container(
        width: size.width * 0.8,
        margin: EdgeInsets.symmetric(horizontal: 10),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        decoration: BoxDecoration(
            color: kSecondaryColor, borderRadius: BorderRadius.circular(29)),
        child: TextFormField(
            onChanged: widget.onChanged,
            validator: widget.validator,
            obscureText: obscureText,
            cursorColor: kPrimaryColor,
            decoration: InputDecoration(
                hintText: 'Password',
                icon: Icon(
                  Icons.lock,
                  color: kPrimaryColor,
                ),
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      obscureText = !obscureText;
                    });
                  },
                  icon: Icon(Icons.visibility),
                  color: kPrimaryColor,
                ),
                border: InputBorder.none)),
      ),
    );
  }
}
