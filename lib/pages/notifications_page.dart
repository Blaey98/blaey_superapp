import 'package:flutter/material.dart';

class NotificationsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notificações'),
      ),
      body: Center(
        child: Text(
          'Página de Notificações',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}