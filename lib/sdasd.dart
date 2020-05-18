import 'package:flutter/material.dart';




class S extends StatefulWidget {
  @override
  _SState createState() => _SState();
}

class _SState extends State<S> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      body: Center(child: Text('Welcome to new screen'),),
    );
  }
}