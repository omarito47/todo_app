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

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            themeMode: themeProvider.themeMode,
            theme: ThemeProvider().lightTheme,
            darkTheme: ThemeProvider().darkTheme,
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            home: const TodoListPage(),
          );
        },
      ),
    );
  }
}
