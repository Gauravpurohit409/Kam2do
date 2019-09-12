import 'dart:html';

import 'package:flutter_web/material.dart';

import 'ui/home.dart';
import 'utils/themes.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Brightness _theme = Brightness.light;
  MaterialColor _primaryColor = Colors.indigo;
  MaterialAccentColor _accentColor = Colors.pinkAccent;

  @override
  void initState() {
    super.initState();
    window.localStorage.containsKey('theme')
        ? _theme = window.localStorage['theme'] == 'Dark'
            ? Brightness.dark
            : Brightness.light
        : window.localStorage['theme'] = 'Light';

    window.localStorage.containsKey('primaryColor')
        ? _primaryColor =
            primaryColorFromString[window.localStorage['primaryColor']]
        : window.localStorage['primaryColor'] = 'Indigo';

    window.localStorage.containsKey('accentColor')
        ? _accentColor =
            accentColorFromString[window.localStorage['accentColor']]
        : window.localStorage['accentColor'] = 'Pink';
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kam2do',
      theme: ThemeData(
        brightness: _theme,
        primaryColor: _primaryColor,
        accentColor: _accentColor,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(themer),
      },
    );
  }

  void themer(Brightness theme, MaterialColor primaryColor,
      MaterialAccentColor accentColor) {
    setState(() {
      _theme = theme;
      _primaryColor = primaryColor;
      _accentColor = accentColor;
    });
  }
}
