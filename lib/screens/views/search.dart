// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, unused_local_variable, non_constant_identifier_names, avoid_print, library_private_types_in_public_api, unnecessary_string_escapes

import 'package:chat_application_task/helper/app_images.dart';
import 'package:chat_application_task/helper/colors.dart';
import 'package:chat_application_task/screens/views/conversation_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../helper/constants.dart';
import '../../service/database/databse.dart';
import '../../widgets/widget.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchController = TextEditingController();
  DatabaseMethods databaseMethods = DatabaseMethods();
  QuerySnapshot? searchSnapshot;
  initiateSearch() async {
    await databaseMethods
        .getUsersByName(username: searchController.text)
        .then((val) {
      setState(() {
        searchSnapshot = val;
      });
//print("search kiya hai ${val.toString()}");
    });
  }
  //chat room send user to chat

  createChatRoomAndStartConversation({
    required String userName,
  }) {
    if (userName != Constants.myName) {
      String chatRoomId = getChatRoomId(userName, Constants.myName);
      List<String> users = [userName, Constants.myName];
      Map<String, dynamic> chatRoomMap = {
        "users": users,
        "chatroomId": chatRoomId
      };
      DatabaseMethods().createChatRoom(chatRoomId, chatRoomMap);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ConversationScreen(chatRoomId)));
    } else {
      print("you canot Show message Your Self");
    }
  }

  Widget SearchTile({required String userName, required String userEmail}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          Column(
            children: [
              Text(
                userName,
                style: simpleTextField(),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  userEmail,
                  style: simpleTextField(),
                ),
              ),
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: () {
              createChatRoomAndStartConversation(userName: userName);
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(30),
              ),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                "Message",
                style: simpleTextField(),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget searchList() {
    return searchSnapshot != null
        ? ListView.builder(
            itemCount: searchSnapshot!.docs.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return SearchTile(
                userName: searchSnapshot!.docs[index].get('name'),
                userEmail: searchSnapshot!.docs[index].get('email'),
              );
            },
          )
        : Center(
            child: Text("fhdsjfhds"),
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarMain(BuildContext, context),
      body: Column(
        children: [
          Container(
            color: AppColors.conversationScreenColour,
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Row(
              children: [
                Expanded(
                    child: TextField(
                  controller: searchController,
                  style: TextStyle(
                    color: Colors.white54,
                  ),
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Search Username. ..',
                      hintStyle: TextStyle(
                        color: Colors.white54,
                      )),
                )),
                GestureDetector(
                  onTap: () {
                    print("hust");
                    initiateSearch();
                  },
                  child: Container(
                    height: 40,
                    width: 40,
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [
                          AppColors.gradientColour1,
                          AppColors.gradientColour2,
                        ]),
                        borderRadius: BorderRadius.circular(40)),
                    child: Image.asset(AppImages.search),
                  ),
                )
              ],
            ),
          ),
          searchList()
        ],
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
