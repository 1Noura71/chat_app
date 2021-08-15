import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';

import '../helpers/helper_functions.dart';
import '../widgets/widgets.dart';
import '../constatnts_colors.dart';
import '../screens/chat_rooms_screen.dart';
import '../screens/signin_screen.dart';
import '../services/auth.dart';
import '../services/database.dart';

class SignUpScreen extends StatefulWidget {
  static const routName = '/signup';
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;
  AuthServices authServices = AuthServices();
  Database database = Database();

  signUp() async {
    Map<String, String> userInfoMap = {
      'name': usernameController.text,
      'email': emailController.text,
    };

    HelperFunctions.saveUserEmail(emailController.text);
    HelperFunctions.saveUserName(usernameController.text);

    if (formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      await authServices
          .signUp(emailController.text.trimRight(), passwordController.text)
          .then((result) {
        if (result != null) {
        database.uploadUserInfo(userInfoMap);
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
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
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
                            'assets/icons/signup.svg',
                            height: height * 0.35,
                          ),
                          TextFormField(
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please Enter a username';
                              } else if (value.length < 3) {
                                return 'Username must be greater than 3 characters';
                              }
                              return null;
                            },
                            controller: usernameController,
                            style: simpleTextStyle(),
                            decoration: textFiledInputDocration('Username'),
                          ),
                          TextFormField(
                            validator: (value) {
                              return RegExp(
                                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                      .hasMatch(value!)
                                  ? null
                                  : 'Enter correct email';
                            },
                            controller: emailController,
                            style: simpleTextStyle(),
                            decoration: textFiledInputDocration('Email'),
                          ),
                          TextFormField(
                            obscureText: true,
                            validator: (value) {
                              return value!.length < 6
                                  ? 'Please enter password greater than 6 characters'
                                  : null;
                            },
                            controller: passwordController,
                            style: simpleTextStyle(),
                            decoration: textFiledInputDocration('Password'),
                          ),
                          SizedBox(height: 8),
                          Container(
                            alignment: Alignment.centerRight,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              child: Text(
                                'Forget Password?',
                                style: simpleTextStyle(),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          GestureDetector(
                            onTap: () {
                              signUp();
                            },
                            child: Container(
                              alignment: Alignment.center,
                              width: width,
                              padding: EdgeInsets.symmetric(vertical: 20),
                              decoration: BoxDecoration(
                                color: kPrimaryColor,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Text('Sign Up',
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
                                'Already have a account? ',
                                style: mediumTextStyle(),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context)
                                      .pushNamed(SignInScreen.routName);
                                },
                                child: Text(
                                  'Sign in now',
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
