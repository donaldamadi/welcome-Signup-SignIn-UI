import 'package:flutter/material.dart';
import 'package:welcome_page/constants.dart';

class AccountCheck extends StatelessWidget {
  final bool accountCheck;
  AccountCheck({this.accountCheck});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
            accountCheck
                ? 'Already have an account? '
                : 'Don\'t have an account? ',
            style:
                TextStyle(fontWeight: FontWeight.w400, color: kPrimaryColor)),
        GestureDetector(
          onTap: () {
            accountCheck
                ? Navigator.popAndPushNamed(context, '/signIn')
                : Navigator.popAndPushNamed(context, '/signUp');
          },
          child: Padding(
            padding: const EdgeInsets.fromLTRB(2, 8, 8, 8),
            child: Text(
              accountCheck ? 'Sign In' : 'Sign Up',
              style: TextStyle(fontWeight: FontWeight.w800, color: kPrimaryColor),
            ),
          ),
        )
      ],
    );
  }
}
