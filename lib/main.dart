import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:universal_html/prefer_universal/html.dart' as html;

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
    html.window.localStorage.containsKey('theme')
        ? _theme = html.window.localStorage['theme'] == 'Dark'
            ? Brightness.dark
            : Brightness.light
        : html.window.localStorage['theme'] = 'Light';

    html.window.localStorage.containsKey('primaryColor')
        ? _primaryColor =
            primaryColorFromString[html.window.localStorage['primaryColor']]
        : html.window.localStorage['primaryColor'] = 'Indigo';

    html.window.localStorage.containsKey('accentColor')
        ? _accentColor =
            accentColorFromString[html.window.localStorage['accentColor']]
        : html.window.localStorage['accentColor'] = 'Pink';
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
        '/': (context) => kIsWeb
            ? HomePage(themer)
            : Scaffold(
                appBar: AppBar(
                  title: Text('Android Coming Soon'),
                ),
                body: Center(
                  child: Text('Android Coming Soon'),
                ),
              ),
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
