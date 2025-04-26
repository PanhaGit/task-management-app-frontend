import 'package:flutter/material.dart';
class AppStyle {
  static double  deviceHeight (BuildContext context){
    return MediaQuery.of(context).size.height;
  }
  static double  deviceWidth (BuildContext context) {
    return MediaQuery.of(context).size.width;
  }
}