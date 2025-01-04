import 'package:flutter/material.dart';
import '../models/chess_logic.dart';
import '../widgets/chess_board_widget.dart';
import 'fun_page.dart';
import 'chat_page.dart';

class GamePageChess extends StatefulWidget {
  final int betAmount;

  const GamePageChess({Key? key, required this.betAmount}) : super(key: key);

  @override
  _GamePageChessState createState() => _GamePageChessState();
}

class _GamePageChessState extends State<GamePageChess> {
  late ChessLogic chessLogic;
  List<String> moveHistory = [];

  @override
  void initState() {
    super.initState();
    chessLogic = ChessLogic.initial();
  }

  void _handleMove(int fromRow, int fromCol, int toRow, int toCol) {
    setState(() {
      if (chessLogic.movePiece(fromRow, fromCol, toRow, toCol)) {
        moveHistory.add('${fromRow}${fromCol} -> ${toRow}${toCol}');
        if (chessLogic.isCheckmate(chessLogic.isWhiteTurn)) {
          _showEndGameDialog("Checkmate! Game Over.");
        } else if (chessLogic.isCheck(chessLogic.isWhiteTurn)) {
          _showEndGameDialog("Check!");
        }
      }
    });
  }

  void _showEndGameDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Game Over"),
          content: Text(message),
          actions: [
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => FunPage(userBalance: 100.0)),
                );
              },
            ),
          ],
        );
      },
    );
  }

  void _confirmExit() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text("Confirmar Saída"),
          content: Text("Você tem certeza que deseja sair? Você perderá as moedas."),
          actions: [
            TextButton(
              child: Text("Cancelar"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text("Sair", style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => FunPage(userBalance: 100.0)),
                );
              },
            ),
          ],
        );
      },
    );
  }

  void _showChatDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.6,
            child: ChatPage(
              friendName: "Amigo",
              friendPhotoUrl: "assets/icons/user.png",
              isOnline: true,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(color: Colors.grey[850]),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Valendo:',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      SizedBox(width: 5),
                      Text(
                        '\$${widget.betAmount}',
                        style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: 5),
                      Image.asset(
                        'assets/icons/moeda.png',
                        width: 20,
                        height: 20,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.width,
                      child: ChessBoardWidget(
                        chessLogic: chessLogic,
                        onMove: _handleMove,
                      ),
                    ),
                  ),
                ),
                Container(
                  color: Colors.black,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(Icons.emoji_emotions, color: Colors.white, size: 30),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: Icon(Icons.chat, color: Colors.white, size: 26),
                        onPressed: _showChatDialog,
                      ),
                      IconButton(
                        icon: Icon(Icons.arrow_back, color: Colors.white, size: 24),
                        onPressed: () {},
                      ),
                      ElevatedButton(
                        onPressed: _confirmExit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Sair',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              top: 0,
              right: 0,
              child: Image.asset(
                'assets/icons/logoblaey.png',
                width: 99,
                height: 40,
              ),
            ),
          ],
        ),
      ),
    );
  }
}