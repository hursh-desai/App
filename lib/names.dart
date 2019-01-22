import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'chart.dart';
import 'buttons.dart';

class Names extends StatelessWidget {
  Names({Key key, this.doc}) : super(key: key);
  final DocumentSnapshot doc;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder(
          stream: doc.reference.collection('Names').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const Text('Loading');
            return new ListView.builder(
                physics: ClampingScrollPhysics(),
                itemExtent: 270.0,
                itemCount: snapshot.data.documents.length,
                itemBuilder: (BuildContext context, index) {
                  return Container(
                    child: Card(    
                      elevation: 0.0,
                      margin: EdgeInsets.only(
                          bottom: 8.0, left: 10.0, right: 10.0, top: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Container(
                            child: Chart(
                              document: snapshot.data.documents[index],
                            ),
                          ),
                          Container(
                            child: Buttons(
                              document: snapshot.data.documents[index],
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                });
          }),
    );
  }
}
