import 'package:flutter/material.dart';
import 'login.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      theme: ThemeData(
          primarySwatch: Colors.blue,
          primaryColor: const Color(0xFF303030),
          secondaryHeaderColor: const Color(0xFF212121),
          accentColor: const Color(0xFF64ffda),
          canvasColor: const Color(0xFF303030),
          brightness: Brightness.light),
      debugShowCheckedModeBanner: false,
      home: Login(),
    );
  }
}
