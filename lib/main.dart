import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/global/theme/theme_mode.dart';
import 'package:todo_app/module/widgets/todo_list_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  //dark theme mode
  final darkTheme = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: Colors.black,
    appBarTheme: AppBarTheme(
      color: Colors.grey[900],
      iconTheme: IconThemeData(color: Colors.white),
      
    ),
    textTheme: TextTheme(
      bodyText2: TextStyle(color: Colors.white),
      subtitle1: TextStyle(color: Colors.white),
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: MaterialStateColor.resolveWith((states) => Colors.white),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Colors.blueGrey,
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: Colors.grey[800],
      contentTextStyle: TextStyle(color: Colors.white),
    ),
    dialogTheme: DialogTheme(
      backgroundColor: Colors.blueGrey,
    ),
    cardTheme: CardTheme(
      color: Colors.grey[800],
    ),
  );
  //light theme mode
  final lightTheme = ThemeData(
    primaryColor: Colors.grey,
    hintColor: Colors.blue,
    buttonTheme: const ButtonThemeData(buttonColor: Colors.blueGrey),
    textTheme: const TextTheme(
      bodyText2: TextStyle(color: Colors.black),
      // Add more text styles as needed
    ),
    appBarTheme: const AppBarTheme(
      color: Colors.blueGrey,
      // Customize app bar attributes if needed
    ),
    scaffoldBackgroundColor: Colors.white,
  );
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            themeMode: themeProvider.themeMode,
            theme: lightTheme,
            darkTheme: darkTheme,
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            home: const TodoListPage(),
          );
        },
      ),
    );
  }
}
