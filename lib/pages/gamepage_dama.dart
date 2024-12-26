import 'package:flutter/material.dart';
import 'dart:async';
import '../models/game_logic.dart';
import '../widgets/board_widget.dart';

class GamePageDama extends StatefulWidget {
  final int betAmount;

  const GamePageDama({Key? key, required this.betAmount}) : super(key: key);

  @override
  _GamePageDamaState createState() => _GamePageDamaState();
}

class _GamePageDamaState extends State<GamePageDama> {
  GameLogic gameLogic = GameLogic(
    board: [
      [0, 1, 0, 1, 0, 1, 0, 1],
      [1, 0, 1, 0, 1, 0, 1, 0],
      [0, 1, 0, 1, 0, 1, 0, 1],
      [0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0],
      [2, 0, 2, 0, 2, 0, 2, 0],
      [0, 2, 0, 2, 0, 2, 0, 2],
      [2, 0, 2, 0, 2, 0, 2, 0],
    ],
    playerTurn: true, // Inicialize com true ou false
  );
  Timer? _timer;
  int _seconds = 20; // Set the initial time to 20 seconds

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    _seconds = 20; // Reset the timer to 20 seconds
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_seconds > 0) {
          _seconds--;
        } else {
          _switchPlayer();
        }
      });
    });
  }

  void _switchPlayer() {
    setState(() {
      gameLogic.playerTurn = !gameLogic.playerTurn;
      _startTimer();
    });
  }

  void _handleMove() {
    _switchPlayer();
  }

  Color _getTimerColor() {
    if (_seconds <= 3) {
      return Colors.red; // Red color for 3 seconds or less
    } else if (_seconds <= 5) {
      return Colors.orange; // Orange color for 5 seconds or less
    } else {
      return Colors.green; // Green color for more than 5 seconds
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0XFF0472E8),
        title: const Text('Jogo de Dama'),
        centerTitle: true,
        leading: Image.asset('assets/icons/blaeyLogo.png'),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.settings)),
        ],
      ),
      body: Stack(
        children: [
          // Background color
          Container(
            color: Colors.grey[850],
          ),
          // Display the bet amount at the top left corner
          Positioned(
            top: 20,
            left: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Apostando:',
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    Text(
                      '\$${widget.betAmount * 2}', // Display the total bet (double the individual bet amount)
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 5),
                    Image.asset(
                      'assets/icons/moeda.png', // Path to the coin image
                      width: 20,
                      height: 20,
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Center the board and timers
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Opponent's timer bar
                Container(
                  width: 80,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Oponente',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      Stack(
                        children: [
                          Container(
                            height: 10,
                            color: gameLogic.playerTurn ? Colors.grey[850] : Colors.white, // Background color of the bar
                          ),
                          if (!gameLogic.playerTurn) // Show opponent's timer when it's their turn
                            AnimatedContainer(
                              duration: Duration(seconds: 1), // Smooth animation duration
                              width: (80 * _seconds) / 20, // Adjust width for 20 seconds
                              height: 10,
                              color: _getTimerColor(), // Change color based on time left
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Center the board
                BoardWidget(
                  gameLogic: gameLogic,
                  myTurn: gameLogic.playerTurn,
                  onMove: _handleMove,
                ),
                // User's timer bar
                Container(
                  width: 80,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Usuário',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      Stack(
                        children: [
                          Container(
                            height: 10,
                            color: gameLogic.playerTurn ? Colors.white : Colors.grey[850], // Background color of the bar
                          ),
                          if (gameLogic.playerTurn) // Show user's timer when it's their turn
                            AnimatedContainer(
                              duration: Duration(seconds: 1), // Smooth animation duration
                              width: (80 * _seconds) / 20, // Adjust width for 20 seconds
                              height: 10,
                              color: _getTimerColor(), // Change color based on time left
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Opponent's avatar and label
          Positioned(
            top: 60,
            right: 20,
            child: Column(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage('assets/images/opponent_photo.png'), // Foto do oponente
                ),
              ],
            ),
          ),
          // User's avatar and label
          Positioned(
            bottom: 60,
            left: 20,
            child: Column(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage('assets/images/user_photo.png'), // Foto do usuário
                ),
              ],
            ),
          ),
          // Exit button
          Positioned(
            bottom: 20,
            right: 20,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, // Background color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Sair',
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}