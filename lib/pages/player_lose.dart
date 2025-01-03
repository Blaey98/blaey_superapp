import 'package:flutter/material.dart';

class PlayerLosePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Derrota'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Você perdeu!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate back to home or restart game
                Navigator.pop(context);
              },
              child: Text('Voltar ao início'),
            ),
          ],
        ),
      ),
    );
  }
}