import 'package:flutter/material.dart';

class DivesSiza {
  static double? sizew;
  static double? sizeh;
  static double? sized;
  static Orientation? sizeo;
  void init(BuildContext context) {
    sizew = MediaQuery.of(context).size.width;
    sizeh = MediaQuery.of(context).size.height;
    sizeo = MediaQuery.of(context).orientation;
    sized = sizeo == Orientation.landscape ? sizeh! * .024 : sizeh! * .024;
    print("Size Dives =>  $sized");
  }
}
