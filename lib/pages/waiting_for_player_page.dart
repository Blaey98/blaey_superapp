import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'negotiation_page.dart';

class WaitingForPlayerPage extends StatefulWidget {
  final String gameTitle;

  WaitingForPlayerPage({required this.gameTitle});

  @override
  _WaitingForPlayerPageState createState() => _WaitingForPlayerPageState();
}

class _WaitingForPlayerPageState extends State<WaitingForPlayerPage> with TickerProviderStateMixin {
  bool _isRedPlayerVisible = false;
  late AnimationController _bluePlayerController;
  late AnimationController _redPlayerController;
  late Animation<Offset> _bluePlayerAnimation;
  late Animation<Offset> _redPlayerAnimation;

  @override
  void initState() {
    super.initState();

    _bluePlayerController = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );

    _redPlayerController = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );

    _bluePlayerAnimation = Tween<Offset>(
      begin: Offset(-1, 0),
      end: Offset(0, 0),
    ).animate(CurvedAnimation(
      parent: _bluePlayerController,
      curve: Curves.easeInOutBack, // Curva de animação para um efeito de confronto
    ));

    _redPlayerAnimation = Tween<Offset>(
      begin: Offset(1, 0),
      end: Offset(0, 0),
    ).animate(CurvedAnimation(
      parent: _redPlayerController,
      curve: Curves.easeInOutBack, // Curva de animação para um efeito de confronto
    ));

    _bluePlayerController.forward();
  }

  @override
  void dispose() {
    _bluePlayerController.dispose();
    _redPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String gameImagePath;
    switch (widget.gameTitle.toLowerCase()) {
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

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF16D735), // Altera o fundo do AppBar para verde
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        color: Color(0xFF16D735), // Fundo verde (#16D735)
        width: double.infinity, // Garantir que a largura ocupe toda a tela
        height: double.infinity, // Garantir que a altura ocupe toda a tela
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SlideTransition(
                        position: _bluePlayerAnimation,
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 60, // Aumentar o tamanho do avatar
                              backgroundColor: Colors.green,
                              backgroundImage: AssetImage('assets/icons/perfil.png'),
                            ),
                            SizedBox(height: 16), // Espaço abaixo do avatar
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              color: Colors.black,
                              child: Text(
                                'Username',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 20),
                      Column(
                        children: [
                          // Substituir o texto "VS" grande pela imagem
                          Image.asset(
                            'assets/icons/vs.png',
                            width: 120,
                            height: 120,
                          ),
                          SizedBox(height: 20), // Espaço acima da imagem do jogo
                          Image.asset(
                            gameImagePath,
                            width: 100,
                            height: 100,
                          ),
                          SizedBox(height: 20),
                          // Substituir o texto "Aguardando..." pela animação de pontinhos
                          SpinKitThreeBounce(
                            color: Colors.white,
                            size: 30.0,
                          ),
                        ],
                      ),
                      SizedBox(width: 20),
                      SlideTransition(
                        position: _redPlayerAnimation,
                        child: Column(
                          children: [
                            AnimatedOpacity(
                              opacity: _isRedPlayerVisible ? 1.0 : 0.0,
                              duration: Duration(milliseconds: 500),
                              child: CircleAvatar(
                                radius: 60, // Aumentar o tamanho do avatar
                                backgroundColor: Colors.red,
                                backgroundImage: AssetImage('assets/icons/oponente.png'),
                              ),
                            ),
                            SizedBox(height: 16), // Espaço acima do avatar do oponente
                            AnimatedOpacity(
                              opacity: _isRedPlayerVisible ? 1.0 : 0.0,
                              duration: Duration(milliseconds: 500),
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                color: Colors.black,
                                child: Text(
                                  'Oponente',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _isRedPlayerVisible = true;
                      });
                      _redPlayerController.forward();
                      Future.delayed(Duration(seconds: 2), () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => NegotiationPage(gameTitle: widget.gameTitle)),
                        );
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    child: Text('Encontrar Jogador'),
                  ),
                ],
              ),
            ),
            // Adicionar a imagem no canto inferior direito
            Positioned(
              bottom: 10,
              right: 10,
              child: Image.asset(
                'assets/icons/logoblaey.png',
                width: 130,
                height: 90,
              ),
            ),
          ],
        ),
      ),
    );
  }
}