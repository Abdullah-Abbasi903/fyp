import 'package:flutter/material.dart';

class AppColors {
  Color primaryColor = const Color(0xff53C5DE);
  Color secondaryColor = const Color(0xff98DCEB);
  Color noteColor = const Color(0xff50B9DA);
  Color white = Colors.white;
  Color black = Colors.black;
  Color grey =  const Color(0xffE6E6E6);
  Color darkGrey =  const Color(0xff4D4D4D);
   
 Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Colors.blue;
      }
      return Colors.red;
   }
  
}
