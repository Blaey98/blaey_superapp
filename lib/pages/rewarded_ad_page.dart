import 'package:flutter/material.dart';

class RewardedAdPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Assista ao Anúncio'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Assista ao anúncio para ganhar 1 moeda',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Simula o usuário assistindo ao anúncio e ganhando a recompensa
                Navigator.pop(context, 1.0); // Retorna 1 moeda como recompensa
              },
              child: Text('Assistir Anúncio'),
            ),
          ],
        ),
      ),
    );
  }
}