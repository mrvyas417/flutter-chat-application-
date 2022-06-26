// ignore_for_file: avoid_print, await_only_futures

import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  getUsersByName({required String username}) async {
    return await FirebaseFirestore.instance
        .collection("Users")
        .where("name", isEqualTo: username)
        .get()
        .catchError((e) {
      print("error hua kyonki ${e.toString()}");
    });
  }

  getUsersByEmail({required String email}) async {
    return await FirebaseFirestore.instance
        .collection("Users")
        .where("email", isEqualTo: email)
        .get()
        .catchError((e) {
      print("error hua kyonki ${e.toString()}");
    });
  }

  uploadeUserinfo(usermap) {
    FirebaseFirestore.instance.collection("Users").add(usermap).catchError((e) {
      //print("uploade nhi hua kyonki ${e.toString()}");
    });
  }

  createChatRoom(String chatRoomId, chatRoomMap) {
    FirebaseFirestore.instance
        .collection("ChatRoom")
        .doc(chatRoomId)
        .set(chatRoomMap)
        .catchError((e) {
      print("error  ${e.toString()}");
    });
  }

  addConverSationMessages(String chatRoomId, messageMap) {
    FirebaseFirestore.instance
        .collection('ChatRoom')
        .doc(chatRoomId)
        .collection('chats')
        .add(messageMap)
        .catchError((e) {
      print("error  hua kyonki ${e.toString()}");
    });
  }

  getConverSationMessages(String chatRoomId) async {
    return await FirebaseFirestore.instance
        .collection('ChatRoom')
        .doc(chatRoomId)
        .collection('chats')
        .orderBy("time")
        .snapshots();
  }

  getChatRooms(String username) async {
    return await FirebaseFirestore.instance
        .collection("ChatRoom")
        .where("users", arrayContains: username)
        .snapshots();
  }
}
