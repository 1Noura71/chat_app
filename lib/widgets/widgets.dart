import 'package:flutter/material.dart';

import '../constatnts_colors.dart';

AppBar appBarMain(BuildContext context) {
  return AppBar(
    title: Text('Chats'),
    elevation: 0.0,
    centerTitle: true,
  );
}

InputDecoration textFiledInputDocration(String hintText) {
  return InputDecoration(
    hintText: hintText,
    hintStyle: TextStyle(
      decorationColor: kPrimaryColor,
      color: kPrimaryColor,
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color:kPrimaryColor),
    ),
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: kPrimaryLightColor),
    ),
  );
}

TextStyle simpleTextStyle() {
  return TextStyle(color: Colors.black87, fontSize: 16);

}

TextStyle mediumTextStyle({
    Color color = Colors.black87,
    TextDecoration textDco = TextDecoration.none}) {
  return TextStyle(
    color: color,
    fontSize: 17,
    decoration: textDco,
  );
}
