import 'package:cloud_firestore/cloud_firestore.dart';

class DataBaseMethods {
  uploadUserInfo(userMap) {
    FirebaseFirestore.instance.collection('users').add(userMap).catchError((e) {
      print(e.toString());
    });
  }

  getUserByUserName(String userName) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .where('name', isEqualTo: userName)
        .get();
  }

  getUserByUserEmail(String userEmail) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: userEmail)
        .get();
  }

  createGameRoom(String chatRoomId, chatRoomMap) {
    FirebaseFirestore.instance
        .collection('GameRoom')
        .doc(chatRoomId)
        .set(chatRoomMap)
        .catchError((e) {
      print(e.toString());
    });
  }

  getGameRooms(String userName) async {
    return await FirebaseFirestore.instance
        .collection('GameRoom')
        .where('users', arrayContains: userName)
        .snapshots();
  }

  addConversationMessages(String chatRoomId, messageMap){
    FirebaseFirestore.instance.collection('GameRoom').doc(chatRoomId).collection('chats').add(messageMap).catchError((e){print(e.toString());});
  }

  getConversationMessages(String chatRoomId) async{
    return await FirebaseFirestore.instance.collection('GameRoom').doc(chatRoomId).collection('chats').orderBy('time', descending: true).snapshots();
  }

  deleteConversationMessages(String chatRoomId) async{
    FirebaseFirestore.instance.collection('GameRoom').doc(chatRoomId).collection('chats').get().then((snapshot) {
      for (DocumentSnapshot ds in snapshot.docs){
        ds.reference.delete();
      }
    });
  }
}
