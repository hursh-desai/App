import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

class Buttons extends StatefulWidget {
  Buttons({Key key, this.document}) : super(key: key);
  final DocumentSnapshot document;
  @override
  _ButtonsState createState() => new _ButtonsState();
}

class _ButtonsState extends State<Buttons> {
  num good;
  num neutral;
  num bad;
  bool active1 = true;
  bool active2 = true;
  bool active3 = true;
  String other;
  DocumentReference documentReference;
  StreamSubscription<DocumentSnapshot> subscription;

  @override
  void initState() {
    documentReference =
        Firestore.instance.document(widget.document.reference.path);
    super.initState();
    subscription = documentReference.snapshots().listen((datasnapshot) {
      setState(() {
        good = datasnapshot.data['good'];
        neutral = datasnapshot.data['neutral'];
        bad = datasnapshot.data['bad'];
        other = datasnapshot.data['other'];
        if (other == 'good') {
          active1 = false;
          active2 = true;
          active3 = true;
        } else if (other == 'neutral') {
          active1 = true;
          active2 = false;
          active3 = true;
        } else if (other == 'bad') {
          active1 = true;
          active2 = true;
          active3 = false;
        }
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    subscription?.cancel();
  }

  void _onPressed(String button) {
    String otherone;
    if (other == button)
      return;
    else
      otherone = other;
    // setState(() {
    //   active = false;
    // });

    String one;
    String two;
    String three;

    if (button == 'good') {
      one = 'good';
      two = 'bad';
      three = 'neutral';
    } else if (button == 'neutral') {
      one = 'neutral';
      two = 'good';
      three = 'bad';
    } else if (button == 'bad') {
      one = 'bad';
      two = 'good';
      three = 'neutral';
    }

    Firestore.instance.runTransaction((transaction) async {
      DocumentSnapshot freshSnap =
          await transaction.get(widget.document.reference);
      await transaction.update(freshSnap.reference, {
        one: freshSnap[one] + 1,
      });
      await transaction.update(freshSnap.reference, {
        two: 0 / freshSnap[two] + 1,
      });
      await transaction.update(freshSnap.reference, {
        three: 0 / freshSnap[three] + 1,
      });
      await transaction.update(freshSnap.reference, {
        'other': button,
      });
    }).whenComplete(() {
      Firestore.instance.runTransaction((transaction) async {
        DocumentSnapshot freshSnap =
            await transaction.get(widget.document.reference);
        setState(() {
          good = freshSnap.data['good'];
          neutral = freshSnap.data['neutral'];
          bad = freshSnap.data['bad'];
          other = freshSnap.data['other'];
        });
      }).whenComplete(() async {
        QuerySnapshot list =
            await Firestore.instance.collection('All').getDocuments();
        for (var i = 0; i < list.documents.length; i++) {
          if (widget.document['name'] != list.documents[i].data['name']) {
            continue;
          } else {
            // setState(() {
            //   // active = true;
            // });
            if (good > 1) {
              _send('good', list.documents[i], otherone);
            } else if (neutral > 1) {
              _send('neutral', list.documents[i], otherone);
            } else {
              _send('bad', list.documents[i], otherone);
            }
            break;
          }
        }
      });
    });
  }

  void _send(String button, DocumentSnapshot doc, String otherone) {
    Firestore.instance.runTransaction((transaction) async {
      DocumentSnapshot freshSnap = await transaction.get(doc.reference);
      await transaction
          .update(freshSnap.reference, {button: freshSnap[button] + 1});
      await transaction
          .update(freshSnap.reference, {otherone: freshSnap[otherone] - 1});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        SizedBox(
          height: 1 ,
          width: 1,
        ),
        Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              RaisedButton(
                  color: Colors.green[300],
                  elevation: 0.0,
                  child: Text('Good'),
                  onPressed: active1
                      ? () {
                          _onPressed('good');
                        }
                      : null),
              RaisedButton(
                  elevation: 0.0,
                  color: Colors.yellow[300],
                  child: Text('Neutral'),
                  onPressed: active2
                      ? () {
                          _onPressed('neutral');
                        }
                      : null),
              RaisedButton(
                  color: Colors.red[300],
                  elevation: 0.0,
                  child: Text('Bad'),
                  onPressed: active3
                      ? () {
                          _onPressed('bad');
                        }
                      : null),
            ],
          ),
        ),
      ],
    );
  }
}
