import 'package:flutter/material.dart';
import 'dart:math';
import 'gamepage_dama.dart';
import 'gamepage_chess.dart';
import 'gamepage_ludo.dart';
import 'gamepage_truco.dart';
import 'gamepage_jogo_da_velha.dart';

class WaitingDiretoPage extends StatefulWidget {
  final String gameTitle;

  WaitingDiretoPage({required this.gameTitle});

  @override
  _WaitingDiretoPageState createState() => _WaitingDiretoPageState();
}

class _WaitingDiretoPageState extends State<WaitingDiretoPage> with TickerProviderStateMixin {
  bool _isRedPlayerVisible = false;
  late AnimationController _redPlayerController;
  late Animation<Offset> _redPlayerAnimation;
  late String _selectedOpponent;
  late ScrollController _scrollController;

  final List<String> opponentImages = [
    'assets/users/oponente.png',
    'assets/users/oponente1.png',
    'assets/users/oponente2.png',
    'assets/users/oponente3.png',
    'assets/users/oponente4.png',
    'assets/users/oponente5.png',
    'assets/users/oponente6.png',
  ];

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController();
    _redPlayerController = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );

    _redPlayerAnimation = Tween<Offset>(
      begin: Offset(0, -1), // Começa de cima
      end: Offset(0, 0),
    ).animate(CurvedAnimation(
      parent: _redPlayerController,
      curve: Curves.easeInOutBack,
    ));

    _selectedOpponent = opponentImages.first; // Inicializar a variável

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startWheelAnimation();
    });
  }

  @override
  void dispose() {
    _redPlayerController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _startWheelAnimation() {
    // Inicia a roleta girando mais devagar
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(seconds: 4),
      curve: Curves.linear,
    );

    Future.delayed(Duration(seconds: 4), () {
      // Seleciona um oponente aleatório
      int selectedIndex = Random().nextInt(opponentImages.length);
      _selectedOpponent = opponentImages[selectedIndex];

      _scrollController.animateTo(
        selectedIndex * 100.0,
        duration: Duration(seconds: 1),
        curve: Curves.easeOut,
      );

      setState(() {
        _isRedPlayerVisible = true;
      });

      _redPlayerController.forward();

      // Exibe o oponente por 2 segundos antes de iniciar o jogo
      Future.delayed(Duration(seconds: 2), () {
        _startGame();
      });
    });
  }

  void _startGame() {
    Widget gamePage;
    switch (widget.gameTitle.toLowerCase()) {
      case 'dama':
        gamePage = GamePageDama(betAmount: 100);
        break;
      case 'xadrez':
        gamePage = GamePageChess(betAmount: 100);
        break;
      case 'ludo':
        gamePage = GamePageLudo(betAmount: 100);
        break;
      case 'truco':
        gamePage = GamePageTruco(betAmount: 100);
        break;
      case 'jogo da velha':
        gamePage = GamePageJogoDaVelha(betAmount: 100);
        break;
      default:
        gamePage = GamePageDama(betAmount: 100);
        break;
    }
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => gamePage),
    );
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
        backgroundColor: Colors.black, // Fundo do AppBar preto
        title: Text(
          'Modo Direto',
          style: TextStyle(color: Colors.white), // Texto do topo branco
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white), // Botão voltar branco
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        width: double.infinity, // Garantir que a largura ocupe toda a tela
        height: double.infinity, // Garantir que a altura ocupe toda a tela
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 0.8,
            colors: [
              Colors.grey[700]!,
              Colors.grey[850]!,
              Colors.black,
            ],
            stops: [0.0, 0.5, 1.0],
            tileMode: TileMode.mirror,
          ),
        ),
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 40), // Espaço extra para mover a roleta para cima
                  // Texto "Buscando..." acima da roleta
                  AnimatedOpacity(
                    opacity: _isRedPlayerVisible ? 0.0 : 1.0,
                    duration: Duration(milliseconds: 500),
                    child: Text(
                      'Buscando...',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 10), // Espaço abaixo do texto
                  // Roleta e oponente na mesma altura
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      AnimatedOpacity(
                        opacity: _isRedPlayerVisible ? 0.0 : 1.0,
                        duration: Duration(milliseconds: 500),
                        child: _buildOpponentSpinner(),
                      ),
                      AnimatedOpacity(
                        opacity: _isRedPlayerVisible ? 1.0 : 0.0,
                        duration: Duration(milliseconds: 500),
                        child: SlideTransition(
                          position: _redPlayerAnimation,
                          child: Column(
                            children: [
                              CircleAvatar(
                                radius: 60, // Aumentar o tamanho do avatar
                                backgroundColor: Colors.red,
                                backgroundImage: AssetImage(_selectedOpponent),
                              ),
                              SizedBox(height: 16), // Espaço acima do avatar do oponente
                              Text(
                                'Oponente',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  // Imagem do jogo no meio, aumentada
                  Image.asset(
                    gameImagePath,
                    width: 200, // Aumentar largura da imagem do jogo
                    height: 200, // Aumentar altura da imagem do jogo
                  ),
                  SizedBox(height: 20),
                  // Perfil abaixo
                  Column(
                    children: [
                      CircleAvatar(
                        radius: 60, // Aumentar o tamanho do avatar
                        backgroundColor: Colors.green,
                        backgroundImage: AssetImage('assets/icons/perfil.png'),
                      ),
                      SizedBox(height: 16), // Espaço abaixo do avatar
                      Text(
                        'Username',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
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

  Widget _buildOpponentSpinner() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0), // Adicionar padding nas laterais
      height: 100,
      child: ListView.builder(
        controller: _scrollController,
        scrollDirection: Axis.horizontal, // Rota horizontal
        itemCount: opponentImages.length * 100, // Número grande para fazer a roleta girar
        itemBuilder: (context, index) {
          final image = opponentImages[index % opponentImages.length];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: CircleAvatar(
              radius: 40, // Raio dos avatares
              backgroundImage: AssetImage(image),
            ),
          );
        },
      ),
    );
  }
}