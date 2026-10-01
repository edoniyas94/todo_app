import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

import 'screens/todo_home_screen.dart';

class CoolTodoApp extends StatefulWidget {
  const CoolTodoApp({super.key});

  @override
  State<CoolTodoApp> createState() => _CoolTodoAppState();
}

class _CoolTodoAppState extends State<CoolTodoApp> {
  bool isDarkMode = false;

  void toggleTheme() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To Do',
      debugShowCheckedModeBanner: false,
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFFFFDE7),
        colorScheme: const ColorScheme.light(
          primary: Color(0xFFFFD600),
          secondary: Color(0xFF7C4DFF),
          surface: Colors.white,
        ),
        fontFamily: 'Roboto',
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF121212),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFFFD600),
          secondary: Color(0xFFB388FF),
          surface: Color.fromARGB(255, 110, 104, 104),
        ),
      ),
      home: TodoHomeScreen(
        onToggleTheme: toggleTheme,
        isDarkMode: isDarkMode,
      ),
    );
  }
}
