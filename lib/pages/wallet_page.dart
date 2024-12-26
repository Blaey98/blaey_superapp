import 'package:flutter/material.dart';
import 'dart:async';
import 'subscription_page.dart';
import 'rewarded_ad_page.dart';
import 'bonus_page.dart';
import 'store_page.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'upgrade_ponto_de_recarga.dart';
import 'recarga_pro.dart';

class WalletPage extends StatefulWidget {
  @override
  _WalletPageState createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> with TickerProviderStateMixin {
  double userBalance = 0.0;
  int currentLevel = 1;
  int adsWatched = 0;
  Timer? levelTimer;
  Timer? checkpointTimer;
  Timer? regressionTimer;
  bool isWatchingAd = false;
  bool isAtCheckpoint = false;
  bool showLevelText = false;
  bool showCoinAnimation = false; // Controla a visibilidade da animação "+1,00"
  late AnimationController _progressController;
  late AnimationController _coinController;
  late AnimationController _balanceController;
  late AnimationController _flashController;
  late Animation<double> _progressAnimation;
  late Animation<Offset> _coinAnimation;
  late Animation<Color?> _balanceColorAnimation;
  late Animation<double> _flashAnimation;

  static const int level1Ads = 4;
  static const int level2Ads = 6;
  static const int level3Ads = 8;
  static const int checkpointDelaySeconds = 30; // 30 seconds delay at each checkpoint
  static const int regressionIntervalSeconds = 60; // 60 seconds regression interval

  @override
  void initState() {
    super.initState();
    startLevelTimer();

    // Initialize the animation controllers
    _progressController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000), // Slower animation for progress
    );

    _coinController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );

    _balanceController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300), // Faster animation duration
    );

    _flashController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    )..repeat(reverse: true);

    // Initialize the animations
    _progressAnimation = Tween<double>(begin: 0, end: 1).animate(_progressController);
    _coinAnimation = Tween<Offset>(begin: Offset(0, 1), end: Offset(0, -2)).animate(_coinController);
    _balanceColorAnimation = ColorTween(begin: Colors.white, end: Colors.green)
        .animate(CurvedAnimation(parent: _balanceController, curve: Curves.easeInOut));
    _flashAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(_flashController);

    startProgressRegression();
  }

  @override
  void dispose() {
    levelTimer?.cancel();
    checkpointTimer?.cancel();
    regressionTimer?.cancel();
    _progressController.dispose();
    _coinController.dispose();
    _balanceController.dispose();
    _flashController.dispose();
    super.dispose();
  }

  void startLevelTimer() {
    levelTimer?.cancel();
    levelTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (!isWatchingAd && !isAtCheckpoint) {
        if (adsWatched > 0) {
          setState(() {
            isAtCheckpoint = true;
            checkpointTimer = Timer(Duration(seconds: checkpointDelaySeconds), () {
              regressionTimer = Timer.periodic(Duration(seconds: regressionIntervalSeconds), (timer) {
                if (!isWatchingAd && adsWatched > 0) {
                  setState(() {
                    adsWatched--;
                    _progressController.reverse(from: _progressController.value);
                  });
                } else {
                  regressionTimer?.cancel();
                }
              });
              isAtCheckpoint = false;
            });
          });
        } else if (currentLevel > 1) {
          setState(() {
            currentLevel--;
            adsWatched = currentLevel == 2 ? level1Ads : currentLevel == 3 ? level2Ads : level3Ads; // Reset adsWatched based on the new level
            _showLevelUpMessage("Nível $currentLevel");
          });
        }
      }
    });
  }

  void startProgressRegression() {
    regressionTimer?.cancel();
    regressionTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (!isWatchingAd && !isAtCheckpoint && _progressController.value > 0) {
        setState(() {
          _progressController.value -= 1 / regressionIntervalSeconds;
        });
      }
    });
  }

  void _addReward(double reward) {
    setState(() {
      userBalance += reward;
      _balanceController.forward().then((_) {
        _balanceController.reverse();
      });
    });
  }

  void _watchAd() async {
    isWatchingAd = true;
    final reward = await Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) => RewardedAdPage(),
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
    );
    isWatchingAd = false;

    if (reward != null) {
      setState(() {
        showCoinAnimation = true; // Mostrar a animação "+1,00"

        if (currentLevel == 3 && adsWatched >= level3Ads) {
          // No change in adsWatched if already at max in level 3
        } else {
          adsWatched++;
        }

        _progressController.forward(from: _progressController.value);
        _flashController.forward().then((_) {
          _flashController.reverse();
        });

        if (currentLevel == 1 && adsWatched >= level1Ads) {
          _showLevelUpMessage("Nível 2");
          currentLevel = 2;
          adsWatched = 0;
        } else if (currentLevel == 2 && adsWatched >= level2Ads) {
          _showLevelUpMessage("Nível 3");
          currentLevel = 3;
          adsWatched = 0;
        } else if (currentLevel == 3 && adsWatched >= level3Ads) {
          // Keep the adsWatched at max and start regression
          setState(() {
            adsWatched = level3Ads;
          });
        }

        // Executa a animação da moeda e atualiza o saldo quando a animação estiver concluída
        _coinController.reset();
        _coinController.forward().then((_) {
          _addReward(currentLevel.toDouble());
          setState(() {
            showCoinAnimation = false; // Ocultar a animação "+1,00" após a conclusão
          });
        });
      });
    }
  }

  void _showLevelUpMessage(String message) {
    setState(() {
      showLevelText = true;
    });

    Timer(Duration(seconds: 1), () {
      setState(() {
        showLevelText = false;
      });
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message, style: TextStyle(color: Colors.white, fontSize: 24)),
          ],
        ),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.fixed,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  'Ponto de Recarga',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold), // Aumenta o tamanho do texto
                ),
                SizedBox(width: 3),
                Icon(Icons.local_gas_station, color: Colors.black, size: 24),
              ],
            ),
            IconButton(
              icon: Icon(Icons.workspace_premium),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SubscriptionPage()),
                );
              },
            ),
          ],
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(11.0),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AnimatedBuilder(
                  animation: _balanceColorAnimation,
                  builder: (context, child) {
                    return Container(
                      padding: EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'Saldo atual:',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 7),
                          Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/icons/moeda.png',
                                  width: 40,
                                  height: 40,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  '\$${userBalance.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: _balanceColorAnimation.value,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                SizedBox(height: 20),
                _buildBonusAndStore(context),
                _buildRechargePoint(context),
              ],
            ),
            if (showCoinAnimation)
              AnimatedBuilder(
                animation: _coinController,
                builder: (context, child) {
                  return Positioned(
                    top: 100 + (_coinAnimation.value.dy * 200),
                    left: MediaQuery.of(context).size.width / 2 - 50,
                    child: Row(
                      children: [
                        Text(
                          "+\$${currentLevel.toDouble().toStringAsFixed(2)}",
                          style: TextStyle(
                            fontSize: 24,
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 8),
                        Image.asset(
                          'assets/icons/moeda.png',
                          width: 40,
                          height: 40,
                        ),
                      ],
                    ),
                  );
                },
              ),
            Center(
              child: Visibility(
                visible: showLevelText,
                child: Text(
                  currentLevel == 2 ? "Nível 2" : currentLevel == 3 ? "Nível 3" : "",
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => UpgradePontoDeRecargaPage()),
          );
        },
        backgroundColor: Colors.orange, // Cor dourada
        child: Icon(
          Icons.workspace_premium,
          color: Colors.white, // Ícone branco
        ),
        elevation: 10, // Sombra
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildBonusAndStore(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey), // Adiciona a borda
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Centraliza "Bônus" e "Loja"
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => BonusPage()),
                  );
                },
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.card_giftcard, size: 30, color: Colors.blue),
                        SizedBox(width: 5),
                        Text(
                          'Bônus',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => StorePage(updateBalance: _addReward)),
                  );
                },
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.store, size: 30, color: Colors.green),
                        SizedBox(width: 5),
                        Text(
                          'Loja',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRechargePoint(BuildContext context) {
    int totalAds = currentLevel == 1 ? level1Ads : currentLevel == 2 ? level2Ads : level3Ads;

    Color progressColor;
    switch (currentLevel) {
      case 1:
        progressColor = Colors.blue;
        break;
      case 2:
        progressColor = Colors.red;
        break;
      case 3:
        progressColor = Colors.black;
        break;
      default:
        progressColor = Colors.blue;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 29),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  'Nível $currentLevel',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 8),
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: progressColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
            Text(
              'Período',
              style: TextStyle(fontSize: 16), // Sem negrito e na mesma altura de Nível 1
            ),
          ],
        ),
        SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  '+\$${currentLevel.toDouble().toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                SizedBox(width: 2), // Diminui o espaço entre Nível e 1,00
                Image.asset(
                  'assets/icons/moeda.png',
                  width: 20,
                  height: 20,
                ),
              ],
            ),
            Row(
              children: [
                Icon(Icons.schedule, size: 20), // Ícone antes de 1/4
                SizedBox(width: 4),
                Text(
                  '$adsWatched/$totalAds',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 32),
        Center(
          child: GestureDetector(
            onTap: _watchAd,
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 260,
                      height: 260,
                      child: CircularProgressIndicator(
                        value: adsWatched / totalAds,
                        backgroundColor: Colors.grey[300], // Light grey color for the base
                        valueColor: AlwaysStoppedAnimation<Color>(progressColor),
                        strokeWidth: 20, // Thicker progress bar
                        strokeCap: StrokeCap.round, // Rounded edges for the progress bar
                      ),
                    ),
                    Neumorphic(
                      style: NeumorphicStyle(
                        depth: -10,
                        color: progressColor, // Solid color for the button
                        boxShape: NeumorphicBoxShape.circle(),
                        lightSource: LightSource.topLeft,
                        shadowLightColorEmboss: Colors.white,
                        shadowDarkColorEmboss: Colors.black.withOpacity(0.7), // Inner shadow color
                      ),
                      child: Container(
                        width: 200,
                        height: 200,
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.play_arrow_rounded,
                          color: Colors.white, // White play icon
                          size: 100,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// Página UpgradePontoDeRecargaPage
class UpgradePontoDeRecargaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upgrade Ponto de Recarga'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Ganhe moedas sem anúncios!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'Com a Recarga Pró, você não precisa perder seu tempo com anúncios:',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Text(
              '- Clicou, recebeu instantaneamente!\n- Até 400 Moedas a cada 2 hrs\n- Maior conforto e tranquilidade',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 40),
            Text(
              'Teste grátis por 7 dias, depois R\$ 19,90/mês.',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RecargaProPage()),
                );
              },
              style: ButtonStyle(
                padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 32, vertical: 16)), // Aumenta o padding do botão
                textStyle: MaterialStateProperty.all(TextStyle(fontSize: 18)), // Aumenta o tamanho do texto
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8), // Bordas arredondadas
                  ),
                ),
                // Degradê dourado
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                    return Colors.transparent; // Deixa transparente para aplicar o degradê
                  },
                ),
                shadowColor: MaterialStateProperty.all(Colors.transparent), // Remove a sombra padrão
              ),
              child: Ink(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFFFD700), Color(0xFFFFA500)], // Degradê do dourado para o laranja
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  child: Text(
                    'Testar Grátis por 7 dias',
                    style: TextStyle(color: Colors.black), // Texto preto
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Página RecargaProPage
class RecargaProPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recarga Pró'),
      ),
      body: Center(
        child: Text(
          'Bem-vindo à Recarga Pró!',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}