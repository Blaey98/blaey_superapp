import 'package:flutter/material.dart';
import 'dart:async';
import 'gamepage_dama.dart';
import 'gamepage_xadrez.dart';
import 'gamepage_ludo.dart';
import 'gamepage_truco.dart';
import 'gamepage_jogo_da_velha.dart';

class NegotiationPage extends StatefulWidget {
  final String gameTitle;

  NegotiationPage({required this.gameTitle});

  @override
  _NegotiationPageState createState() => _NegotiationPageState();
}

class _NegotiationPageState extends State<NegotiationPage> {
  int initialBet = 2;  // Valor inicial da aposta ajustado para 2,00 (1,00 por jogador)
  int additionalBet = 0;  // Valor adicional das apostas
  int timeLeft = 15;  // Tempo para negociação
  int userBalance = 100; // Saldo atual do usuário
  int? selectedBet; // Valor da aposta selecionada
  String betStatus = "Aposta Inicial"; // Status da aposta
  bool showAcceptRejectButtons = false; // Controle para mostrar botões de aceitar/rejeitar

  @override
  void initState() {
    super.initState();
    // Iniciar contagem regressiva
    startTimer();
  }

  void startTimer() {
    Future.delayed(Duration(seconds: 1), () {
      if (mounted && timeLeft > 0) {
        setState(() {
          timeLeft--;
        });
        startTimer();
      } else if (timeLeft == 0) {
        _startGame();
      }
    });
  }

  void _selectBet(int amount) {
    setState(() {
      selectedBet = amount;
    });
  }

  void _confirmBet() {
    setState(() {
      additionalBet += selectedBet!;
      betStatus = "Apostar?"; // Mudar status quando a oferta é feita
      showAcceptRejectButtons = true; // Mostrar botões de aceitar/rejeitar
      selectedBet = null;
    });
  }

  void _opponentAcceptBet() {
    setState(() {
      betStatus = "Aposta feita!"; // Mudar status quando o oponente aceita
      showAcceptRejectButtons = false; // Esconder botões de aceitar/rejeitar
    });

    // Aguardar 1 segundo e ir para a tela do jogo
    Future.delayed(Duration(seconds: 1), () {
      _startGame();
    });
  }

  void _rejectBet() {
    setState(() {
      selectedBet = null;
      showAcceptRejectButtons = false; // Esconder botões de aceitar/rejeitar
      betStatus = "Aposta Inicial"; // Restaurar status inicial
    });
  }

  void _startGame() {
    Widget gamePage;
    int totalBetAmount = initialBet + additionalBet * 2;
    switch (widget.gameTitle.toLowerCase()) {
      case 'dama':
        gamePage = GamePageDama(betAmount: totalBetAmount);
        break;
      case 'xadrez':
        gamePage = GamePageXadrez(betAmount: totalBetAmount);
        break;
      case 'ludo':
        gamePage = GamePageLudo(betAmount: totalBetAmount);
        break;
      case 'truco':
        gamePage = GamePageTruco(betAmount: totalBetAmount);
        break;
      case 'jogo da velha':
        gamePage = GamePageJogoDaVelha(betAmount: totalBetAmount);
        break;
      default:
        gamePage = GamePageDama(betAmount: totalBetAmount);
        break;
    }
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => gamePage),
    );
  }

  @override
  Widget build(BuildContext context) {
    int totalBetAmount = initialBet + additionalBet * 2;
    int individualBetAmount = (initialBet / 2).toInt() + additionalBet;

    return Scaffold(
      appBar: AppBar(
        title: Opacity(
          opacity: 0.7,
          child: Text('Negocie sua aposta', style: TextStyle(color: Colors.white)),
        ),
        backgroundColor: Colors.black,
      ),
      body: Stack(
        children: [
          // Temporizador no canto superior esquerdo
          Positioned(
            top: 20,
            left: 20,
            child: Row(
              children: [
                Icon(Icons.timer, color: Colors.white, size: 20),
                SizedBox(width: 5),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: timeLeft <= 5 ? Colors.red : Colors.grey[800],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '$timeLeft s',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          // Saldo atual no canto superior direito
          Positioned(
            top: 20,
            right: 20,
            child: Column(
              children: [
                Text(
                  'Saldo',
                  style: TextStyle(fontSize: 12, color: Colors.white),
                ),
                SizedBox(height: 2),
                Row(
                  children: [
                    Text(
                      '$userBalance',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                    SizedBox(width: 5),
                    Image.asset('assets/icons/moeda.png', width: 24, height: 24),
                  ],
                ),
              ],
            ),
          ),
          // Layout centralizado
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  betStatus,
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Text(
                            '\$${totalBetAmount.toStringAsFixed(2)}',
                            style: TextStyle(fontSize: 36, color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(width: 5),
                          Image.asset('assets/icons/moeda.png', width: 24, height: 24),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.green,
                          child: Icon(Icons.person, color: Colors.white, size: 40),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Usuário',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                        // Exibir a aposta individual
                        Text(
                          '\$${individualBetAmount.toStringAsFixed(2)}',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          'VS',
                          style: TextStyle(fontSize: 24, color: Colors.white),
                        ),
                        SizedBox(height: 10),
                        Image.asset('assets/jogos/${widget.gameTitle.toLowerCase()}.png', width: 50, height: 50), // Imagem do jogo dinâmico
                      ],
                    ),
                    Column(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.red,
                          child: Icon(Icons.person, color: Colors.white, size: 40),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Oponente',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                        // Exibir a aposta individual
                        Text(
                          '\$${individualBetAmount.toStringAsFixed(2)}',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ],
                    ),
                  ],
                ),
                if (!showAcceptRejectButtons && betStatus != "Aposta feita!") ...[
                  SizedBox(height: 20),
                  // Coluna com opções de aposta
                  Container(
                    width: double.infinity,
                    color: Colors.grey[850], // Preto claro
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.only(bottom: 20), // Espaço extra na parte inferior
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildBetOption(2),
                            _buildBetOption(5),
                            _buildBetOption(10),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildBetOption(20),
                            _buildBetOption(50),
                            _buildBetOption(100),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildBetOption(500),
                            _buildBetOption(1000),
                            _buildBetOption(2000),
                          ],
                        ),
                        SizedBox(height: 10),
                        Container(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: selectedBet != null ? _confirmBet : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: selectedBet != null ? Colors.green : Colors.grey[700],
                              padding: EdgeInsets.symmetric(vertical: 18),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Ofertar \$${selectedBet != null ? selectedBet!.toStringAsFixed(2) : ''}',
                                  style: TextStyle(color: Colors.white),
                                ),
                                SizedBox(width: 10),
                                Image.asset('assets/icons/moeda.png', width: 24, height: 24),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                if (showAcceptRejectButtons) ...[
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _opponentAcceptBet,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text('Aceitar', style: TextStyle(color: Colors.white)),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _rejectBet,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text('Rejeitar', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
      backgroundColor: Colors.black,
    );
  }

  Widget _buildBetOption(int amount) {
    return GestureDetector(
      onTap: () => _selectBet(amount),
      child: Container(
        width: 100,
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: selectedBet == amount ? Colors.green : Colors.transparent,
          border: Border.all(
            color: selectedBet == amount ? Colors.green : Colors.grey,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: FittedBox(
          child: Text(
            '+\$${amount.toStringAsFixed(2)}',
            style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}