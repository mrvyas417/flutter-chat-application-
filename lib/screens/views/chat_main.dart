import 'package:chat_application_task/helper/app_images.dart';
import 'package:chat_application_task/screens/views/search.dart';
import 'package:chat_application_task/service/auth/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

import '../../helper/authanticate.dart';
import '../../helper/constants.dart';
import '../../helper/helper_function.dart';
import '../../service/database/databse.dart';
import '../../widgets/widget.dart';
import 'conversation_screen.dart';

class ChatRoom extends StatefulWidget {
  const ChatRoom({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  AuthMethods authmethods = AuthMethods();
  DatabaseMethods databaseMethods = DatabaseMethods();

  Stream? chatRoomStream;
  Widget chatRoomList() {
    return StreamBuilder<QuerySnapshot>(
      stream: chatRoomStream as dynamic,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  return ChatRoomTile(
                    chatRoomID: snapshot.data!.docs[index].get('chatroomId'),
                    userName: snapshot.data!.docs[index]
                        .get('chatroomId')
                        .toString()
                        .replaceAll("_", "")
                        .replaceAll(Constants.myName, ""),
                  );
                },
              )
            : Container();
      },
    );
  }

  @override
  void initState() {
    getUserInfo();

    super.initState();
  }

  getUserInfo() async {
    Constants.myName = (await HelperFunctions.getUserNameInSharedPrefrence())!;
    databaseMethods.getChatRooms(Constants.myName).then((val) {
      setState(() {
        chatRoomStream = val;
      });
    });

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          AppImages.logo,
          height: 50,
        ),
        centerTitle: true,
        actions: [
          GestureDetector(
            onTap: () {
              authmethods.signOut(context);
              authmethods.logout();
              HelperFunctions.clearAllData();
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const Authanticate()));
            },
            child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: const Icon(Icons.exit_to_app)),
          )
        ],
      ),
      body: chatRoomList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const SearchScreen()));
        },
        child: const Icon(Icons.search),
      ),
    );
  }
}

class ChatRoomTile extends StatelessWidget {
  final String? userName;
  final String chatRoomID;
  const ChatRoomTile(
      {Key? key, required this.userName, required this.chatRoomID})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ConversationScreen(chatRoomID)));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(40)),
                border: Border.all(
                  width: 2,
                  color: Theme.of(context).primaryColor,
                ),
                // shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: Container(
                height: 40,
                width: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.circular(40)),
                child: Text(userName!.substring(0, 1).toUpperCase()),
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            Text(
              userName!,
              style: simpleTextField(),
            ),
          ],
        ),
      ),
    );
  }
}
