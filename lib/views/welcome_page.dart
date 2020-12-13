import 'package:flutter/material.dart';
import 'package:welcome_page/components/background.dart';
import 'package:flutter_svg/svg.dart';
import 'package:welcome_page/components/rounded_button.dart';
import 'package:welcome_page/constants.dart';
import 'package:welcome_page/views/sign_in.dart';
import 'package:welcome_page/views/sign_up.dart';

class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          SvgPicture.asset('assets/icons/welcome.svg', height: 300),
          SizedBox(height: 50),
          RoundedButton(
            string: 'Sign Up',
            onPress: () {
              // Navigator.pop(context);
              // Navigator.push(context, MaterialPageRoute(builder: (context) => SignUp()));
              Navigator.popAndPushNamed(context, '/signUp');
            },
          ),
          SizedBox(height: 10),
          RoundedButton(
            string: 'Sign In',
            onPress: () {
              // Navigator.pop(context);
              // Navigator.push(context, MaterialPageRoute(builder: (context) => SignIn()));
              Navigator.popAndPushNamed(context, '/signIn');
            },
            color: kSecondaryColor,
          ),
        ]),
      ),
    );
  }
}
