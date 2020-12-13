import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:welcome_page/components/account_check.dart';
import 'package:welcome_page/components/background.dart';
import 'package:welcome_page/components/rounded_button.dart';
import 'package:welcome_page/components/rounded_input_field.dart';
import 'package:welcome_page/components/password_field.dart';
import 'package:welcome_page/helpers/helperfunctions.dart';
import 'package:welcome_page/services/auth.dart';
import 'package:welcome_page/services/database.dart';
import 'package:welcome_page/views/welcome_page.dart';

import 'opening_page.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  DataBaseMethods dataBaseMethods = DataBaseMethods();
  AuthMethods authMethods = AuthMethods();
  final formKey = GlobalKey<FormState>();
  String email, password;
  bool showSpinner = false;
  QuerySnapshot snapshotUserInfo;

  signIn() {
    if (formKey.currentState.validate()) {
      HelperFunctions.saveUserEmailSharedPreference(email);

      dataBaseMethods.getUserByUserEmail(email).then((value) {
        snapshotUserInfo = value;
        HelperFunctions.saveUserNameSharedPreference(
            snapshotUserInfo.docs[0].data()['name']);
      });
      setState(() {
        showSpinner = true;
      });
      authMethods.signInWithEmailAndPassword(email, password).then((value) {
        if (value != null) {
          HelperFunctions.saveUserLoggedInSharedPreference(true);
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => OpeningPage()));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Background(
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/icons/sign-in.svg',
                  height: 300,
                ),
                SizedBox(height: 50),
                RoundedInputField(
                  hintText: 'email address',
                  onChanged: (value) {
                    email = value;
                  },
                  validator: (val) {
                    return RegExp(
                                r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
                            .hasMatch(val)
                        ? null
                        : "Please provide a valid email";
                  },
                ),
                SizedBox(height: 10),
                PasswordField(
                  validator: (value) {
                    return value.length > 6
                        ? null
                        : 'Please password should be more than 6 characters';
                  },
                  onChanged: (val) {
                    password = val;
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                RoundedButton(
                  onPress: () {
                    signIn();
                  },
                  string: 'Sign In',
                ),
                SizedBox(height: 30),
                AccountCheck(
                  accountCheck: false,
                )
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
