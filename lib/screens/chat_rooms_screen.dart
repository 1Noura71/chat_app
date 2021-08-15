import 'package:flutter/material.dart';

import '../constatnts_colors.dart';
import '../helpers/costants.dart';
import '../helpers/helper_functions.dart';
import '../screens/search_screen.dart';
import '../screens/signin_screen.dart';
import '../services/database.dart';
import '../widgets/widgets.dart';
import '../services/auth.dart';
import './conversation_screen.dart';

class ChatRoomsScreen extends StatefulWidget {
  static const routName = '/chat-rooms';
  @override
  _ChatRoomsScreenState createState() => _ChatRoomsScreenState();
}

class _ChatRoomsScreenState extends State<ChatRoomsScreen> {
  AuthServices authServices = AuthServices();
  Database database = Database();

  Stream? chatRoomsStream;

  Widget chatRoomList() {
    return StreamBuilder(
        stream: chatRoomsStream,
        builder: (context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.data != null) {
            return ListView.builder(
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index) {
                return ChatRoomsTile(
                    snapshot.data.docs[index]
                        .data()['charoomId']
                        .toString()
                        .replaceAll('_', '')
                        .replaceAll(Constants.myName, ''),
                    snapshot.data.docs[index].data()['charoomId']);
              },
            );
          } else {
            return Container();
          }
        });
  }

  @override
  void initState() {
    getUserInof();
    super.initState();
  }

  getUserInof() async {
    Constants.myName = await HelperFunctions.getUserName();
    database.getChatRooms(Constants.myName).then((value) {
      setState(() {
        chatRoomsStream = value;
      });
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chats'),
        elevation: 0.0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await authServices.signOut();
              Navigator.of(context).pop();
              Navigator.of(context).pushNamed(SignInScreen.routName);
            },
          )
        ],
      ),
      body: chatRoomList(),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.search,
        ),
        backgroundColor: kPrimaryColor,
        onPressed: () {
          Navigator.of(context).pushNamed(SearchScreen.routName);
        },
      ),
    );
  }
}

class ChatRoomsTile extends StatelessWidget {
  final String chatRoomId;
  final String userName;
  ChatRoomsTile(this.userName, this.chatRoomId);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ConversationScreen(chatRoomId)));
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 23, vertical: 16),
        child: Row(
          children: [
            Container(
              alignment: Alignment.center,
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: kPrimaryLightColor,
                borderRadius: BorderRadius.circular(40),
              ),
              child: Text(
                '${userName.substring(0, 1).toUpperCase()}',
                style: mediumTextStyle(),
              ),
            ),
            SizedBox(width: 8),
            Text(
              userName,
              style: mediumTextStyle(),
            ),
          ],
        ),
      ),
    );
  }
}
