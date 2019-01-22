 import 'package:flutter/material.dart';
import 'login.dart';
import 'names.dart';
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
              trailing: new Icon(Icons.subdirectory_arrow_left),
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
      body: Names(
        doc: doc,
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   type: BottomNavigationBarType.fixed,
      //   currentIndex: 1,
      //   items: [
      //     BottomNavigationBarItem(
      //         title: Text('Up'), icon: Icon(Icons.trending_up)),
      //     BottomNavigationBarItem(
      //         title: Text('Flat'), icon: Icon(Icons.trending_flat)),
      //     BottomNavigationBarItem(
      //         title: Text('Down'), icon: Icon(Icons.trending_down)),
      //   ],
      //   onTap: (index) {
      //     if (index == 0) {}
      //   },
      // ),
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
