import 'package:flutter/material.dart';

import 'package:hive/hive.dart';

import '../utils/themes.dart';

class HomePage extends StatefulWidget {
  final Function _themer;

  const HomePage(this._themer);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Hive.openBox('kaamBox'),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Kam2do'),
              actions: <Widget>[
                IconButton(
                  onPressed: () async {
                    await showDialog(
                      context: context,
                      builder: (builder) => AlertDialogThemer(widget._themer),
                    );
                  },
                  icon: const Icon(Icons.palette),
                ),
              ],
            ),
            drawer: Drawer(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  DrawerHeader(
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      shape: BoxShape.rectangle,
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.work,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                  ),
                  Column(
                    children: <Widget>[
                      ListTile(
                        title: const Text('About'),
                        leading: const Icon(Icons.info),
                        onTap: () {
                          Navigator.pop(context);
                          showAboutDialog(
                            context: context,
                            children: [
                              const Text('Kam2do\n'),
                              const Text('Made with \u2764 by Gaurav & Tirth'),
                            ],
                            applicationName: 'Kam2do',
                            applicationVersion: '0.0.1',
                            applicationIcon: const Icon(
                              Icons.work,
                              size: 50,
                            ),
                          );
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),
            body: Container(
              margin: const EdgeInsets.all(16),
              child: Hive.box('kaamBox').length == 0
                  ? Center(
                      child: Text('No Kaams'),
                    )
                  : ListView.builder(
                      itemBuilder: (context, index) {
                        dynamic kaamBox = Hive.box('kaamBox');
                        kaamBox = kaamBox.getAt(index);
                        return ListTile(
                          title: Text(kaamBox['title'].toString()),
                          subtitle: Text(kaamBox['description'].toString()),
                        );
                      },
                      itemCount: Hive.box('kaamBox').length,
                    ),
            ),
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () async {
                await showDialog(
                    context: context,
                    barrierDismissible: true,
                    builder: (builder) {
                      return AlertDialog(
                        title: const Text('Create New Kam'),
                        actions: <Widget>[
                          FlatButton(
                            child: const Text('Save'),
                            onPressed: () {
                              Navigator.pop(context);
                              Hive.box('kaamBox').put(
                                  DateTime.now().toString(), {
                                'title': _titleController.text,
                                'description': _descriptionController.text
                              });
                              _titleController.text = '';
                              _descriptionController.text = '';
                              setState(() {});
                              return showDialog(
                                context: context,
                                builder: (builder) => const AlertDialog(
                                  title: Center(
                                    child: Text('New Kam Created'),
                                  ),
                                ),
                              );
                            },
                          ),
                          FlatButton(
                            child: const Text('Cancel'),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            TextField(
                              autofocus: true,
                              controller: _titleController,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                labelText: 'Title',
                                hintText: 'Title',
                              ),
                            ),
                            TextField(
                              autofocus: true,
                              keyboardType: TextInputType.text,
                              controller: _descriptionController,
                              decoration: InputDecoration(
                                labelText: 'Description',
                                hintText: 'Description',
                              ),
                            ),
                          ],
                        ),
                      );
                    });
              },
              label: const Text('Create Kam'),
              icon: const Icon(Icons.add),
            ),
          );
        }
        return Scaffold();
      },
    );
  }
}

class AlertDialogThemer extends StatefulWidget {
  final Function _themer;

  const AlertDialogThemer(this._themer);

  @override
  _AlertDialogThemerState createState() => _AlertDialogThemerState();
}

class _AlertDialogThemerState extends State<AlertDialogThemer> {
  var _themeBox = Hive.box('themeBox');
  String _primaryColor;
  String _accentColor;
  String _theme;

  @override
  Widget build(BuildContext context) {
    if (_primaryColor == null && _accentColor == null && _theme == null) {
      _primaryColor = _themeBox.get('primaryColor');
      _accentColor = _themeBox.get('accentColor');
      _theme = _themeBox.get('theme');
    }
    return AlertDialog(
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            _themeBox.put('theme', _theme);
            _themeBox.put('primaryColor', _primaryColor);
            _themeBox.put('accentColor', _accentColor);
            widget._themer(
                themesFromString[_theme],
                primaryColorFromString[_primaryColor],
                accentColorFromString[_accentColor]);
            Navigator.pop(context);
          },
          child: Text('Save'),
        ),
      ],
      title: Text('Look & Feel'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          DropdownButtonFormField(
            onChanged: (v) {
              setState(() {
                _theme = v;
              });
            },
            decoration: InputDecoration(
              helperText: 'Theme',
            ),
            value: _theme,
            items: [
              DropdownMenuItem(
                child: Text('Dark'),
                value: 'Dark',
              ),
              DropdownMenuItem(
                child: Text('Light'),
                value: 'Light',
              ),
            ],
          ),
          DropdownButtonFormField(
            onChanged: (v) {
              setState(() {
                _primaryColor = v;
              });
            },
            value: _primaryColor,
            decoration: InputDecoration(
              helperText: 'Primary Color',
            ),
            items: [
              ...primaryColorFromString.keys.map(
                (p) => DropdownMenuItem(
                  child: Text(p),
                  value: p,
                ),
              ),
            ],
          ),
          DropdownButtonFormField(
            onChanged: (v) {
              setState(() {
                _accentColor = v;
              });
            },
            value: _accentColor,
            decoration: InputDecoration(
              helperText: 'Accent Color',
            ),
            items: [
              ...accentColorFromString.keys.map(
                (p) => DropdownMenuItem(
                  child: Text(p),
                  value: p,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
