import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Chart extends StatefulWidget {
  final DocumentSnapshot document;
  Chart({Key key, this.document}) : super(key: key);
  @override
  ChartState createState() => new ChartState();
}

class ChartState extends State<Chart> with SingleTickerProviderStateMixin {
  GlobalKey _keyDot = GlobalKey();
  num good;
  num neutral;
  num bad;
  double number;
  CollectionReference collectionReference =
      Firestore.instance.collection('All');

  void _updateNumber(DocumentSnapshot doc, double number) {
  }

  @override
  Widget build(BuildContext context) {
    String buttonName = widget.document['name'];
    return StreamBuilder(
        stream: collectionReference.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.data == null) return CircularProgressIndicator();
          for (var i = 0; i < snapshot.data.documents.length; i++) {
            if (buttonName != snapshot.data.documents[i].data['name']) {
              continue;
            } else {
              good = snapshot.data.documents[i].data['good'];
              neutral = snapshot.data.documents[i].data['neutral'];
              bad = snapshot.data.documents[i].data['bad'];
              if (good > bad) {
                number = 88 + ((good - bad) / (good + neutral + bad)) * 100;
              } else if (bad > good) {
                number = 88 + ((bad - good) / (good + neutral + bad)) * -100;
              } else
                number = 88 + ((good - bad) / (good + neutral + bad)) * 100;
              _updateNumber(snapshot.data.documents[i], number);
            }
          }

          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text(
                ((number - 88)).toString(),
                textScaleFactor: 1,
              ),
              SizedBox(
                height: 202.0,
                width: 335.0,
                child: Container(
                    decoration: new ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(2),
                        side: BorderSide(),
                      ),
                    ),
                    child: Stack(
                      alignment: FractionalOffset.center,
                      overflow: Overflow.clip,
                      children: <Widget>[
                        Positioned(
                          key: _keyDot,
                          bottom: number,
                          left: 200.0,
                          child: Icon(Icons.fullscreen_exit),
                        ),
                      ],
                    )),
              ),
            ],
          );
        });
  }
}
