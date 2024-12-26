import 'package:flutter/material.dart';

class FriendProfilePage extends StatelessWidget {
  final String friendName;

  FriendProfilePage(this.friendName);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(friendName),
      ),
      body: Center(
        child: Text('Perfil de $friendName'),
      ),
    );
  }
}