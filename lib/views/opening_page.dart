import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:welcome_page/components/background.dart';
import 'package:welcome_page/components/rounded_button.dart';
import 'package:welcome_page/constants.dart';
import 'package:welcome_page/helpers/helperfunctions.dart';
import 'package:welcome_page/services/auth.dart';
import 'package:welcome_page/services/database.dart';
import 'package:welcome_page/services/http.dart';
import 'package:welcome_page/views/search_page.dart';
import 'package:welcome_page/views/sign_in.dart';

class OpeningPage extends StatefulWidget {
  @override
  _OpeningPageState createState() => _OpeningPageState();
}

class _OpeningPageState extends State<OpeningPage>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation animation;
  AuthMethods authMethods = AuthMethods();
  DataBaseMethods dataBaseMethods = DataBaseMethods();
  Stream chatRoomsStream;
  APIService apiService = APIService();

  @override
  void initState() {
    getUserInfo();
    super.initState();

    controller = AnimationController(
      duration: Duration(seconds: 3),
      vsync: this,
    );
    animation = CurvedAnimation(parent: controller, curve: Curves.bounceIn);

    controller.forward();
    controller.addListener(() {
      setState(() {});
    });
  }

  getUserInfo() async {
    Constants.myName = await HelperFunctions.getUserNameSharedPreference();
    dataBaseMethods.getGameRooms(Constants.myName).then((value) {
      setState((){
        chatRoomsStream = value;
      });
    });
    setState((){});
  }

  signOut() async {
    authMethods.signOut();
    HelperFunctions.saveUserLoggedInSharedPreference(false);
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => SignIn()));
  }

  // getWord() async {
  //   var word = await APIService().getData();
  //   return word;
  // }

  @override
  Widget build(BuildContext context) {
    // setState(() {});

    return Scaffold(
        body: Background(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            FutureBuilder(
              future: APIService().getData(),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.hasData) {
                  return Text('${snapshot.data}', style: GoogleFonts.pacifico(color: kPrimaryColor, fontSize: 30));
                }
                return Text('');
              },
            ),
            SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'sign out',
                  style:
                      GoogleFonts.pacifico(color: kPrimaryColor, fontSize: 20),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Color(0xFFFEF2F4),
                  ),
                  child: IconButton(
                    icon: Icon(Icons.exit_to_app),
                    onPressed: () {
                      signOut();
                    },
                  ),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Container(
                      child: Image.asset('assets/images/texting.png'),
                      height: animation.value * 100,
                    ),
                    Text(
                      'TypeFast',
                      style: TextStyle(
                        fontSize: 45,
                        color: kPrimaryColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                RoundedButton(
                  onPress: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => SearchPage()));
                  },
                  string: 'Search For Player Name',
                ),
                SizedBox(height: 10),
                RoundedButton(
                  onPress: () {},
                  string: 'Search For Random player',
                  color: kSecondaryColor,
                ),
              ],
            ),
          ],
        ),
      ),
    ));
  }
}
