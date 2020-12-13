import 'package:flutter/material.dart';
import 'package:welcome_page/constants.dart';
import 'package:google_fonts/google_fonts.dart';

class RoundedButton extends StatelessWidget {
  final Function onPress;
  final String string;
  final Color color, textColor;
  RoundedButton(
      {@required this.onPress,@required this.string, this.color = kPrimaryColor, this.textColor = Colors.white});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      width: size.width * 0.8,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(29),
        child: FlatButton(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          color: color,
          onPressed: onPress,
          child: Text(
            string,
            style: GoogleFonts.pacifico(
              textStyle: TextStyle(color: textColor, fontSize: 20)
            ),
          ),
        ),
      ),
    );
  }
}
