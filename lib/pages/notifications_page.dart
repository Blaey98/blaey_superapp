// lib/pages/notifications_page.dart
import 'package:flutter/cupertino.dart';

class NotificationsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Notificações'),
      ),
      child: Center(
        child: Text('Esta é a página de notificações'),
      ),
    );
  }
}