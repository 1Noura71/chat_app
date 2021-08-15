import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../helpers/helper_functions.dart';
import '../screens/signup_screen.dart';
import '../services/database.dart';
import '../services/auth.dart';
import '../constatnts_colors.dart';
import '../widgets/widgets.dart';
import './chat_rooms_screen.dart';

class SignInScreen extends StatefulWidget {
  static const routName = '/sign-In';
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  AuthServices authServices = AuthServices();
  Database database = Database();
  bool isLoading = false;
  QuerySnapshot? snapshotInfo;

  signIn() async {
    if (formKey.currentState!.validate()) {
      HelperFunctions.saveUserEmail(emailController.text);
      database.getUserByUserEmail(emailController.text).then((value) {
        snapshotInfo = value;
        HelperFunctions.saveUserName(snapshotInfo!.docs[0].get('name'));
        print('${snapshotInfo!.docs[0].get('name')}');
      });

      setState(() {
        isLoading = true;
      });

      await authServices
          .signInWithEmailAndPassword(
              emailController.text.trimRight(), passwordController.text)
          .then((result) {
        if (result != null) {
          HelperFunctions.saveUserLoggedIn(true);
          Navigator.of(context).pushReplacementNamed(ChatRoomsScreen.routName);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      // appBar: appBarMain(context),
      body: SingleChildScrollView(
        child: Container(
          height: height - 20,
          alignment: Alignment.bottomCenter,
          child: Container(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(
                      'assets/icons/login.svg',
                      height: height * 0.35,
                    ),
                    TextFormField(
                      controller: emailController,
                      style: simpleTextStyle(),
                      decoration: textFiledInputDocration('Email'),
                    ),
                    TextFormField(
                      obscureText: true,
                      controller: passwordController,
                      style: simpleTextStyle(),
                      decoration: textFiledInputDocration('Password'),
                    ),
                    SizedBox(height: 8),
                    Container(
                      alignment: Alignment.centerRight,
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Text(
                          'Forget Password?',
                          style: simpleTextStyle(),
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    GestureDetector(
                      onTap: () => signIn(),
                      child: Container(
                        alignment: Alignment.center,
                        width: width,
                        padding: EdgeInsets.symmetric(vertical: 20),
                        decoration: BoxDecoration(
                          color: kPrimaryColor,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text('Sign In',
                            style: mediumTextStyle(color: Colors.white)),
                      ),
                    ),
                    SizedBox(height: 16),
                    Container(
                      alignment: Alignment.center,
                      width: width,
                      padding: EdgeInsets.symmetric(vertical: 20),
                      decoration: BoxDecoration(
                        color: kPrimaryLightColor,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(
                        'Sign In with Google',
                        style: mediumTextStyle(color: Colors.black87),
                      ),
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Don\'t have an account? ',
                          style: mediumTextStyle(),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.of(context)
                              .pushNamed(SignUpScreen.routName),
                          child: Text(
                            'Register now',
                            style: mediumTextStyle(
                                textDco: TextDecoration.underline),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              )),
        ),
      ),
    );
  }
}
