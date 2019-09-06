import 'dart:html';

import 'package:flutter_web/material.dart';

import 'ui/home.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Brightness _theme = Brightness.light;

  @override
  void initState() {
    super.initState();
    if (window.localStorage.containsKey('theme')) {
      _theme = window.localStorage['theme'] == 'Dark'
          ? Brightness.dark
          : Brightness.light;
    } else {
      window.localStorage['theme'] = 'Light';
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kam2do',
      theme: ThemeData(
        brightness: _theme,
        primarySwatch: Colors.indigo,
        accentColor: Colors.pinkAccent,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(themer),
      },
    );
  }

  void themer(Brightness theme) {
    setState(() {
      _theme = theme;
    });
  }
}
