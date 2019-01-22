import 'package:flutter/material.dart';
import 'homepage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

class Login extends StatefulWidget {
  @override
  LoginState createState() => new LoginState();
}

class LoginState extends State<Login> {
  String username = " ";
  String password = " ";
  String userString = " ";
  String passString = " ";
  DocumentSnapshot usernamedocument;
  DocumentSnapshot passworddocument;

  void _navigateToPage(BuildContext context) {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
    Navigator.of(context)
        .push(MaterialPageRoute<Null>(builder: (BuildContext context) {
      return HomePage(
        doc: usernamedocument,
      );
    }));
  }

  void _checkUsername(BuildContext context, String username) {
    Stream<QuerySnapshot> snapshot =
        Firestore.instance.collection('Users').snapshots();
    snapshot.listen((datasnapshot) {
      for (var i = 0; i < datasnapshot.documents.length; i++) {
        if (username != datasnapshot.documents[i].data['username']) {
          setState(() {
            userString = "Incorrect";
          });
          continue;
        } else {
          setState(() {
            userString = " ";
          });
          setState(() {
            usernamedocument = datasnapshot.documents[i];
          });
          break;
        }
      }
    });
  }

  void _checkPassword(BuildContext context, String password) {
    Stream<QuerySnapshot> snapshot =
        Firestore.instance.collection('Users').snapshots();
    snapshot.listen((datasnapshot) {
      for (var i = 0; i < datasnapshot.documents.length; i++) {
        if (password != datasnapshot.documents[i].data['password']) {
          setState(() {
            passString = "Incorrect";
          });
          continue;
        } else {
          setState(() {
            passString = " ";
          });
          setState(() {
            passworddocument = datasnapshot.documents[i];
          });
          break;
        }
      }
    });
  }

  bool _check(BuildContext context, String username, String password) {
    if (usernamedocument.data['username'] ==
            passworddocument.data['username'] &&
        usernamedocument.data['password'] ==
            passworddocument.data['password']) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Container(
              margin: EdgeInsets.only(
                top: 42.0,
              ),
              child: Text(
                'Doxa',
                style: TextStyle(
                  fontSize: 33.0,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
                textScaleFactor: 0.6,
              )),
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(
                right: 20.0, left: 20.0, top: 49.0),
            child: Card(
              elevation: 30.0,
              child: Container(
                margin: EdgeInsets.only(
                    right: 10.0, left: 10.0, top: 30.0, bottom: 10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                        child: Column(
                          children: <Widget>[
                            Text('Username'),
                            TextField(
                                decoration:
                                    InputDecoration(hintText: "Username"),
                                onChanged: (String str) {
                                  setState(() {
                                    username = str;
                                  });
                                  _checkUsername(context, username);
                                }),
                            Text(userString),
                          ],
                        ),
                      ),
                      Container(
                        child: Column(
                          children: <Widget>[
                            Text('Password'),
                            TextField(
                                decoration:
                                    InputDecoration(hintText: "Password"),
                                onChanged: (String str) {
                                  setState(() {
                                    password = str;
                                  });
                                  _checkPassword(context, password);
                                }),
                            Text(passString),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          IconButton(
                              icon: Icon(Icons.check),
                              onPressed: () {
                                if (userString == " " &&
                                    passString == " " &&
                                    _check(context, username, password)) {
                                  _navigateToPage(context);
                                }
                              }),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
          ),
        ],
      ),
    );
  }
}
