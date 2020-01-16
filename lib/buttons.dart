import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

class Buttons extends StatefulWidget {
  Buttons({Key key, this.ment}) : super(key: key);
  final DocumentSnapshot ment;
  @override
  _ButtonsState createState() => new _ButtonsState();
}

class _ButtonsState extends State<Buttons> {
  bool active1 = true;
  bool active2 = true;
  bool active3 = true;
  String other;
  DocumentReference documentReference;
  DocumentReference allReference;
  StreamSubscription<DocumentSnapshot> subscription;

  @override
  void initState() {
    documentReference =
        Firestore.instance.document(widget.ment.reference.path);
    super.initState();
    subscription = documentReference.snapshots().listen((datasnapshot) {
      setState(() {
        active1 = datasnapshot.data['good'];
        active2 = datasnapshot.data['neutral'];
        active3 = datasnapshot.data['bad'];
        other = datasnapshot.data['other'];
        allReference = datasnapshot.data['company'];
      });
    });
  }

  void _onPressed(String button) async {
    DocumentSnapshot doc = await allReference.get();

    widget.ment.reference.updateData({button: false});
    widget.ment.reference.updateData({other: true});
    widget.ment.reference.updateData({'other': button});

    allReference.updateData({button: doc.data[button] + 10});
    allReference.updateData({other: doc.data[other] - 10});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            RaisedButton(
                color: Colors.green[100],
                elevation: 0.0,
                child: Text('Good'),
                onPressed: active1
                    ? () {
                        _onPressed('good');
                      }
                    : null),
            RaisedButton(
                elevation: 0.0,
                color: Colors.indigo[100],
                child: Text('Neutral'),
                onPressed: active2
                    ? () {
                        _onPressed('neutral');
                      }
                    : null),
            RaisedButton(
                color: Colors.pink[100],
                elevation: 0.0,
                child: Text('Bad'),
                onPressed: active3
                    ? () {
                        _onPressed('bad');
                      }
                    : null),
          ],
        );
  }

  @override
  void dispose() {
    super.dispose();
    subscription?.cancel();
  }
}
