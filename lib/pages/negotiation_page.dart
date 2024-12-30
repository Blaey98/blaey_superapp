// lib/pages/negotiation_page.dart
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:blaey_app/pages/gamepage_dama.dart'; // Certifique-se de importar a classe GamePageDama corretamente
import 'gamepage_ludo.dart';
import 'gamepage_truco.dart';
import 'gamepage_jogo_da_velha.dart';
import 'gamepage_chess.dart';

class NegotiationPage extends StatefulWidget {
  final String gameTitle;

  NegotiationPage({required this.gameTitle});

  @override
  _NegotiationPageState createState() => _NegotiationPageState();
}

class _NegotiationPageState extends State<NegotiationPage> {
  int initialBet = 2; // Valor inicial da aposta ajustado para 2,00 (1,00 por jogador)
  int additionalBet = 0; // Valor adicional das apostas
  int timeLeft = 15; // Tempo para negociação
  int userBalance = 100; // Saldo atual do usuário
  int? selectedBet; // Valor da aposta selecionada
  String betStatus = "Aposta Inicial"; // Status da aposta
  bool showAcceptRejectButtons = false; // Controle para mostrar botões de aceitar/rejeitar
  Timer? _timer; // Timer para controle do piscar

  @override
  void initState() {
    super.initState();
    // Iniciar contagem regressiva
    startTimer();
  }

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (timeLeft > 0) {
        setState(() {
          timeLeft--;
        });
      } else {
        _timer?.cancel();
        _showReadyScreen();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
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

    // Aguardar 1 segundo e mostrar a tela de prontidão
    Future.delayed(Duration(seconds: 1), () {
      _showReadyScreen();
    });
  }

  void _rejectBet() {
    setState(() {
      selectedBet = null;
      showAcceptRejectButtons = false; // Esconder botões de aceitar/rejeitar
      betStatus = "Aposta Inicial"; // Restaurar status inicial
    });
  }

  void _showReadyScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ReadyScreen(gameTitle: widget.gameTitle, totalBetAmount: initialBet + additionalBet * 2)),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Calcula o valor total da aposta e o valor individual
    int totalBetAmount = initialBet + additionalBet * 2;
    int individualBetAmount = (initialBet / 2).toInt() + additionalBet;

    return Scaffold(
      body: Container(
        color: Color(0xFF16D735), // Fundo verde (#16D735)
        width: double.infinity, // Garantir que a largura ocupe toda a tela
        height: double.infinity, // Garantir que a altura ocupe toda a tela
        child: Stack(
          children: [
            // Relógio no topo esquerdo
            Positioned(
              top: 20,
              left: 20,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.white, // Fundo branco
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Icon(Icons.timer, color: Colors.grey[850], size: 20), // Ícone de relógio preto claro
                    SizedBox(width: 5),
                    Text(
                      '$timeLeft s',
                      style: TextStyle(
                        fontSize: 20,
                        color: timeLeft <= 3 ? Colors.red : Colors.black, // Texto preto, vermelho nos últimos 3 segundos
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Saldo atual no topo direito (sem o texto "Saldo")
            Positioned(
              top: 20,
              right: 20,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4), // Padding do saldo
                decoration: BoxDecoration(
                  color: Colors.white, // Fundo branco
                  border: Border.all(color: Colors.white), // Borda branca
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Text(
                      '$userBalance',
                      style: TextStyle(fontSize: 20, color: Colors.black), // Texto preto
                    ),
                    SizedBox(width: 5),
                    Image.asset('assets/icons/moeda.png', width: 24, height: 24),
                  ],
                ),
              ),
            ),
            // Aposta inicial e valor 2,00 no topo abaixo do temporizador e saldo
            Positioned(
              top: 120,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: Text(
                      betStatus,
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.white54,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            offset: Offset(1, 1),
                            color: Colors.greenAccent,
                            blurRadius: 0,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 5), // Diminuir a distância entre o texto "Aposta Inicial" e o valor "2,00"
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 1),
                    color: Colors.black.withOpacity(0.1), // Fundo 70% transparente
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '\$${totalBetAmount.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 36, // Diminuído o tamanho da fonte
                            color: Colors.black, // Texto preto
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 5),
                        Image.asset('assets/icons/moeda.png', width: 30, height: 30), // Aumentado o tamanho da imagem moeda.png
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Bloco de username e oponente no topo da tela
            Positioned(
              top: 267, // Ajustado para ficar abaixo do valor da aposta inicial
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: AssetImage('assets/icons/perfil.png'),
                      ),
                      SizedBox(height: 10), // Menor espaçamento entre a imagem de perfil e o nome
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 9, vertical: 9), // Padding do nome de usuário
                        color: Colors.black,
                        child: Text(
                          'Username',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                      // Exibir a aposta individual
                      Text(
                        '\$${individualBetAmount.toStringAsFixed(2)}',
                        style: TextStyle(fontSize: 26, color: Colors.black87),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Image.asset('assets/jogos/${widget.gameTitle.toLowerCase()}.png', width: 100, height: 100), // Imagem do jogo dinâmico
                    ],
                  ),
                  Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: AssetImage('assets/icons/oponente.png'),
                      ),
                      SizedBox(height: 10), // Menor espaçamento entre a imagem do oponente e o nome
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 9, vertical: 9), // Padding do nome do oponente
                        color: Colors.black,
                        child: Text(
                          'Oponente',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                      // Exibir a aposta individual
                      Text(
                        '\$${individualBetAmount.toStringAsFixed(2)}',
                        style: TextStyle(fontSize: 26, color: Colors.black87),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Bloco de apostas e ofertas no inferior da tela
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                color: Colors.grey[850], // Preto claro
                padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    Text(
                      'Faça sua oferta:',
                      style: TextStyle(fontSize: 14, color: Colors.white), // Texto centralizado pequeno sem negrito na cor branca
                      textAlign: TextAlign.center,
                    ),
                    if (!showAcceptRejectButtons && betStatus != "Aposta feita!") ...[
                      // Coluna com opções de aposta
                      Column(
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
                          Container(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: selectedBet != null ? _confirmBet : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black, // Fundo preto
                                padding: EdgeInsets.symmetric(vertical: 29), // Padding do botão de oferta
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Ofertar \$${selectedBet != null ? selectedBet!.toStringAsFixed(2) : ''}',
                                    style: TextStyle(color: Colors.white), // Texto branco
                                  ),
                                  SizedBox(width: 10),
                                  Image.asset('assets/icons/moeda.png', width: 34, height: 34),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                    if (showAcceptRejectButtons) ...[
                      ElevatedButton(
                        onPressed: _opponentAcceptBet,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: EdgeInsets.symmetric(horizontal: 50, vertical: 45), // Padding do botão de aceitar
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
                          padding: EdgeInsets.symmetric(horizontal: 50, vertical: 45), // Padding do botão de rejeitar
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBetOption(int amount) {
    return GestureDetector(
      onTap: () => _selectBet(amount),
      child: Container(
        width: 90,
        padding: EdgeInsets.all(8), // Padding das opções de aposta
        decoration: BoxDecoration(
          color: selectedBet == amount ? Colors.black : Colors.transparent, // Fundo preto se selecionado
          border: Border.all(
            color: selectedBet == amount ? Colors.black : Colors.black12, // Borda preta
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: FittedBox(
          child: Text(
            '+\$${amount.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 11,
              color: selectedBet == amount ? Colors.white : Colors.white, // Texto branco
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class ReadyScreen extends StatefulWidget {
  final String gameTitle;
  final int totalBetAmount;

  ReadyScreen({required this.gameTitle, required this.totalBetAmount});

  @override
  _ReadyScreenState createState() => _ReadyScreenState();
}

class _ReadyScreenState extends State<ReadyScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );

    _animation = Tween<Offset>(
      begin: Offset(0, -1), // Começa fora da tela na parte de cima
      end: Offset(0, 0), // Termina no centro da tela
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));

    _animationController.forward();

    // Navegar para a página do jogo após 2 segundos
    Future.delayed(Duration(seconds: 2), () {
      _startGame();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _startGame() {
    Widget gamePage;
    switch (widget.gameTitle.toLowerCase()) {
      case 'dama':
        gamePage = GamePageDama(betAmount: widget.totalBetAmount);
        break;
      case 'xadrez':
        gamePage = GamePageChess(betAmount: widget.totalBetAmount);
        break;
      case 'ludo':
        gamePage = GamePageLudo(betAmount: widget.totalBetAmount);
        break;
      case 'truco':
        gamePage = GamePageTruco(betAmount: widget.totalBetAmount);
        break;
      case 'jogo da velha':
        gamePage = GamePageJogoDaVelha(betAmount: widget.totalBetAmount);
        break;
      default:
        gamePage = GamePageDama(betAmount: widget.totalBetAmount);
        break;
    }
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => gamePage),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF16D735), // Fundo verde
      body: Center(
        child: SlideTransition(
          position: _animation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Ready',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                'Blaey!',
                style: TextStyle(
                  fontSize: 52,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}