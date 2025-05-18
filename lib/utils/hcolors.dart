import 'dart:ui';

class HColors {
  static const Color prim = Color.fromARGB(255, 113, 73, 239);
  static const Color sec = Color.fromARGB(255, 158, 255, 39);
  static const Color third = Color.fromARGB(255, 103, 103, 103);
  static const Color four = Color.fromARGB(255, 255, 255, 255);
  static const Color five = Color.fromARGB(255, 255, 39, 44);
  static const Color six = Color.fromARGB(255, 176, 41, 44);
  
  static const Color seven = Color.fromARGB(255, 255, 150, 39);
  static const Color eight = Color.fromARGB(255, 39, 107, 255);
  static const Color nine = Color.fromARGB(255, 39, 255, 230);
  static const Color ten = Color.fromARGB(255, 164, 164, 164);
  static const Color eleven = Color.fromARGB(255, 241, 255, 39);
  static const Color twelve = Color.fromARGB(255, 255, 122, 39);

  static const Color desac = Color.fromARGB(80, 255, 255, 255);
  
  static const Color back = Color.fromARGB(255, 12, 12, 12);
  static const Color up = Color.fromARGB(255, 27, 27, 27);

  static Color getColorFromX(double value) {
    if (value >= 2) return HColors.five;
    if (value >= 1.5) return HColors.sec;
    if (value >= 1.3) return HColors.prim;

    return HColors.third; 
  }
}