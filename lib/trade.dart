import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Trade extends StatelessWidget {
  Trade({Key key, this.document}) : super(key: key);
  final DocumentSnapshot document;

  _onPressed(BuildContext context, String button) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Container(
            child: Text(button),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            RaisedButton(
                color: Colors.teal[100],
                elevation: 0.0,
                child: Text('Up'),
                onPressed: _onPressed(context, 'up')),
            RaisedButton(
                elevation: 0.0,
                color: Colors.yellow[100],
                child: Text('Stay'),
                onPressed: _onPressed(context, 'stay')),
            RaisedButton(
                color: Colors.blueGrey[100],
                elevation: 0.0,
                child: Text('Down'),
                onPressed: _onPressed(context, 'down')),
          ],
        ),
      ]),
    );
  }
}

