import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import './constatnts_colors.dart';
import '../helpers/helper_functions.dart';
import '../screens/search_screen.dart';
import '../screens/signin_screen.dart';
import '../screens/chat_rooms_screen.dart';
import '../screens/signup_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool userIsLoggedIn = false;
  @override
  void initState() {
    getLoggedInStat();
    super.initState();
  }

  getLoggedInStat() async {
    await HelperFunctions.getUserLoggedIn().then((value) {
      setState(() {
        userIsLoggedIn = value!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // child:
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Chat',
      theme: ThemeData(
        primaryColor: kPrimaryColor,
      ),
      home: userIsLoggedIn ? ChatRoomsScreen() : SignUpScreen(),
      // initialRoute: '/',
      routes: {
        SignUpScreen.routName: (context) => SignUpScreen(),
        ChatRoomsScreen.routName: (context) => ChatRoomsScreen(),
        SignInScreen.routName: (context) => SignInScreen(),
        SearchScreen.routName: (context) => SearchScreen(),
      },
      // ),
    );
  }
}
