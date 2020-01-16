import 'package:flutter/material.dart';
import 'login.dart';
import 'names1.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatelessWidget {
  final DocumentSnapshot doc;

  HomePage({Key key, this.doc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        elevation: 1000.0,
        child: ListView(
          children: <Widget>[
            new UserAccountsDrawerHeader(
              accountName: Text(doc.data['username']),
              accountEmail: null,   
              decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.fill,
                    image: NetworkImage("https://i.imgur.com/1RyLFUf.jpg")),
              ),
            ),
            ListTile(
              title: new Text('Logout'),
              onTap: () {
                _navigateBackToPage(context);
              },
            )
          ],
        ),
      ),
      appBar: new AppBar(
        elevation: 0.0,
        title: new Text('Doxa'),
        centerTitle: true,
      ),
      body: Theme(
        data: ThemeData(brightness: Brightness.light),
        child: Names(
          doc: doc,
        ),
      ),
    );
  }
}

void _navigateBackToPage(BuildContext context) {
  if (Navigator.of(context).canPop()) {
    Navigator.of(context).pop();
  }
  Navigator.of(context)
      .push(MaterialPageRoute<Null>(builder: (BuildContext context) {
    return Login();
  }));
}
