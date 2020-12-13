import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:welcome_page/components/account_check.dart';
import 'package:welcome_page/components/background.dart';
import 'package:welcome_page/components/rounded_button.dart';
import 'package:welcome_page/components/rounded_input_field.dart';
import 'package:welcome_page/components/or_divider.dart';
import 'package:welcome_page/components/password_field.dart';
import 'package:welcome_page/components/social_icon.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:welcome_page/helpers/helperfunctions.dart';
import 'package:welcome_page/services/auth.dart';
import 'package:welcome_page/services/database.dart';
import 'package:welcome_page/views/opening_page.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  final formKey = GlobalKey<FormState>();
  bool showSpinner = false;
  AuthMethods authMethods = AuthMethods();
  DataBaseMethods dataBaseMethods = DataBaseMethods();
  String email, password, name;

  signMeUp() {
    if (formKey.currentState.validate()) {
      Map<String, String> userInfoMap = {
        'name': name,
        'email': email,
      };
      HelperFunctions.saveUserEmailSharedPreference(email);
      HelperFunctions.saveUserNameSharedPreference(name);

      setState(() {
        showSpinner = true;
      });

      authMethods.signUpWithEmailAndPassword(email, password).then((value) {
        dataBaseMethods.uploadUserInfo(userInfoMap);
        HelperFunctions.saveUserLoggedInSharedPreference(true);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => OpeningPage()));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Background(
        child: Form(
          key: formKey,
          child: ModalProgressHUD(
            inAsyncCall: showSpinner,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset('assets/icons/sign-up.svg', height: 300),
                  SizedBox(height: 50),
                  RoundedInputField(
                    validator: (value) {
                      return value.isEmpty || value.length < 6
                          ? 'Your username must be up to 6 characters'
                          : null;
                    },
                    hintText: 'Username',
                    onChanged: (val) {
                      name = val;
                    },
                  ),
                  SizedBox(height: 10),
                  RoundedInputField(
                    validator: (value) {
                      return RegExp(
                                  r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
                              .hasMatch(value)
                          ? null
                          : "Please provide a valid email";
                    },
                    onChanged: (val) {
                      email = val;
                    },
                    hintText: 'Email address',
                  ),
                  SizedBox(height: 10),
                  PasswordField(
                    validator: (value) {
                      return value.length > 6
                          ? null
                          : "Password should be more than 6 characters";
                    },
                    onChanged: (val) {
                      password = val;
                    },
                  ),
                  SizedBox(height: 10),
                  RoundedButton(
                    string: 'Sign Up',
                    onPress: () {
                      signMeUp();
                    },
                  ),
                  AccountCheck(
                    accountCheck: true,
                  ),
                  ORDivider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SocialIcon(
                        iconSrc: 'assets/icons/facebook.svg',
                        press: () {},
                      ),
                      SocialIcon(
                        iconSrc: 'assets/icons/google-plus.svg',
                        press: () {},
                      ),
                      SocialIcon(
                        iconSrc: 'assets/icons/twitter.svg',
                        press: () {},
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
