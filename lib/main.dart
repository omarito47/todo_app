import 'package:todo_app/global/global.dart';
import 'package:flutter/material.dart';
void main() {//point de départ 
  runApp(const MyApp());//action pour lancer l'app
}
//root widget
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(//2 notifier l'app si il y'a de changement 
      //instance pour observer le changement dans ThemeProvider
      create: (_) => ThemeProvider(), //1 Creates an instance of ThemeProvider and provides it to the widget tree
      child: Consumer<ThemeProvider>(
        // Listens to changes in the provided ThemeProvider instance from changeNotifierProvider
        // & rebuild the widget tree below it whenever the notified value changes
        builder: (context, themeProvider, _) {
          return MaterialApp(//
            themeMode: themeProvider.themeMode, 
            theme: themeProvider.lightTheme, 
            darkTheme: themeProvider.darkTheme,
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',//title of the app when the app on background 
            home: const TodoListPage(),
          );
        },
      ),
    );
  }
}