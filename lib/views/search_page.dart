import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:welcome_page/constants.dart';
import 'package:welcome_page/services/database.dart';

import 'game_screen.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  DataBaseMethods dataBaseMethods = DataBaseMethods();
  String searchText;
  QuerySnapshot searchSnapshot;

  Widget searchList() {
    return searchSnapshot != null 
        ? ListView.builder(
            itemCount: searchSnapshot.docs.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return searchTile(
                  userName: searchSnapshot.docs[index].data()['name'],
                  userEmail: searchSnapshot.docs[index].data()['email']);
            },
          )
        : Expanded(child: Center(child: Text('No user with this name')),);
  }

  initiateSearch() {
    dataBaseMethods.getUserByUserName(searchText).then((val) {
      setState(() {
        print(val.toString());
        searchSnapshot = val;
      });
    });
  }

  //create ChatRoom, send user to game screen, pushReplacement
  createGameRoomAndStartGame({String userName}) {
    if (userName != Constants.myName) {
      String chatRoomId = getChatRoomId(userName, Constants.myName);

      List<String> users = [userName, Constants.myName];
      Map<String, dynamic> chatRoomMap = {
        'users': users,
        'chatRoomId': chatRoomId,
      };

      DataBaseMethods().createGameRoom(chatRoomId, chatRoomMap);
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => GameScreen(chatRoomId, userName)));
    } else {
      print('You cannot send a message to yourself');
    }
  }

  Widget searchTile({String userName, String userEmail}) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(userName ?? 'Error'),
                Text(userEmail ?? 'Error'),
              ],
            ),
            Spacer(),
            GestureDetector(
              onTap: () {
                createGameRoomAndStartGame(userName: userName);
              },
              child: Container(
                  decoration: BoxDecoration(
                      color: kSecondaryColor,
                      borderRadius: BorderRadius.circular(20)),
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: Text('Request')),
            )
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Search for player by username',
          style: GoogleFonts.pacifico(),
        ),
      ),
      body: Container(
        child: Column(
          children: [
            Container(
              color: kSecondaryColor,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: (val) {
                        searchText = val;
                      },
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                          hintText: 'Search Username...',
                          hintStyle: TextStyle(color: Colors.white54),
                          border: InputBorder.none),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      initiateSearch();
                    },
                    child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [
                              const Color(0x36FFFFFF),
                              const Color(0x0FFFFFFF),
                            ]),
                            borderRadius: BorderRadius.circular(10)),
                        padding: EdgeInsets.all(12),
                        child: Icon(Icons.search)),
                  ),
                ],
              ),
            ),
            searchList(),
          ],
        ),
      ),
    );
  }
}

getChatRoomId(String a, String b) {
  if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
    return "$b\_$a";
  } else {
    return "$a\_$b";
  }
}
