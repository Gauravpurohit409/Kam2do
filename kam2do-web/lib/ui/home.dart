import 'dart:html';

import 'package:flutter_web/material.dart';

import '../utils/themes.dart';

class HomePage extends StatefulWidget {
  final Function _themer;

  HomePage(this._themer);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  List<ListTile> _toDoListTiles = [];

  @override
  void initState() {
    super.initState();
    fetchToDos();
  }

  void fetchToDos() {
    _toDoListTiles = [];
    List<String> localStorageToDoKeys = window.localStorage.keys.toList();
    localStorageToDoKeys.sort();
    localStorageToDoKeys.remove('theme');
    localStorageToDoKeys.remove('primaryColor');
    localStorageToDoKeys.remove('accentColor');
    _toDoListTiles = localStorageToDoKeys
        .map(
          (e) => ListTile(
            title: Text(window.localStorage[e]),
            subtitle: Text(e),
          ),
        )
        .toList()
        .reversed
        .toList();
  }

  @override
  Widget build(BuildContext context) {
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
        child: ListView(
          children: <Widget>[
            ..._toDoListTiles,
          ],
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
                        window.localStorage[DateTime.now().toString()] = [
                          _titleController.text,
                          _descriptionController.text
                        ].toString();
                        _titleController.text = '';
                        _descriptionController.text = '';
                        setState(() {
                          fetchToDos();
                        });
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
}

class AlertDialogThemer extends StatefulWidget {
  final Function _themer;

  AlertDialogThemer(this._themer);

  @override
  _AlertDialogThemerState createState() => _AlertDialogThemerState();
}

class _AlertDialogThemerState extends State<AlertDialogThemer> {
  String _primaryColor = window.localStorage['primaryColor'];
  String _accentColor = window.localStorage['accentColor'];
  String _theme = window.localStorage['theme'];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            if (_primaryColor != null && _theme != null) {
              window.localStorage['theme'] = _theme;
              window.localStorage['primaryColor'] = _primaryColor;
              window.localStorage['accentColor'] = _accentColor;
              widget._themer(
                  _theme == 'Dark' ? Brightness.dark : Brightness.light,
                  primaryColorFromString[_primaryColor],
                  accentColorFromString[_accentColor]);
            }
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
              _theme = v;
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
