import 'dart:html';

import 'package:flutter_web/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
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
        title: Text('Kam2do'),
        actions: <Widget>[
          IconButton(
            onPressed: () => print,
            icon: Icon(Icons.search),
          ),
          IconButton(
            onPressed: () => print,
            icon: Icon(Icons.favorite),
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
              child: Center(
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
                  title: Text('About'),
                  leading: Icon(Icons.info),
                  onTap: () {
                    showAboutDialog(
                      context: context,
                      children: [
                        Text('Kam2do\n'),
                        Text('Made with \u2764 by Gaurav & Tirth'),
                      ],
                      applicationName: 'Kam2do',
                      applicationVersion: '0.0.1',
                      applicationIcon: Icon(
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
        margin: EdgeInsets.all(16),
        child: ListView(
          children: <Widget>[
            ..._toDoListTiles,
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showDialog(
              context: context,
              barrierDismissible: true,
              builder: (builder) {
                return AlertDialog(
                  title: Text('Create New Kam'),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('Save'),
                      onPressed: () {
                        Navigator.pop(context);
                        window.localStorage[DateTime.now().toString()] = [
                          titleController.text,
                          descriptionController.text
                        ].toString();
                        titleController.text = '';
                        descriptionController.text = '';
                        setState(() {
                          fetchToDos();
                        });
                        return showDialog(
                          context: context,
                          builder: (builder) => AlertDialog(
                            title: Center(
                              child: Text('New Kam Created'),
                            ),
                          ),
                        );
                      },
                    ),
                    FlatButton(
                      child: Text('Cancel'),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      TextField(
                        autofocus: true,
                        controller: titleController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          labelText: 'Title',
                          hintText: 'Title',
                        ),
                      ),
                      TextField(
                        autofocus: true,
                        keyboardType: TextInputType.text,
                        controller: descriptionController,
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
        label: Text('Create Kam'),
        icon: Icon(Icons.add),
      ),
    );
  }
}
