import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/global/theme/theme_mode.dart';
import 'package:todo_app/module/widgets/todo_list_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeProvider(), // Creates an instance of ThemeProvider and provides it to the widget tree
      child: Consumer<ThemeProvider>(
        // Listens to changes in the provided ThemeProvider instance & rebuild the widget tree below it whenever the notified value changes
        builder: (context, themeProvider, _) {
          return MaterialApp(
            themeMode: themeProvider.themeMode, 
            theme: themeProvider.lightTheme, 
            darkTheme: themeProvider.darkTheme,
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            home: const TodoListPage(),
          );
        },
      ),
    );
  }
}