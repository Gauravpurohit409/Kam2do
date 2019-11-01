import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:hive/hive.dart';

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

  Future _openHiveThemeBox() async {
    return await Hive.openBox('themeBox');
  }

  @override
  void initState() {
    super.initState();
    _openHiveThemeBox().then((themeBox) {
      if (themeBox.length != 0) {
        setState(() {
          _theme = themesFromString[themeBox.get('theme')] ?? Brightness.light;
          _primaryColor =
              primaryColorFromString[themeBox.get('primaryColor')] ??
                  Colors.indigo;
          _accentColor = accentColorFromString[themeBox.get('accentColor')] ??
              Colors.pinkAccent;
        });
      } else {
        themeBox.put('theme', 'Light');
        themeBox.put('primaryColor', 'Indigo');
        themeBox.put('accentColor', 'Pink');
      }
    });
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
                  title: Text('Kam2do'),
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
