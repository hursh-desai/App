import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'buttons.dart';
import 'chart.dart';
import 'trade.dart';

// ---------------------------------------------------------------------------------------------------------------------------------------------------------
// https://youtu.be/mZYuuGAIwe4 youtube series for how to use firebase auth to create a login situation 
// ---------------------------------------------------------------------------------------------------------------------------------------------------------

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
                physics: BouncingScrollPhysics(),
                itemExtent: null,
                itemCount: snapshot.data.documents.length,
                itemBuilder: (BuildContext context, index) {
                  return Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Chart(
                              document: snapshot.data.documents[index],
                            ),
                            Buttons(
                              ment: snapshot.data.documents[index],
                            ),
                          ],
                        ),
                        ExpansionTile(
                          title: Text('Trading'),
                          children: <Widget>[
                            Trade(
                              document: snapshot.data.documents[index],
                            )
                          ],
                        ),
                      ],
                    ),
                  );
                });
          }),
    );
  }
}
