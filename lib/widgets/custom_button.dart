import 'package:flutter/material.dart';

class MessagesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mensagens'),
      ),
      body: Center(
        child: Text('Aqui será exibido o chat!', style: TextStyle(fontSize: 18)),
      ),
    );
  }
}
