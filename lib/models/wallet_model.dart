import 'package:flutter/material.dart';

class WalletPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Carteira'),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // Ação a ser executada quando o botão for pressionado
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green, // Define a cor de fundo do botão
              ),
              child: Text('Meu Botão'),
            ),
          ],
        ),
      ),
    );
  }
}