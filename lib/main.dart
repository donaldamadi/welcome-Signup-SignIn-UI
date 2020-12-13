import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:welcome_page/helpers/helperfunctions.dart';
import 'package:welcome_page/views/opening_page.dart';
import 'package:welcome_page/views/sign_in.dart';
import 'package:welcome_page/views/sign_up.dart';
import 'package:welcome_page/views/welcome_page.dart';
import 'constants.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // runApp(DevicePreview(
  //   enabled: !kReleaseMode,
  //   builder: (context) => MyApp()));
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool userLoggedIn = false;

  @override
  void initState() {
    getLoggedInState();
    super.initState();
  }

  getLoggedInState() async{
    await HelperFunctions.getUserLoggedInSharedPreference().then((value) {
      setState((){
        // userLoggedIn = value;
        if(userLoggedIn == null){
          userLoggedIn = false;
        }else{
          userLoggedIn = value;
        }
        print(value);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      // initialRoute: userLoggedIn ? '/openingPage' : '/',
      home: userLoggedIn ? OpeningPage() : WelcomePage(),
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: kPrimaryColor,
        accentColor: kSecondaryColor,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routes: {
        // '/' : (context) => WelcomePage(),
        '/signUp' : (context) => SignUp(),
        '/signIn' : (context) => SignIn(),
        '/openingPage' : (context) => OpeningPage(),
      },
    );
  }
}

