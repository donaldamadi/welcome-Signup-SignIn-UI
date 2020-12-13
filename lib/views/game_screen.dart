import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:welcome_page/components/background.dart';
import 'package:welcome_page/components/message_tile.dart';
import 'package:welcome_page/constants.dart';
import 'package:welcome_page/services/database.dart';
import 'package:welcome_page/services/http.dart';
import 'package:welcome_page/services/word.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
// import 'package:http/http.dart' as http;

class GameScreen extends StatefulWidget {
  final String chatRoomId;
  final String userName;
  GameScreen(this.chatRoomId, this.userName);
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  APIService apiService = APIService();
  DataBaseMethods dataBaseMethods = DataBaseMethods();
  TextEditingController messageController = TextEditingController();
  Stream messagesStream;
  String word;
  Future<String> text;
  WordModel wordModel = WordModel();

  Widget gameMessagesList() {
    return StreamBuilder(
      stream: messagesStream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  reverse: true,
                  shrinkWrap: true,
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index) {
                    return MessageTile(
                        message:
                            snapshot.data.documents[index].data()['message'],
                        isSentByMe:
                            snapshot.data.documents[index].data()['sentBy'] ==
                                Constants.myName);
                  },
                ),
              )
            : Expanded(
                child: Center(
                    child: Text(
                  'Messages are loading ...',
                  style:
                      GoogleFonts.pacifico(color: kPrimaryColor, fontSize: 30),
                )),
              );
      },
    );
  }

  sendMessage() {
    if (messageController.text.isNotEmpty) {
      Map<String, dynamic> messageMap = {
        'message': messageController.text,
        'sentBy': Constants.myName,
        'time': DateTime.now().microsecondsSinceEpoch,
      };
      dataBaseMethods.addConversationMessages(widget.chatRoomId, messageMap);
      messageController.clear();
    }
  }

  void changeWord() {
    setState(() {
      text = getWord();
    });
  }

  checkWord() {
    if (messageController.text.isNotEmpty) {
      if (messageController.text == word) {
        Map<String, dynamic> messageMap = {
          'message': messageController.text,
          'sentBy': Constants.myName,
          'time': DateTime.now().microsecondsSinceEpoch,
        };
        dataBaseMethods.addConversationMessages(widget.chatRoomId, messageMap);
        print('${Constants.myName} got it');
        changeWord();
        messageController.clear();
      } else {
        Map<String, dynamic> messageMap = {
          'message': messageController.text,
          'sentBy': Constants.myName,
          'time': DateTime.now().microsecondsSinceEpoch,
        };
        dataBaseMethods.addConversationMessages(widget.chatRoomId, messageMap);
        messageController.clear();
      }
    }
  }

  Future<String> getWord() async {
    var word = await apiService.getData();
    return word;
  }

  @override
  void initState() {
    text = getWord();
    dataBaseMethods.getConversationMessages(widget.chatRoomId).then((value) {
      setState(() {
        messagesStream = value;
      });
    });
    super.initState();
  }

  @override
  void deactivate() {
    dataBaseMethods.deleteConversationMessages(widget.chatRoomId);
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('GameScreen'),
        automaticallyImplyLeading: false,
        actions: [
          RaisedButton(
              color: Colors.grey,
              onPressed: () {
                changeWord();
              },
              child: Text('start'))
        ],
      ),
      body: DoubleBackToCloseApp(
        snackBar:
            const SnackBar(content: Text('Press back again to leave game')),
        child: Background(
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  height: 80,
                  color: kSecondaryColor.withOpacity(0.5),
                  child: Row(children: [
                    Text("The text is "),
                    FutureBuilder(
                      future: text,
                      builder: (BuildContext context,
                          AsyncSnapshot<dynamic> snapshot) {
                        if (snapshot.hasData) {
                          word = snapshot.data;
                          return Text(
                            '${snapshot.data}',
                            // style: GoogleFonts.roboto(
                            //     color: Colors.white, fontSize: 30)
                          );
                        }
                        return Text('');
                      },
                    ),
                  ]),
                ),
                gameMessagesList(),
                Container(
                  alignment: Alignment.bottomCenter,
                  decoration: kMessageContainerDecoration,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: TextField(
                          controller: messageController,
                          decoration: kMessageTextFieldDecoration,
                        ),
                      ),
                      FlatButton(
                        onPressed: () {
                          checkWord();
                        },
                        child: Text(
                          'Send',
                          style: GoogleFonts.pacifico(
                              color: kPrimaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
