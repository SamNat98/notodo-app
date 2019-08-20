import 'package:flutter/material.dart';
import '../ui/second_homescreen.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("NoToDo"),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),

      body: new Second_Screen(),
    );
  }
}
