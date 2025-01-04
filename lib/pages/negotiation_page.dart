import 'dart:async';

import 'package:flutter/material.dart';
import 'package:blaey_app/pages/gamepage_dama.dart';
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
  int initialBet = 2;
  int additionalBet = 0;
  int timeLeft = 15;
  int userBalance = 100;
  int? selectedBet;
  String betStatus = "Aposta Inicial";
  bool showAcceptRejectButtons = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
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
      betStatus = "Apostar?";
      showAcceptRejectButtons = true;
      selectedBet = null;
    });
  }

  void _opponentAcceptBet() {
    setState(() {
      betStatus = "Aposta feita!";
      showAcceptRejectButtons = false;
    });

    Future.delayed(Duration(seconds: 1), () {
      _showReadyScreen();
    });
  }

  void _rejectBet() {
    setState(() {
      selectedBet = null;
      showAcceptRejectButtons = false;
      betStatus = "Aposta Inicial";
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
    int totalBetAmount = initialBet + additionalBet * 2;
    int individualBetAmount = (initialBet / 2).toInt() + additionalBet;

    return Scaffold(
      body: Container(
        color: Color(0xFF16D735),
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            Positioned(
              top: 20,
              left: 20,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Icon(Icons.timer, color: Colors.grey[850], size: 20),
                    SizedBox(width: 5),
                    Text(
                      '$timeLeft s',
                      style: TextStyle(
                        fontSize: 20,
                        color: timeLeft <= 3 ? Colors.red : Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 20,
              right: 20,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Text(
                      '$userBalance',
                      style: TextStyle(fontSize: 20, color: Colors.black),
                    ),
                    SizedBox(width: 5),
                    Image.asset('assets/icons/moeda.png', width: 24, height: 24),
                  ],
                ),
              ),
            ),
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
                  SizedBox(height: 5),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 1),
                    color: Colors.black.withOpacity(0.1),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '\$${totalBetAmount.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 36,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 5),
                        Image.asset('assets/icons/moeda.png', width: 30, height: 30),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 267,
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
                      SizedBox(height: 10),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 9, vertical: 9),
                        color: Colors.black,
                        child: Text(
                          'Username',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                      Text(
                        '\$${individualBetAmount.toStringAsFixed(2)}',
                        style: TextStyle(fontSize: 26, color: Colors.black87),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Image.asset('assets/jogos/${widget.gameTitle.toLowerCase()}.png', width: 100, height: 100),
                    ],
                  ),
                  Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: AssetImage('assets/icons/oponente.png'),
                      ),
                      SizedBox(height: 10),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 9, vertical: 9),
                        color: Colors.black,
                        child: Text(
                          'Oponente',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                      Text(
                        '\$${individualBetAmount.toStringAsFixed(2)}',
                        style: TextStyle(fontSize: 26, color: Colors.black87),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                color: Colors.grey[850],
                padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    Text(
                      'Faça sua oferta:',
                      style: TextStyle(fontSize: 14, color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                    if (!showAcceptRejectButtons && betStatus != "Aposta feita!") ...[
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
                                backgroundColor: Colors.black,
                                padding: EdgeInsets.symmetric(vertical: 29),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
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
                          padding: EdgeInsets.symmetric(horizontal: 50, vertical: 45),
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
                          padding: EdgeInsets.symmetric(horizontal: 50, vertical: 45),
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
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: selectedBet == amount ? Colors.black : Colors.transparent,
          border: Border.all(
            color: selectedBet == amount ? Colors.black : Colors.black12,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: FittedBox(
          child: Text(
            '+\$${amount.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 11,
              color: selectedBet == amount ? Colors.white : Colors.white,
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
      begin: Offset(0, -1),
      end: Offset(0, 0),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));

    _animationController.forward();

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
        gamePage = GamePageDama(betAmount: widget.totalBetAmount.toDouble());
        break;
      case 'xadrez':
        gamePage = GamePageChess(betAmount: widget.totalBetAmount.toInt());
        break;
      case 'ludo':
        gamePage = GamePageLudo(betAmount: widget.totalBetAmount.toInt());
        break;
      case 'truco':
        gamePage = GamePageTruco(betAmount: widget.totalBetAmount.toInt());
        break;
      case 'jogo da velha':
        gamePage = GamePageJogoDaVelha(betAmount: widget.totalBetAmount.toInt());
        break;
      default:
        gamePage = GamePageDama(betAmount: widget.totalBetAmount.toDouble());
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
      backgroundColor: Color(0xFF16D735),
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