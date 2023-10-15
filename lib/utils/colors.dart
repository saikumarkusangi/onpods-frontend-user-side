import 'package:flutter/material.dart';


// Dark Theme Colors
const Color darkscaffoldBackgroundColor = Colors.black;
const Color darktextFieldColor = Color.fromARGB(255, 44, 44, 44);
const Color bottomSheetColor = Color.fromARGB(255, 39, 46, 60);
const Color darkchatCard = Color.fromARGB(173, 49, 62, 85);
const Color darkbottomNavColor = Color(0xFF070D15);
const Color primaryColor = Colors.grey;

ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  scaffoldBackgroundColor: Colors.black,
  bottomSheetTheme: const BottomSheetThemeData(
    backgroundColor: Color.fromARGB(255, 39, 46, 60)
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Color(0xFF070D15)
  )
);

// Light Theme Colors
const Color lightscaffoldBackgroundColor = Colors.white;
const Color blueColor = Color(0xFF3369FF);

ThemeData lightTheme = ThemeData(
  scaffoldBackgroundColor: Colors.white,
  bottomSheetTheme: const BottomSheetThemeData(
    backgroundColor: Color.fromARGB(255, 39, 46, 60)
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Colors.white
  )
);


// Image PlaceHolder Colors
final List<Color> placeholderColors = [
  Colors.red.shade200,
  Colors.blue.shade200,
  Colors.green.shade200,
  Colors.yellow.shade200,
  Colors.orange.shade200,
  Colors.purple.shade200,
  Colors.pink.shade200,
];

// ListTile Colors
final List<Color> randomColors = [
  Colors.redAccent,
  Colors.blueAccent,
  Colors.greenAccent,
  Colors.yellowAccent,
  Colors.orangeAccent,
  Colors.pinkAccent,
  Colors.purpleAccent,
  Colors.indigoAccent,
  Colors.deepOrangeAccent
];
