import 'package:flutter/material.dart';

class BlaeyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text('Please come and Enjoy'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Container(
        color: Colors.green,
        child: Center(
          child: Image.asset('assets/icons/icon_transparente.png'),
        ),
      ),
    );
  }
}