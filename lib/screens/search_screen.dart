import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../constatnts_colors.dart';
import '../helpers/costants.dart';
import '../helpers/helper_functions.dart';
import '../screens/conversation_screen.dart';
import '../services/database.dart';
import '../widgets/widgets.dart';


class SearchScreen extends StatefulWidget {
  static const routName = '/search';

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

String? _myName;

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchController = TextEditingController();
  Database database = Database();

  QuerySnapshot? searchSnapshot;

  Widget searchList() {
    return searchSnapshot != null
        ? ListView.builder(
            itemCount: searchSnapshot!.docs.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return searchTile(
                userName: searchSnapshot!.docs[index].get('name'),
                userEmail: searchSnapshot!.docs[index].get('email'),
              );
            },
          )
        : Container();
  }

  void initiateSearch() {
    database.getUserByUsername(searchController.text).then((value) {
      setState(() {
        searchSnapshot = value;
      });
    });
  }

  createChatRoomAndStartConversation(String userName) {
    print('${Constants.myName}');
    if (userName != Constants.myName) {
      String chatRoomId = getChatRooId(userName, Constants.myName);

      List<String> user = [userName, Constants.myName];
      Map<String, dynamic> chatRoomMap = {
        'user': user,
        'charoomId': chatRoomId,
      };

      database.createChatRoom(chatRoomId, chatRoomMap);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ConversationScreen(chatRoomId)));
    } else {
      print('you cant send message to yourself');
    }
  }

  Widget searchTile({required String userName, required String userEmail}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(userName, style: mediumTextStyle()),
              Text(userEmail, style: mediumTextStyle()),
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: () {
              createChatRoomAndStartConversation(userName);
            },
            child: Container(
              decoration: BoxDecoration(
                color: kPrimaryColor,
                borderRadius: BorderRadius.circular(30),
              ),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Text(
                'Message',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  initState() {
    getUserInfo();
    super.initState();
  }

  getUserInfo() async {
    _myName = await HelperFunctions.getUserName();
    setState(() {});
    print('$_myName');
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: appBarMain(context),
      body: Container(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 19),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextField(
                      controller: searchController,
                      decoration: textFiledInputDocration('Search username...'),
                    ),
                  ),
                  IconButton(
                    padding: EdgeInsets.all(8),
                    onPressed: () {
                      initiateSearch();
                    },
                    icon: Icon(
                      Icons.search,
                      size: size.width * 0.09,
                      color: kPrimaryColor,
                    ),
                  )
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

getChatRooId(String a, String b) {
  if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
    return '$b\_$a';
  } else {
    return '$a\_$b';
  }
}
