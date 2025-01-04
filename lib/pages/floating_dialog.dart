import 'package:flutter/material.dart';
import 'waiting_for_player_page.dart';
import 'waiting_direto.dart';

class FloatingDialog extends StatelessWidget {
  final String gameTitle;

  FloatingDialog({required this.gameTitle});

  @override
  Widget build(BuildContext context) {
    // Determina o caminho da imagem baseado no título do jogo
    String gameImagePath;
    switch (gameTitle.toLowerCase()) {
      case 'dama':
        gameImagePath = 'assets/jogos/dama.png';
        break;
      case 'xadrez':
        gameImagePath = 'assets/jogos/xadrez.png';
        break;
      case 'ludo':
        gameImagePath = 'assets/jogos/ludo.png';
        break;
      case 'truco':
        gameImagePath = 'assets/jogos/truco.png';
        break;
      case 'jogo da velha':
        gameImagePath = 'assets/jogos/jogo_da_velha.png';
        break;
      default:
        gameImagePath = 'assets/jogos/default.png';
        break;
    }

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Modo de Jogo:',
              style: TextStyle(fontSize: 20, color: Colors.black),
            ),
            SizedBox(height: 20),
            Image.asset(gameImagePath, width: 160, height: 160), // Exibe a imagem do jogo correspondente
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => WaitingForPlayerPage(gameTitle: gameTitle)),
                );
              },
              icon: Icon(Icons.attach_money, color: Colors.white),
              label: Text(
                'Negociada',
                style: TextStyle(fontSize: 18, color: Colors.white), // Removeu o negrito
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF8B0000), // Vermelho puxado para vinho
                padding: EdgeInsets.symmetric(vertical: 20), // Aumenta o botão verticalmente
                minimumSize: Size(double.infinity, 60), // Aumenta o botão horizontalmente
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => WaitingDiretoPage(gameTitle: gameTitle)),
                );
              },
              icon: Icon(Icons.flash_on, color: Colors.white),
              label: Text(
                'Direto',
                style: TextStyle(fontSize: 18, color: Colors.white), // Removeu o negrito
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF003366), // Azul escuro bonito
                padding: EdgeInsets.symmetric(vertical: 20), // Aumenta o botão verticalmente
                minimumSize: Size(double.infinity, 60), // Aumenta o botão horizontalmente
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}