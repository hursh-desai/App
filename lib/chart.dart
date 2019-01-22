import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

class Chart extends StatefulWidget {
  final DocumentSnapshot document;
  Chart({Key key, this.document}) : super(key: key);
  @override
  ChartState createState() => new ChartState();
}

class ChartState extends State<Chart> with TickerProviderStateMixin {
  Animation animation;
  AnimationController animationController;
  num good;
  num neutral;
  num bad;
  num number;
  num oldnumber;
  CollectionReference collectionReference =
      Firestore.instance.collection('All');
  StreamSubscription<QuerySnapshot> subscription;

  @override
  void initState() {
    String buttonName = widget.document['name'];
    super.initState();
    subscription = collectionReference.snapshots().listen((datasnapshot) {
      for (var i = 0; i < datasnapshot.documents.length; i++) {
        if (buttonName != datasnapshot.documents[i].data['name']) {
          continue;
        } else {
          setState(() {
            print('1st number is:' + number.toString());
            print('1st number is:' + oldnumber.toString());
            oldnumber = number;
            good = datasnapshot.documents[i].data['good'];
            neutral = datasnapshot.documents[i].data['neutral'];
            bad = datasnapshot.documents[i].data['bad'];
            if (good > bad) {
              number = (good + (neutral / 2) - bad) / (good + neutral + bad);
            } else if (bad > good) {
              number = (good - (neutral / 2) - bad) / (good + neutral + bad);
            } else
              number = 0;
            print('1st number is:' + number.toString());
          });
          break;
        }
      }
      // animationController =
      //     AnimationController(duration: Duration(seconds: 1), vsync: this);
      // animation =
      //     Tween(begin: (75 + (oldnumber * 100)), end: (75 + (number * 100)))
      //         .animate(CurvedAnimation(
      //             curve: Curves.fastOutSlowIn, parent: animationController));
    });
  }

// top:175 ; bottom: -25
  Widget ting() {
    return new Positioned(
        child: new Opacity(
            opacity: 1.0,
            child: new Container(
              height: 50.0,
              width: 50.0,
              child: new Center(child: Icon(Icons.fullscreen_exit)),
            )),
        bottom: number);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Text(
          widget.document['name'],
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
                  ting(),
                ],
              )),
          // Text(
          //   good.toString() +
          //       ' + ' +
          //       neutral.toString() +
          //       ' + ' +
          //       bad.toString() +
          //       ' = ' +
          //       number.toString(),
          // ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
    subscription?.cancel();
  }
}
