import 'package:flutter/material.dart';
import 'dart:async';
import 'negotiation_page.dart';

class ChatPage extends StatefulWidget {
  final String friendName;
  final String friendPhotoUrl;
  final bool isOnline;

  ChatPage({
    required this.friendName,
    required this.friendPhotoUrl,
    required this.isOnline,
  });

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _controller = TextEditingController();
  List<Map<String, dynamic>> messages = [];
  Timer? _challengeTimer;
  int _remainingTime = 30;
  bool _bothAccepted = false;

  void _sendMessage(String text) {
    if (text.isNotEmpty) {
      setState(() {
        messages.add({
          'sender': 'Você',
          'message': text,
          'timestamp': DateTime.now().toLocal().toString().substring(11, 16),
          'date': DateTime.now().toLocal().toString().substring(0, 10), // Adiciona a data
        });
      });
      _controller.clear();
    }
  }

  void _sendChallenge(String gameTitle, String gameImage) {
    Navigator.of(context).pop(); // Fechar a página de seleção de jogos

    setState(() {
      messages.add({
        'sender': 'Você',
        'message': 'Desafio para jogar $gameTitle',
        'type': 'challenge',
        'gameTitle': gameTitle,
        'gameImage': gameImage,
        'timestamp': DateTime.now().toLocal().toString().substring(11, 16),
        'date': DateTime.now().toLocal().toString().substring(0, 10), // Adiciona a data
        'challengeAccepted': false,
        'challengeDeclined': false,
        'friendAccepted': false,
        'waitingForFriend': false,
      });
    });

    // Inicia o timer de 30 segundos para expirar o desafio
    _startTimer();
  }

  void _startTimer() {
    _challengeTimer?.cancel();
    _remainingTime = 30;
    _challengeTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingTime > 0) {
          _remainingTime--;
        } else {
          _expireChallenge();
          timer.cancel();
        }
      });
    });
  }

  void _expireChallenge() {
    setState(() {
      final challengeMessage = messages.lastWhere(
            (msg) => msg['type'] == 'challenge' && !msg['challengeAccepted'] && !msg['challengeDeclined'],
        orElse: () => {},
      );
      if (challengeMessage.isNotEmpty) {
        challengeMessage['message'] = 'Desafio expirado. Crie um novo desafio.';
        challengeMessage['challengeExpired'] = true;
      }
    });
  }

  void _acceptChallenge(int index) {
    setState(() {
      messages[index]['challengeAccepted'] = true;
      messages[index]['waitingForFriend'] = true; // Indica que o usuário está aguardando o amigo
    });

    // A lógica para aguardar a aceitação do amigo
    if (messages[index]['challengeAccepted'] && messages[index]['friendAccepted']) {
      _bothAccepted = true;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NegotiationPage(gameTitle: messages[index]['gameTitle']),
        ),
      );
    }
  }

  void _declineChallenge(int index) {
    setState(() {
      messages[index]['challengeDeclined'] = true;
    });
    _challengeTimer?.cancel();
  }

  void _showGameSelectionDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white, // Alterar cor de fundo para branco
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Criar um desafio',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Container(
                  padding: EdgeInsets.all(6.0),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.close, color: Colors.white, size: 20),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                shrinkWrap: true,
                children: [
                  _buildGameTile('Damas', 'assets/jogos/dama.png'),
                  _buildGameTile('Xadrez', 'assets/jogos/xadrez.png'),
                  _buildGameTile('Ludo', 'assets/jogos/ludo.png'),
                  _buildGameTile('Truco', 'assets/jogos/truco.png'),
                  _buildGameTile('Jogo da Velha', 'assets/jogos/jogo_da_velha.png'),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildGameTile(String gameTitle, String gameImage) {
    return GestureDetector(
      onTap: () => _sendChallenge(gameTitle, gameImage),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(gameImage, width: 80, height: 80), // Aumentar o tamanho dos jogos
          SizedBox(height: 5),
          Text(gameTitle, style: TextStyle(fontSize: 14)),
        ],
      ),
    );
  }

  void _showEmojiPicker() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Escolha um emoji'),
          content: GridView.count(
            crossAxisCount: 5,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            shrinkWrap: true,
            children: [
              '😀', '😁', '😂', '🤣', '😃', '😄', '😅', '😆', '😉', '😊', '😋', '😎', '😍', '😘', '😗', '😙', '😚', '☺️', '🙂', '🤗'
            ].map((emoji) {
              return GestureDetector(
                onTap: () {
                  _controller.text += emoji;
                  Navigator.of(context).pop();
                },
                child: Center(child: Text(emoji, style: TextStyle(fontSize: 24))),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _challengeTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 100, // Ajusta a largura do leading para caber a foto de perfil e o botão voltar
        leading: Row(
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            CircleAvatar(
              radius: 20,
              backgroundImage: AssetImage('assets/images/user.png'), // Usar imagem local
            ),
          ],
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.friendName, style: TextStyle(fontSize: 18)),
            if (widget.isOnline)
              Text('Online', style: TextStyle(fontSize: 12, color: Colors.green)),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.dashboard_customize_outlined, size: 28),
            onPressed: _showGameSelectionDialog,
          ),
          IconButton(
            icon: Icon(Icons.more_vert, size: 28),
            onPressed: () {
              // Adicione a lógica aqui para os três pontinhos
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/icons/fundo_mensagem.png',
              fit: BoxFit.cover,
            ),
          ),
          Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (index == 0 || messages[index]['date'] != messages[index - 1]['date'])
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 5),
                            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              messages[index]['date'],
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        Align(
                          alignment: message['type'] == 'challenge'
                              ? Alignment.centerRight
                              : (message['sender'] == 'Você' ? Alignment.centerRight : Alignment.centerLeft),
                          child: Container(
                            margin: EdgeInsets.symmetric(vertical: 5),
                            padding: EdgeInsets.all(10),
                            constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width * 0.7,
                            ),
                            decoration: BoxDecoration(
                              color: message['sender'] == 'Você' ? Color(0xFF82FA88) : Colors.grey[300],
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(15),
                                topRight: Radius.circular(15),
                                bottomLeft: message['sender'] == 'Você' ? Radius.circular(15) : Radius.circular(0),
                                bottomRight: message['sender'] == 'Você' ? Radius.circular(0) : Radius.circular(15),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (message['type'] == 'challenge')
                                  _buildChallengeMessage(message, index)
                                else
                                  Text(
                                    message['message'],
                                    style: TextStyle(
                                      color: message['sender'] == 'Você' ? Colors.black : Colors.black,
                                    ),
                                  ),
                                SizedBox(height: 5),
                                Text(
                                  message['timestamp'],
                                  style: TextStyle(
                                    color: message['sender'] == 'Você' ? Colors.black54 : Colors.black54,
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.emoji_emotions_outlined),
                        onPressed: _showEmojiPicker,
                      ),
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          decoration: InputDecoration(
                            hintText: 'Digite uma mensagem',
                            border: InputBorder.none,
                          ),
                          onSubmitted: _sendMessage, // Envia a mensagem ao pressionar Enter
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Color(0xFF50C717), // Botão verde
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: Icon(Icons.send, color: Colors.white), // Ícone branco
                          onPressed: () => _sendMessage(_controller.text),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChallengeMessage(Map<String, dynamic> message, int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'O desafio expira em:',
              style: TextStyle(
                color: message['sender'] == 'Você' ? Colors.black : Colors.black,
                fontSize: 12,
              ),
            ),
            SizedBox(width: 5),
            Text(
              '0:${_remainingTime.toString().padLeft(2, '0')}seg',
              style: TextStyle(
                color: message['sender'] == 'Você' ? Colors.black : Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
        SizedBox(height: 5),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              '${widget.friendName} te desafiou',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18, // Aumentar o texto
                height: 1.0, // Menor espaçamento entre linhas
              ),
            ),
            Text(
              'para jogar ${message['gameTitle']}',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18, // Aumentar o texto
                height: 1.0, // Menor espaçamento entre linhas
              ),
            ),
          ],
        ),
        SizedBox(height: 5),
        Container(
          padding: EdgeInsets.all(5),
          width: MediaQuery.of(context).size.width * 0.85, // Ocupando 85% da largura
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black45),
            borderRadius: BorderRadius.circular(10), // Borda arredondada
            color: Color(0xFF292626), // Fundo preto fosco
          ),
          child: Image.asset(
            message['gameImage'],
            width: 120,
            height: 120,
          ),
        ),
        SizedBox(height: 5),
        if (!message['challengeAccepted'] && !message['challengeDeclined'] && !_isChallengeExpired(message))
          Column(
            children: [
              ElevatedButton(
                onPressed: () => _acceptChallenge(index),
                child: Text('Entrar no desafio'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF50C717), // Botão verde
                  foregroundColor: Colors.white, // Letra branca
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15), // Aumentar os botões
                ),
              ),
              SizedBox(height: 5),
              ElevatedButton(
                onPressed: () => _declineChallenge(index),
                child: Text('Não aceitar'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white, // Cor do texto em branco
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15), // Aumentar os botões
                ),
              ),
            ],
          )
        else if (_isChallengeExpired(message))
          Text(
            'Desafio expirado. Crie um novo desafio.',
            style: TextStyle(
              color: message['sender'] == 'Você' ? Colors.black : Colors.black,
              fontWeight: FontWeight.normal, // Remover negrito
            ),
          )
        else if (message['waitingForFriend'])
            Text(
              'Aguardando ${widget.friendName} entrar...',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.normal, // Texto sem negrito
              ),
            ),
      ],
    );
  }

  bool _isChallengeExpired(Map<String, dynamic> message) {
    return message.containsKey('challengeExpired') && message['challengeExpired'];
  }
}

class NegotiationPage extends StatelessWidget {
  final String gameTitle;

  NegotiationPage({required this.gameTitle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Negociação para $gameTitle'),
      ),
      body: Center(
        child: Text('Página de Negociação para $gameTitle'),
      ),
    );
  }
}